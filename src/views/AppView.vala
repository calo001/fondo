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
using App.Connection;

namespace App.Views {

    /**
     * The {@code AppView} class.
     *
     * @since 1.0.0
     */
    public class AppView : Gtk.FlowBox {
        public signal void load_more();
        private int                        num_card;
        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView () {
            //this.connection = AppConnection.get_instance();
            // Config FlowBox
            //this.column_spacing = 5;
            //this.row_spacing = 5;
            this.margin_right = 10;
            this.margin_left = 10;
            this.max_children_per_line = 3;
            this.min_children_per_line = 1;
            this.set_selection_mode(Gtk.SelectionMode.SINGLE);
            this.num_card = 0;
        }

        public void insert_cards (List<Photo?> photos) {
            foreach (var photo in photos) {
                var card = new CardPhotoView (photo);    
                print(num_card.to_string());
                this.insert(card, num_card);
                num_card++;
                card.show();
            }           
        }
    }
}
