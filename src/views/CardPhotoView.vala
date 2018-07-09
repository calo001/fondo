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

    public class CardPhotoView : Gtk.Grid {
        public CardPhotoView () {
            this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);

            var file = File.new_for_uri ("https://images.unsplash.com/photo-1502913625325-725506829ddc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjMwODIyfQ&s=9b9f1c49ad1e443388cc3daf691b976d");
            var image = new Granite.AsyncImage();
            image.set_from_file_async(file, 494, 282, true);

            this.add(image);
        }
    }

}
