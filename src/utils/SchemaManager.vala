/*
* Copyright (C) 2018  Calo001 <calo_lrc@hotmail.com>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU Affero General Public License as published
* by the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Affero General Public License for more details.
*
* You should have received a copy of the GNU Affero General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*/

using App.Configs;

namespace App.Utils {
    /**
     * The {@code SchemaManager} class.
     *
     * @since 1.3.1
     */

    public class SchemaManager {
        private GLib.Settings settings;
        private GLib.Settings settings_screensaver;
        private const string gnome_background_schema = "org.gnome.desktop.background";
        private const string gnome_screensaver_schema = "org.gnome.desktop.screensaver";
        private const string mate_background_schema = "org.mate.background";

        private int env = Constants.IS_GNOME;

        public SchemaManager () {
            // check mate
            var schema_source = GLib.SettingsSchemaSource.get_default ();
            var schema = schema_source.lookup (mate_background_schema, true);

            if (schema != null) {
                settings = new GLib.Settings.full (schema, null, null);
                env = Constants.IS_MATE;
                return;
            }

            schema = schema_source.lookup (gnome_background_schema, true);
            
            if (schema != null) {
                settings = new GLib.Settings.full (schema, null, null);
                env = Constants.IS_GNOME;
                var schema_screensaver = schema_source.lookup (gnome_screensaver_schema, true);
                if (schema_screensaver != null) {
                    settings_screensaver = new GLib.Settings.full (schema_screensaver, null, null);
                }
                return;
            }
        }

        public void set_wallpaper (string picture_path, string picture_options) {
            if (settings != null) {
                switch (env) {
                    case Constants.IS_GNOME:
                        settings.set_string ("picture-uri", "file://" + picture_path);
                        if (settings_screensaver != null) {
                            settings_screensaver.set_string ("picture-uri", "file://" + picture_path);
                        }
                        break;
                    case Constants.IS_MATE:
                        settings.set_string ("picture-filename", picture_path);
                        break;
                    default:
                        settings.set_string ("picture-uri", "file://" + picture_path);
                        break;
                }
                settings.set_string ("picture-options", picture_options);
                settings.apply ();
                GLib.Settings.sync ();
            }
        }
    }
}
