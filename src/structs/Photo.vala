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

namespace App.Structs {
    /**
     * The {@code Photo} struct.
     *
     * @since 1.0.0
     */

    public struct Photo {
        public string   id;                         // Id from unplash photo
        public int64    width;                      // Width of photo for download
        public int64    height;                     // Height of photo for download
        public string   urls_thumb;                 // URL to get thumb
        public string   links_download_location;    // URL to get the download uri
        public string   username;                   // Photo's user name
        public string   name;                       // Autor name
        public string   location;                   // Photo location
    }
}
