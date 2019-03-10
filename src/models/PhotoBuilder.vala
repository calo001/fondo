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
     * The {@code PhotoBuilder} class builder.
     *
     * @since 1.0.0
     */

    public class PhotoBuilder {
        public string   id;
        public int64    width;
        public int64    height;
        public string   thumb;
        public string   download_location;
        public string   username;
        public string   name;
        public string?  location;

        public PhotoBuilder (string id) {
            this.id = id;
        }

        public PhotoBuilder add_width (int64 width) {
            this.width = width;
            return this;
        }

        public PhotoBuilder add_height (int64 height) {
            this.height = height;
            return this;
        }

        public PhotoBuilder add_thumb (string thumb) {
            this.thumb = thumb;
            return this;
        }

        public PhotoBuilder add_download_location (string download_location) {
            this.download_location = download_location;
            return this;
        }

        public PhotoBuilder add_username (string username) {
            this.username = username;
            return this;
        }

        public PhotoBuilder add_name (string name) {
            this.name = name;
            return this;
        }

        public PhotoBuilder add_location (string? location) {
            this.location = (location != null) ? @"🌎  $location" : S.AN_AMAZING_PLACE;
            return this;
        }

        public Photo build () {
            return new Photo (this);
        }
    }
}
