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
     * The {@code SettingsView} class.
     *
     * @since 1.0.0
     */
    public class SettingsView : Gtk.Box {
        public SettingsView() {
            var lateral = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            lateral.vexpand = true;
            lateral.width_request = 300;
            lateral.get_style_context ().add_class ("lateral-panel");

            var lbl_logo = new Gtk.Label ("Powered by Unsplash");
            lbl_logo.get_style_context ().add_class ("h4");
            lbl_logo.halign = Gtk.Align.START; 
            lbl_logo.margin_top = 8;
            lbl_logo.margin_start = 16;

            var unsplash_link = "https://unsplash.com/?utm_source=Fondo&utm_medium=referral";
            var logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/unsplashlogo.svg");
            var unsplash_button = new Gtk.LinkButton(unsplash_link);
            unsplash_button.always_show_image = true;
            unsplash_button.image = logo;
            unsplash_button.label = null;
            unsplash_button.margin = 8;
            unsplash_button.halign = Gtk.Align.CENTER;
            unsplash_button.tooltip_text = S.UNSPLASH_DESCRIPTION;
            unsplash_button.get_style_context ().add_class ("unsplash_logo");
            unsplash_button.get_style_context ().add_class ("transition");

            var filter_grid = new FilterOptionsView ();
            var dark_mode_view = new DarkModeOption ();

            lateral.add (lbl_logo);
            lateral.add (unsplash_button);
            lateral.add (filter_grid);
            lateral.add (dark_mode_view);

            var window_handler = new Hdy.WindowHandle ();
            window_handler.add (lateral);
            this.add (window_handler);
        }
    }
}