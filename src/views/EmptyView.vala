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

namespace App.Views {

    /**
     * The {@code EmptyView} class.
     *
     * @since 1.0.0
     */
    public class EmptyView : Gtk.Box {
        /**
         * Constructs a new {@code EmptyView} object.
         */
        public EmptyView () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0,
                valign: Gtk.Align.CENTER
            );

            var empty_label = new Gtk.Label ("Photos not found");
            empty_label.get_style_context ().add_class ("h2");
            empty_label.margin = 8;
            var icon_empty = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/empty.svg");

            add (icon_empty);
            add (empty_label);
        }

    }
}