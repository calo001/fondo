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
        public string?  location { get; set; }
        public string   created_at { get; set; }
        public string?  description { get; set; }
        public string   color { get; set; }
        public string   profile_image { get; set; }
        public string?  bio { get; set; }
        public string   autor_link { get; set; }

        public Photo(PhotoBuilder builder) {
            id = builder.id;
            width = builder.width;
            height = builder.height;
            urls_thumb = builder.thumb;
            links_download_location = builder.download_location;
            username = builder.username;
            name = builder.name;
            location = builder.location;
            created_at = builder.created_at;
            description = builder.description;
            color = builder.color;
            profile_image = builder.profile_image;
            bio = builder.bio;
            autor_link = @"https://unsplash.com/@$(username)?utm_source=$(Constants.PROGRAME_NAME)&utm_medium=referral";
        }
    }
}
