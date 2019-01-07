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

using App.Widgets;
using App.Connection;
using App.Structs;
using App.Configs;

namespace App.Views {

    /**
     * The {@code AppViewError} class.
     *
     * @since 1.0.0
     */
    public class AppViewError : Gtk.Box {
        public signal void close_window();
        public signal void retry();
        
        public AppViewError() {
            this.orientation = Gtk.Orientation.VERTICAL;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.CENTER;

            
            var image = new Gtk.Image.from_icon_name  ("network-error", Gtk.IconSize.DIALOG);
		    var label_title = new Gtk.Label ("Network Error");
		    var label_description = new Gtk.Label (S.CHECK_NETWORK_CONNECTION);
            var button_check_network = new Gtk.Button.with_label (S.RETRY);

		    label_title.get_style_context ().add_class ("h2");
		    label_description.get_style_context ().add_class ("h4");
            button_check_network.get_style_context ().add_class ("suggested-action");
            button_check_network.margin = 32;

            button_check_network.clicked.connect ( () => {
                retry();
            } );

            add(image);
            add(label_title);
            add(label_description);
            add(button_check_network);
        }
    }
}