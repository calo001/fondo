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
using App.Connection;

namespace App {

    /**
     * The {@code Application} class is a foundation for all granite-based applications.
     *
     * @see Granite.Application
     * @since 1.0.0
     */
    public class Application : Granite.Application {

        public AppController            controller;
        public static GLib.Settings     settings;
        private App.Utils.ThemeManager  theme_manager;

        public static App.Configs.Settings  app_settings;
        public static Gtk.Settings          gtk_settings;
        public static Granite.Settings      granite_settins; 

        /**
         * Constructs a new {@code Application} object.
         */
        public Application () {
            Object (
                application_id: Constants.ID,
                flags: ApplicationFlags.FLAGS_NONE
            );

            var quit_action = new SimpleAction ("quit", null);
            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Control>q"});

            quit_action.activate.connect (() => {
                if (controller != null) {
                    controller.quit ();
                }
            });

             // Default Icon Theme
            weak Gtk.IconTheme default_theme = Gtk.IconTheme.get_default ();
            default_theme.add_resource_path ("/com/github/calo001/fondo/images");

            app_settings = App.Configs.Settings.get_instance ();
            gtk_settings = Gtk.Settings.get_default ();
            granite_settins = Granite.Settings.get_default ();
            settings = new GLib.Settings (Constants.ID);

            theme_manager = new App.Utils.ThemeManager(
                gtk_settings,
                app_settings,
                granite_settins
            );
        }

        /**
         * Handle attempts to start up the application
         * @return {@code void}
         */
        public override void activate () {
            if (controller == null) {
                controller = new AppController (this);
            }
            
            controller.activate ();
        }
    }
}
