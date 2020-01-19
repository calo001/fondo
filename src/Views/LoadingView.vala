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
     * The {@code LoadingView} class.
     *
     * @since 1.0.0
     */
    public class LoadingView : Gtk.Box {
        /**
         * Constructs a new {@code LoadingView} object.
         */
        public LoadingView () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER
            );
            
            var spinner = new Gtk.Spinner();
            spinner.active = true;
            spinner.get_style_context ().add_class ("card");
            spinner.get_style_context ().add_class ("card_spinner");
            add(spinner);
        }

    }
}