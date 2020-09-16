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
     * The {@code FileManager} class.
     *
     * @since 1.0.0
     */

    public class FileManager {
        private string BASE_DIR = Path.build_filename (Environment.get_user_data_dir (), "backgrounds") + "/";

        public bool delete_photo (Photo photo) {
            var img_file_name = photo.user.name + "_" + photo.id + ".jpeg";
            var full_picture_path = BASE_DIR + img_file_name;
            var file_photo = File.new_for_path (full_picture_path);

            if (file_photo.query_exists ()) {
                try {
                    file_photo.delete ();
                } catch (Error e) {
                    return false;
                }
                return true;
            }

            return false;
        }
    }

}
