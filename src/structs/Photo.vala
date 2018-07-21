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
    public struct Photo {
        public int      width {get; set;}
        public int      height {get; set;}
        public string   color {get; set;}
        public string   urls_thumb {get; set;}
        public string   links_download_location {get; set;}
        public string   username {get; set;}
        public string   name {get; set;}
        public string   profile_image_small {get; set;}
    }
}
