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

namespace App.Widgets {

    /**
     * The {@code ButtonTab} class is responsible for displaying a Button on ButtonNavbar.
     *
     */
    public class ButtonTab : Gtk.Button {
        public ButtonTab (string icon_name, string name) {
            Object (    
                label: name,
                always_show_image: true,
                expand: true,
                image: new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.LARGE_TOOLBAR)
            );

            get_style_context ().add_class ("flat");
            get_style_context ().add_class ("btn_round");
        }

        public void on_active () {
            get_style_context ().add_class ("active");
        }

        public void on_inactive () {
            get_style_context ().remove_class ("active");
        }
    }
}