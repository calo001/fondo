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
        public signal void on_close_click ();

        public SettingsView() {
            var lateral = new Gtk.Grid();
            lateral.vexpand = true;
            lateral.width_request = 300;
            lateral.get_style_context ().add_class ("lateral-panel");

            var credits_view = new CreditsView ();
            var filter_grid = new FilterOptionsView ();
            var dark_mode_view = new DarkModeOption ();
            var close_button = new Gtk.Button.with_label (S.CLOSE_SETTINGS);
            close_button.halign = Gtk.Align.END;
            close_button.margin_top = 8;
            close_button.margin_end = 8;
            close_button.valign = Gtk.Align.START;
            close_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);

            close_button.clicked.connect (() => {
                on_close_click ();
            });

            lateral.attach (close_button,   0, 0, 1, 1);
            lateral.attach (credits_view,   0, 0, 1, 1);
            lateral.attach (filter_grid,    0, 1, 1, 1);
            lateral.attach (dark_mode_view, 0, 2, 1, 1);

            var window_handler = new Hdy.WindowHandle ();
            window_handler.add (lateral);
            this.add (window_handler);
        }
    }
}