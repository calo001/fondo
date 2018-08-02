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

namespace App.Views {

    /**
     * The {@code AppView} class.
     *
     * @since 1.0.0
     */
    public class AppView : Gtk.Grid {

        public CardPhotoView    card_1 {get; set;}
        public CardPhotoView    card_2 {get; set;}
        public CardPhotoView    card_3 {get; set;}
        public CardPhotoView    card_4 {get; set;}
        public CardPhotoView    card_5 {get; set;}
        public CardPhotoView    card_6 {get; set;}
        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView (List<Photo?> photos) {

            // Add orientation to Grid and margins
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin_top = 10;
            this.margin_left = 15;
            this.margin_right = 15;
            this.column_spacing = 20;
            this.row_spacing = 15;

            // Create CustomCard (be ware with margins)
            var card_1 = new CardPhotoView (photos.nth_data(0));
            var card_2 = new CardPhotoView (photos.nth_data(1));
            var card_3 = new CardPhotoView (photos.nth_data(2));
            var card_4 = new CardPhotoView (photos.nth_data(3));
            var card_5 = new CardPhotoView (photos.nth_data(4));
            var card_6 = new CardPhotoView (photos.nth_data(5));

            this.attach(card_1, 0, 0, 1, 1);
            this.attach(card_2, 1, 0, 1, 1);
            this.attach(card_3, 2, 0, 1, 1);
            this.attach(card_4, 0, 1, 1, 1);
            this.attach(card_5, 1, 1, 1, 1);
            this.attach(card_6, 2, 1, 1, 1);
        }

        public void use_card_for_wallpaper (int num) {
            switch (num) {
                case 1: this.card_1.set_as_wallpaper (); break;
                case 2: this.card_2.set_as_wallpaper (); break;
                case 3: this.card_3.set_as_wallpaper (); break;
                case 4: this.card_4.set_as_wallpaper (); break;
                case 5: this.card_5.set_as_wallpaper (); break;
            }
        }
    }
}
