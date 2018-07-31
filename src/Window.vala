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
using App.Controllers;

namespace App {

    /**
     * Class responsible for creating the u window and will contain contain other widgets. 
     * allowing the user to manipulate the window (resize it, move it, close it, ...).
     *
     * @see Gtk.ApplicationWindow
     * @since 1.0.0
     */
    public class Window : Gtk.ApplicationWindow {
         
        public static GLib.Settings g_settings;
        /**
         * Constructs a new {@code Window} object.
         *
         * @see App.Configs.Constants
         * @see style_provider
         * @see build
         */
        public Window (Gtk.Application app) {
            Object (
                application: app,
                icon_name: Constants.APP_ICON,
                resizable: false
            );

            //get_style_context ().add_class ("rounded");

            var settings = App.Configs.Settings.get_instance ();
            int x = settings.window_x;
            int y = settings.window_y;
            bool dark = settings.use_dark_theme;

            if (x != -1 && y != -1) {
                move (x, y);
            }

            var css_provider = new Gtk.CssProvider ();
            css_provider.load_from_resource (Constants.URL_CSS);
            
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
            get_style_context ().add_class ("transition");

            // Save the window's position on close
            delete_event.connect (() => {
                int root_x, root_y;
                get_position (out root_x, out root_y);

                settings.window_x = root_x;
                settings.window_y = root_y;
                return false;
            });
        }
    }
}
