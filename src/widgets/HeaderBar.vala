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

namespace App.Widgets {

    /**
     * The {@code HeaderBar} class is responsible for displaying top bar. Similar to a horizontal box.
     *
     * @see Gtk.HeaderBar
     * @since 1.0.0
     */
    public class HeaderBar : Gtk.HeaderBar {

        private Gtk.Button              btn_more;
        /**
         * Constructs a new {@code HeaderBar} object.
         *
         * @see App.Configs.Properties
         * @see icon_settings
         */
        public HeaderBar () {
            this.set_title ("Fondo");
            this.show_close_button = true;
            get_style_context ().add_class ("transition");
            get_style_context ().add_class ("fondo-header");
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            get_style_context ().add_class ("default-decoration");

            var randomize_button = new Gtk.Button.from_icon_name ("media-playlist-shuffle-symbolic");
            randomize_button.margin_end = 12;
            randomize_button.tooltip_text = _("Load a random principle");

            var gtk_settings = Gtk.Settings.get_default ();

            var mode_switch = new ModeSwitch (
                "display-brightness-symbolic",
                "weather-clear-night-symbolic"
            );
            mode_switch.margin_end = 6;
            mode_switch.primary_icon_tooltip_text = _("Light background");
            mode_switch.secondary_icon_tooltip_text = _("Dark background");
            mode_switch.valign = Gtk.Align.CENTER;
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");

            var context = get_style_context ();
            mode_switch.notify["active"].connect (() => {
                if (gtk_settings.gtk_application_prefer_dark_theme) {
                    context.add_class ("dark");
                } else {
                    context.remove_class ("dark");
                }
            });

            this.pack_end (mode_switch);
            this.pack_end (randomize_button);
        }
    }
}
