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

namespace App.Models {
    /**
     * The {@code Photo} class model.
     *
     * @since 1.0.0
     */

    public class Photo {
        public string   id { get; set; }
        public int64    width { get; set; }
        public int64    height { get; set; }
        public string   urls_thumb { get; set; }
        public string   links_download_location { get; set; }
        public string   username { get; set; }
        public string   name { get; set; }
        public string?  location { get; set;}

        public Photo(PhotoBuilder builder) {
            id = builder.id;
            width = builder.width;
            height = builder.height;
            urls_thumb = builder.thumb;
            links_download_location = builder.download_location;
            username = builder.username;
            name = builder.name;
            location = builder.location;
        }
    }
}
