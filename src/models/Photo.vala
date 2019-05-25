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

namespace App.Models

{
    public class Photo : Object {
        public string id { get; set; }
        public string created_at { get; set; }
        public string updated_at { get; set; }
        public int64 width { get; set; }
        public int64 height { get; set; }
        public string color { get; set; }
        public string description { get; set; }
        public string alt_description { get; set; }
        public Urls urls { get; set; }
        public PhotoLinks links { get; set; }
        public unowned List<Object?> categories { get; set; }
        public bool sponsored { get; set; }
        public User sponsored_by { get; set; }
        public int64? sponsored_impressions_id { get; set; }
        public int64 likes { get; set; }
        public bool liked_by_user { get; set; }
        public unowned List<Object?> current_user_collections { get; set; }
        public User user { get; set; }
        public Sponsorship sponsorship { get; set; }
        public unowned List<Tag> tags { get; set; }

        public string autor_link () {
            return @"https://unsplash.com/@$(this.user.username)?utm_source=$(Constants.PROGRAME_NAME)&utm_medium=referral";
        }
    }

    public class PhotoLinks : Object {
        public string self { get; set; }
        public string html { get; set; }
        public string download { get; set; }
        public string download_location { get; set; }
    }

    public class Tag : Object
    {
        public string title { get; set; }
    }

    public class User : Object {
        public string id { get; set; }
        public string updated_at { get; set; }
        public string username { get; set; }
        public string name { get; set; }
        public string first_name { get; set; }
        public string last_name { get; set; }
        public string twitter_username { get; set; }
        public string portfolio_url { get; set; }
        public string bio { get; set; }
        public string location { get; set; }
        public UserLinks links { get; set; }
        public ProfileImage profile_image { get; set; }
        public string instagram_username { get; set; }
        public int64 total_collections { get; set; }
        public int64 total_likes { get; set; }
        public int64 total_photos { get; set; }
        public bool accepted_tos { get; set; }
    }

    public class UserLinks : Object {
        public string self { get; set; }
        public string html { get; set; }
        public string photos { get; set; }
        public string likes { get; set; }
        public string portfolio { get; set; }
        public string following { get; set; }
        public string followers { get; set; }
    }

    public class ProfileImage : Object {
        public string small { get; set; }
        public string medium { get; set; }
        public string large { get; set; }
    }

    public class Sponsorship : Object {
        public int64 impressions_id { get; set; }
        public string tagline { get; set; }
        public User sponsor { get; set; }
    }

    public class Urls : Object {
        public string raw { get; set; }
        public string full { get; set; }
        public string regular { get; set; }
        public string small { get; set; }
        public string thumb { get; set; }
    }

    public class PhotoUtil {
        public static List<Photo?> from_json(Json.Node root) {
            List<Photo?> list = new List<Photo?> ();
            unowned Json.Array array = root.get_array ();

            foreach (unowned Json.Node item in array.get_elements ()) {
                Photo photo = photo_to_json (item);
                if (photo != null) {
                    list.append (photo);
                }
            }
            return list;
        }
        
        public static Photo photo_to_json(Json.Node root) {
            var photo = Json.gobject_deserialize (typeof (Photo) , root) as Photo;
            
            var tags = root.get_object ().get_array_member ("tags");
            foreach (unowned Json.Node item in tags.get_elements ()) {
                Tag tag = Json.gobject_deserialize (typeof (Tag) , item) as Tag;
                if (tag != null) photo.tags.append (tag);
            }
            return photo;
        }

        public static Json.Node from_object(Photo photo)
        {
            return Json.gobject_serialize (photo);
        }

        
    }
}

