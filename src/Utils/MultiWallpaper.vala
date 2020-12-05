/*
* Copyright (C) 2020 - Fondo
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

using Gtk;
using App.Configs;
namespace App.Utils {

    /**
     * The {@code MultiWallpaper} class. Generates and sets a list of wallpapers
     * as a slideshow background
     */
    public class MultiWallpaper {

        public  string                  full_collection_path; // file path of collection XML file
        private string                  collection_name;
        private unowned List<Wallpaper> wallpapers;


        // Base path for wallpaper picture
        private string BASE_DIR = Path.build_filename (Environment.get_user_data_dir (), "backgrounds") + "/";


        public MultiWallpaper (List<Wallpaper> wallpapers_list) {
            this.wallpapers = wallpapers_list;
            this.collection_name = generate_multiname() + ".xml";
            this.full_collection_path = BASE_DIR + collection_name;
        }

        /**
         * Generates an XML file calling to XMLBackground
         *
         * static_time: number of seconds a background is shown
         * transition_time: number of seconds of animation to change between two backgrounds
         */
        public File generate_xml (int static_time, int transition_time = 2) {
            List<string> wallpapers_path = new List<string> ();

            foreach (Wallpaper wallpaper in this.wallpapers) {
                wallpapers_path.append(wallpaper.full_picture_path);
            }

            DateTime start = new DateTime.now_local ();
            static_time -= transition_time;

            XMLBackground xml_background = new XMLBackground(full_collection_path, wallpapers_path, static_time, transition_time, start);

            return xml_background.write_background ();
        }


        /**
         * Generates a background xml file with multiple wallpapers and sets it
         * as background.
         */
        public void set_wallpaper (int static_time = 1800, string picture_options = "zoom") {
            File background_file = generate_xml (static_time);
            if (!background_file.query_exists ()) {
                Wallpaper.show_message ("Error", "XML Background error on generation", "dialog-error");
            } else {
                var schemaManager = new SchemaManager();
                string background_path = background_file.get_path();
                schemaManager.set_wallpaper (background_path, picture_options);
                GLib.message ("Seteado!");
            }
        }

        private static string generate_multiname () {
            return new DateTime.now_local ().to_string();
        }

    }
}
