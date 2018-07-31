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

        private Gtk.Button                  btn_load;
        private AppConnection               connection;
        /**
         * Constructs a new {@code AppView} object.
         */
        public AppView () {

            // Add orientation to Grid and margins
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin = 15;
            this.column_spacing = 20;
            this.row_spacing = 15;

            // Create photo list
            connection = new AppConnection();
            List<Photo?> photos = connection.get_thumbs ();

            // Create CustomCard (be ware with margins)
            var card_1 = new CardPhotoView (photos.nth_data(0));
            var card_2 = new CardPhotoView (photos.nth_data(1));
            var card_3 = new CardPhotoView (photos.nth_data(2));
            var card_4 = new CardPhotoView (photos.nth_data(3));
            var card_5 = new CardPhotoView (photos.nth_data(4));
            var card_6 = new CardPhotoView (photos.nth_data(5));

            //Create label unsplash
            var link_unsplash = new Gtk.LinkButton.with_label("https://unsplash.com/?utm_source=Foto&utm_medium=referral", "Photos from Unsplash");
            link_unsplash.get_style_context ().add_class ("link");
            link_unsplash.get_style_context ().remove_class ("button");
            link_unsplash.get_style_context ().remove_class ("flat");
            link_unsplash.get_style_context ().add_class ("h4");
            link_unsplash.has_tooltip = false;

            this.attach(card_1, 0, 0, 1, 1);
            this.attach(card_2, 1, 0, 1, 1);
            this.attach(card_3, 2, 0, 1, 1);
            this.attach(card_4, 0, 1, 1, 1);
            this.attach(card_5, 1, 1, 1, 1);
            this.attach(card_6, 2, 1, 1, 1);
            this.attach(link_unsplash, 1, 2, 1, 1);
        }
    }
}
