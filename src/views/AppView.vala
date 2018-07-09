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

namespace App.Views {

    /**
     * The {@code AppView} class.
     *
     * @since 1.0.0
     */
    public class AppView : Gtk.Grid {

        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView () {

            // Add orientation to Grid and margins
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin_start = 20;
            this.margin_end = 20;

            // Create CustomCard (be ware with margins)
            var image = new CardPhotoView();
            
            // Create test butto
            var button_hello = new Gtk.Button.with_label ("Click me!");
            button_hello.height_request = 50;
            button_hello.width_request = 100;

            button_hello.clicked.connect (() => {
                button_hello.label = "Hello World!";
            });

            button_hello.get_style_context ().add_class ("button-test");

            this.add (button_hello);
            this.add(image);
        }
    }
}
