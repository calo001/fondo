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

using App.Connection;
using App.Configs;
using App.Utils;

namespace App.Utils {

    class DownloadImage {

        private string              id_photo;
        private string              url_endpoint;
        private string              picture_url;
        private string              picture_path;
        public  string              base_dir;
        private Gtk.ProgressBar     bar;
        private AppConnection       connection;

        public DownloadImage(string uri_endpoint, string id_photo, Gtk.ProgressBar bar) {
            this.url_endpoint = uri_endpoint;
            this.id_photo = id_photo;
            this.bar = bar;
        }

        // Build file picture
        public void build_file_jpeg () {
            //get_picture_URL();
            create_directory();
            white_picture();
        }

        // Get picture url
        public void get_picture_URL() {
            connection = new AppConnection();
            this.picture_url = connection.get_url_photo (this.url_endpoint);
        }

        // Create directory
        public void create_directory () {
            this.base_dir = Environment.get_home_dir () + "/.config/" + Constants.ID + "/backgrounds/";
		    var dir = File.new_for_path (this.base_dir);
		    if (!dir.query_exists ()) {
			    try{
			    	dir. make_directory_with_parents();
			    } catch (Error e){
				    print ("Error: %s\n", e.message);
			    }
            }
        }

        // Write the picture using url
        public void white_picture () {
            MainLoop loop = new MainLoop ();

            var launcher = Unity.LauncherEntry.get_for_desktop_id ("com.github.calo001.fondo.desktop");
            string file_image_name = id_photo + ".jpeg";
            this.picture_path = this.base_dir + file_image_name;
            this.bar.set_visible (true);

            var file_path = File.new_for_path (this.picture_path);
            var file_from_uri = File.new_for_uri (url_endpoint);

            try {
                if (!file_path.query_exists ()) {
                    file_from_uri.copy_async.begin (file_path,
                                                    FileCopyFlags.NONE,
                                                    GLib.Priority.DEFAULT,
                                                    null,
                                                    (current_num_bytes, total_num_bytes) => {
		                // Report copy-status:
		                print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);

			            var progress = (double) current_num_bytes / total_num_bytes;
			            this.bar.set_fraction (progress);
			            launcher.progress_visible = true;
                        launcher.progress = progress;
	                }, (obj, res) => {
		                try {
			                bool tmp = file_from_uri.copy_async.end (res);
			                print ("Result: %s\n", tmp.to_string ());
			                launcher.progress_visible = false;
                            set_wallpaper ();
                            show_notify ();
                            copy_to_greeter ();
		                } catch (Error e) {
			                print ("Error: %s\n", e.message);
		                }
		                loop.quit ();
	                });
			    } else {
					print ("Picture %s already exist\n", file_image_name);
					this.bar.set_fraction (1.0);
					set_wallpaper ();
                }
            } catch (Error e) {
               print ("Write picture: %s\n", e.message);
            }
            loop.run ();
        }

        public void set_wallpaper () {
            var wall_settings = new WallpaperSettings();
			wall_settings.picture_options = PictureMode.ZOOMED;
			wall_settings.picture_uri = this.picture_path;
        }

        public void show_notify () {
            var notification = new Notification (_("Wallpaper ready!"));
            notification.set_body (_("Your wallapaer is ready!"));
            notification.add_button ("click", "action");
            GLib.Application.get_default ().send_notification ("notify.app", notification);

        }

        public void copy_to_greeter () {
            MainLoop loop = new MainLoop ();
            var file_path = File.new_for_path (this.picture_path);
            var local_share_back = File.new_for_path (Environment.get_home_dir () + "/.local/share/backgrounds/" + id_photo + ".jpeg");

            file_path.copy_async.begin(local_share_back, FileCopyFlags.NONE, GLib.Priority.DEFAULT, null,
            (current_num_bytes, total_num_bytes) => {
		        // Report copy-status:
		        print ("USR %" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);
	        }, (obj, res) => {
		    try {
			    bool tmp = file_path.copy_async.end (res);
			    print ("USR Result: %s\n", tmp.to_string ());
		    } catch (Error e) {
			    print ("USR Error: %s\n", e.message);
		    }
		        loop.quit ();
	        });
        }
    }
}
