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
using App.Models;

namespace App.Utils {
    /**
     * The {@code JsonManager} class.
     *
     * @since 1.0.0
     */

    public class JsonManager {
        private string app_dir = Environment.get_user_data_dir () + Constants.APP_DATA;
        private string file_name;

        public JsonManager () {
            file_name = this.app_dir + "/fondo_history.json";
            debug ("%s".printf(file_name));
        }

        public void save_history (List<Photo> photos) {
            string json_string = prepare_json_from_photos (photos);
            var dir = File.new_for_path (app_dir);
            var file = File.new_for_path (file_name);

            try {
                if (!dir.query_exists ()) {
                    dir.make_directory ();
                } 

                if (file.query_exists ()) {
                    file.delete ();
                }

                var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION);
                var data_stream = new DataOutputStream (file_stream);
                data_stream.put_string(json_string);
            } catch (Error e) {
                warning ("Failet to save notes: " + e.message);
            }
        }

        public string prepare_json_from_photos (List<Photo> photos) {
            Json.Builder builder = new Json.Builder ();

            builder.begin_array ();
            foreach (var photo in photos) {
                var node = PhotoUtil.from_object (photo);
                builder.add_value (node);
            }
            builder.end_array ();

            Json.Generator generator = new Json.Generator ();
            Json.Node root = builder.get_root ();
            generator.set_root (root);

            string str = generator.to_data (null);
            return str;
        }

        public List<Photo> load_from_file () {
            List<Photo> stored_photos = new List<Photo>();

            try {
                var file = File.new_for_path(file_name);
                var json_string = "";
                if (file.query_exists()) {
                    string line;
                    var dis = new DataInputStream (file.read ());

                    while ((line = dis.read_line (null)) != null) {
                        json_string += line;
                    }

                    var parser = new Json.Parser();
                    parser.load_from_data(json_string);

                    var root = parser.get_root();
                    stored_photos.concat(PhotoUtil.from_json (root));
                }

            } catch (Error e) {
                warning ("Failed to load file: %s\n", e.message);
            }

            return stored_photos;
        }

        public List<Photo> add_photo (Photo photo) {
            List<Photo> stored_photos = load_from_file ();
            
            foreach (var item in stored_photos) {
                if (photo.id == item.id) {
                    stored_photos.remove (item);
                    stored_photos.append (photo);
                    return stored_photos;
                }
            }
            stored_photos.append (photo);
            return stored_photos;
        }
    }

}
