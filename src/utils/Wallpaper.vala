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

using Gtk;
using App.Configs;
using Unity;

namespace App.Utils {

    /**
     * The {@code Wallpaper} class.
     *
     * @since 1.0.0
     */

    class Wallpaper {

        private string              uri_endpoint;                   // URI http of picture in unsplash
        public  string              full_picture_path {get; set;}   // Path for wallpaper picture
        private ProgressBar         bar;                            // Downloading Progress
        private string              img_file_name;                  // Based on id_photo & username

        // Base path for wallpaper picture
        private string BASE_DIR = Path.build_filename (Environment.get_user_data_dir (), "backgrounds") + "/";

        // Progress bar in plank
        private LauncherEntry launcher;

        public Wallpaper (string uri_endpoint, string id_photo, string username, ProgressBar bar) {
            this.uri_endpoint = uri_endpoint;
            this.bar = bar;
            this.img_file_name = username + "_" + id_photo + ".jpeg";
            this.full_picture_path = BASE_DIR + img_file_name;
            this.launcher = LauncherEntry.get_for_desktop_id (Constants.ID + ".desktop");
        }

        // Update picture
        public void update_wallpaper () {
            if (check_directory ()) {
                if (download_picture ()) {
                    set_wallpaper ();
                    show_notify ();
                    set_to_greeter ();
                }
            }
        }

        // Create directory
        private bool check_directory () {
		    var dir = File.new_for_path (BASE_DIR);
		    if (!dir.query_exists ()) {
			    try{
			    	dir. make_directory_with_parents();
			    } catch (Error e){
				    show_message ("Error", e.message, "dialog-error");
				    return false;
			    }
            }
            return true;
        }

        // Write the picture using url in '/home/user/.local/share/backgrounds/'
        public bool download_picture () {
            MainLoop loop = new MainLoop ();

            var file_path = File.new_for_path (full_picture_path);
            var file_from_uri = File.new_for_uri (uri_endpoint);
            var progress = 0.0;

            if (!file_path.query_exists ()) {
                launcher.progress_visible = true;
                file_from_uri.copy_async.begin (file_path, FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA, GLib.Priority.DEFAULT, null, (current_num_bytes, total_num_bytes) => {
		        // Report copy-status:
                    progress = (double) current_num_bytes / total_num_bytes;
		            total_num_bytes = total_num_bytes == 0 ? Constants.SIZE_IMAGE_AVERAGE : total_num_bytes;
		            print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);
			        show_progress (progress);
	            }, (obj, res) => {
		            try {
			            bool tmp = file_from_uri.copy_async.end (res);
			            print ("Result: %s\n", tmp.to_string ());
			            launcher.progress_visible = false;
		            } catch (Error e) {
			            show_message ("Error", e.message, "dialog-error");
		            }
		                loop.quit ();
	                });
			} else {
				print ("Picture %s already exist\n", img_file_name);
				bar.set_fraction (1.0);
				return true;
            }

            loop.run ();
            return true;
        }

        // Change the picture-uri property in GSettings
        public void set_wallpaper () {
			GLib.Settings settings = new GLib.Settings ("org.gnome.desktop.background");
            settings.set_string ("picture-uri", "file://" + this.full_picture_path);
            settings.reset ("color-shading-type");
            if (settings.get_string ("picture-options") == "none") {
                settings.reset ("picture-options");
            }
            settings.apply ();
            GLib.Settings.sync ();
        }

        // Show progress in download
        private void show_progress (double progress) {
            bar.set_fraction (progress);
            launcher.progress = progress;
        }

        // Show desktop notification
        public void show_notify () {
            var notification = new Notification (_("Wallpaper ready!"));
            notification.set_body (_("Your wallpaper is ready!"));
            notification.add_button ("click", "action");
            GLib.Application.get_default ().send_notification ("notify.app", notification);
        }

        // Copy the downloaded background to '/var/lib/lightdm-data/user/wallpaper/'
         public void set_to_greeter () {
            MainLoop loop = new MainLoop ();
            File? dest = null;
            var file_path = File.new_for_path (full_picture_path);
            var greeter_data_dir = Path.build_filename (Environment.get_variable ("XDG_GREETER_DATA_DIR"), "wallpaper");

            var folder = File.new_for_path (greeter_data_dir);
            if (folder.query_exists ()) {
                try {
                    var enumerator = folder.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
                    FileInfo? info = null;
                    while ((info = enumerator.next_file ()) != null) {
                        enumerator.get_child (info).@delete ();
                    }
                } catch (Error e) {
                    show_message ("Error", e.message, "dialog-error");
                }
            } else {
                try{
			    	folder.make_directory_with_parents();
			    } catch (Error e){
				    show_message ("Error", e.message, "dialog-error");
			    }
            }

            dest = File.new_for_path (Path.build_filename (greeter_data_dir, img_file_name));

            file_path.copy_async.begin(dest, FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA, GLib.Priority.DEFAULT, null,
            (current_num_bytes, total_num_bytes) => {
		        // Report copy-status:
		        print ("USR %" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);
	        }, (obj, res) => {
		        try {
			        bool tmp = file_path.copy_async.end (res);
			        print ("USR Result: %s\n", tmp.to_string ());
		        } catch (Error e) {
			        show_message ("Error", e.message, "dialog-error");
		        }
		            loop.quit ();
	        });
        }

        // Dialog that show error messages
        private void show_message (string txt_primary, string txt_secondary, string icon) {
            var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                txt_primary,
                txt_secondary,
                icon,
                Gtk.ButtonsType.CLOSE
            );

            message_dialog.run ();
            message_dialog.destroy ();
        }
    }
}
