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

    async void show_file_in_filemanager(string file_uri) throws Error {
        try {
            org.freedesktop.FileManager1? manager = yield Bus.get_proxy (BusType.SESSION,
                                                                        org.freedesktop.FileManager1.NAME,
                                                                        org.freedesktop.FileManager1.PATH,
                                                                        DBusProxyFlags.DO_NOT_LOAD_PROPERTIES |
                                                                        DBusProxyFlags.DO_NOT_CONNECT_SIGNALS);
            var id = "%s_%s_%d_%s".printf(Environment.get_prgname(), Environment.get_host_name(),
                                        Posix.getpid(),
                                        GLib.get_monotonic_time().to_string());
            yield manager.show_items ({file_uri}, id);
        } catch (Error e) {
            warning("Failed to launch file manager using DBus, using fall-back: %s", e.message);
            Gtk.show_uri_on_window(null, file_uri, Gdk.CURRENT_TIME);
        }
    }

    [DBus (name = "org.freedesktop.FileManager1") ]
    public interface org.freedesktop.FileManager1 : Object {
        public const string NAME = "org.freedesktop.FileManager1";
        public const string PATH = "/org/freedesktop/FileManager1";

        public abstract async void show_folders(string[] uris, string startup_id) throws IOError, DBusError;
        public abstract async void show_items(string[] uris, string startup_id) throws IOError, DBusError;
        public abstract async void show_item_properties(string[] uris, string startup_id) throws IOError, DBusError;
    }
}
