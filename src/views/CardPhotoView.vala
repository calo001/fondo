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
using App.Configs;

namespace App.Views {

    public class CardPhotoView : Gtk.Grid {

        // Construct
        public CardPhotoView () {
            
            // Setup styles
            this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);

            // Create File Object
            var file = File.new_for_uri (Constants.ACCESS_KEY_UNSPLASH);
            
            // Create AsyncImage object
            var image = new Granite.AsyncImage(true, true);
            image.set_from_file_async(file, 200, 100, false); // Width, Heigth

            // Add view to custom Grid            
            this.add(image);
        }
    }

}
