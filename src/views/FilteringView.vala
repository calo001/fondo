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
     * The {@code FilteringView} class.
     *
     * @since 1.0.0
     */
    public class FilteringView : Gtk.Box {
        /**
         * Constructs a new {@code FilteringView} object.
         */
        public FilteringView () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER
            );
            
            var lbl_filtering = new Gtk.Label(S.FILTERING);
            lbl_filtering.get_style_context ().add_class ("h1");
            add(lbl_filtering);
        }

    }
}