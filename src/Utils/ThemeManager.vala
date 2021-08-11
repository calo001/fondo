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
using App.Models;

namespace App.Utils {
    /**
     * The {@code ThemeManager} class.
     *
     * @since 1.0.0
     */

    public class ThemeManager {
        private Gtk.Settings            gtk_settings;
        private App.Configs.Settings    app_settings;
        private Granite.Settings        granite_settings;

        public ThemeManager (
            Gtk.Settings gtk_settings,
            App.Configs.Settings app_settings,
            Granite.Settings granite_settings
        ) {    
            this.gtk_settings = gtk_settings;
            this.app_settings = app_settings;
            this.granite_settings = granite_settings;

            init();
        }

        private void init () {
            message ("Theme manager init");
            var mode = app_settings.mode_theme;
                switch (mode) {
                    case "follow-system":
                        gtk_settings.gtk_application_prefer_dark_theme = (
                            granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
                        );
                    break;
                    case "light":
                        gtk_settings.gtk_application_prefer_dark_theme = false;
                    break;
                    case "dark":
                        gtk_settings.gtk_application_prefer_dark_theme = true;  
                    break;
                }
    
            message ("setup notify");
            granite_settings.notify["prefers-color-scheme"].connect (() => {
                message ("notify color scheme change");
                if (app_settings.mode_theme == "follow-system") {
                    gtk_settings.gtk_application_prefer_dark_theme = (
                        granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
                    );
                }
            });

            //  granite_settings.notify["prefers_accent_color"].connect (() => {
            //      message ("notify accent color scheme change");
            //      Gtk.StyleContext.reset_widgets (
            //          Gdk.Screen.get_default ()
            //      );
            //  });

            app_settings.notify["mode-theme"].connect (() => {
                message ("theme mode change");
                switch (app_settings.mode_theme) {
                    case "follow-system":
                        gtk_settings.gtk_application_prefer_dark_theme = (
                            granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
                        );
                    break;
                    case "light":
                        gtk_settings.gtk_application_prefer_dark_theme = false;
                    break;
                    case "dark":
                        gtk_settings.gtk_application_prefer_dark_theme = true;  
                    break;
                }
            });
        }
    }
}