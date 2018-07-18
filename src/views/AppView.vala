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

        private Gtk.Button                  btn_load;
        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView () {

            // Add orientation to Grid and margins
            this.orientation = Gtk.Orientation.VERTICAL;
            this.row_spacing = 30;
            this.column_spacing = 30;
            this.margin_start = 30;
            this.margin_end = 30;

            // Create CustomCard (be ware with margins)
            var card_1 = new CardPhotoView();
            var card_2 = new CardPhotoView();
            var card_3 = new CardPhotoView();
            var card_4 = new CardPhotoView();
            var card_5 = new CardPhotoView();
            var card_6 = new CardPhotoView();

            //Create Button Load
            btn_load = new Gtk.Button.with_label (_("See more"));
            btn_load.get_style_context ().add_class ("button-blue");

            this.attach(card_1, 0, 0, 1, 1);
            this.attach(card_2, 1, 0, 1, 1);
            this.attach(card_3, 2, 0, 1, 1);
            this.attach(card_4, 0, 1, 1, 1);
            this.attach(card_5, 1, 1, 1, 1);
            this.attach(card_6, 2, 1, 1, 1);
            this.attach(btn_load, 1, 2, 1, 2);
        }
    }
}
