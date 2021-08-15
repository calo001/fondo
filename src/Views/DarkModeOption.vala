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

namespace App.Views {

    /**
     * The {@code DarkModeOption} class.
     *
     * @since 1.0.0
     */
    public class DarkModeOption : Gtk.Box {
        public string filtermode { get; set; }
        private App.Configs.Settings app_settings;

        /**
         * Constructs a new {@code DarkModeOption} object.
         */
        public DarkModeOption () {
            Object (
                margin: 16,
                margin_top: 0,
                hexpand: false,
                orientation: Gtk.Orientation.VERTICAL,
                homogeneous: true
            );

            this.app_settings = App.Application.app_settings;

            var follow_system = new Gtk.Box(Gtk.Orientation.VERTICAL, 8);
            var icon_follow_system = new Gtk.Image () {
                gicon = new ThemedIcon ("emblem-system"),
                pixel_size = 24
            };
            icon_follow_system.margin = 4;
            var label_follow_system = new Gtk.Label(S.FOLLOW_SYSTEM_MODE);
            follow_system.add (icon_follow_system);
            follow_system.add (label_follow_system);

            var force_light = new Gtk.Box(Gtk.Orientation.VERTICAL, 8);
            var icon_force_light = new Gtk.Image () {
                gicon = new ThemedIcon ("weather-clear"),
                pixel_size = 32
            };
            var label_force_light = new Gtk.Label(S.LIGHT_MODE);
            force_light.add (icon_force_light);
            force_light.add (label_force_light);

            var force_dark = new Gtk.Box(Gtk.Orientation.VERTICAL, 8);
            var icon_force_dark = new Gtk.Image () {
                gicon = new ThemedIcon ("weather-clear-night"),
                pixel_size = 32
            };
            var label_force_dark = new Gtk.Label(S.DARK_MODE);
            force_dark.add (icon_force_dark);
            force_dark.add (label_force_dark);

            var mode_button = new Granite.Widgets.ModeButton ();
            mode_button.append (follow_system);
            mode_button.append (force_light);
            mode_button.append (force_dark);
            
            var selectedIndex = 0;
            
            switch (app_settings.mode_theme) {
                case "follow-system":
                selectedIndex = 0;
                break;
                case "light":
                selectedIndex = 1;
                break;
                case "dark":
                selectedIndex = 2;
                break;
            }

            mode_button.selected = selectedIndex;

            mode_button.notify["selected"].connect (() => {
                switch (mode_button.selected) {
                    case 0:
                    app_settings.mode_theme = "follow-system";
                    break;
                    case 1:
                    app_settings.mode_theme = "light";
                    break;
                    case 2:
                    app_settings.mode_theme = "dark";
                    break;
                }    
            });

            app_settings.notify["mode_theme"].connect (() => {
                switch (app_settings.mode_theme) {
                    case "follow-system":
                    mode_button.selected = 1;
                    break;
                    case "light":
                    mode_button.selected = 2;
                    break;
                    case "dark":
                    mode_button.selected = 3;
                    break;
                }
            });

            var lbl_mode_optios = new Gtk.Label ("Estilo");
            lbl_mode_optios.get_style_context ().add_class ("h4");
            lbl_mode_optios.margin_top = 8;
            lbl_mode_optios.halign = Gtk.Align.START;

            add (lbl_mode_optios);
            add (mode_button);
        }
    }
}