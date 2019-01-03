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
#if WITH_UNITY
using Unity;
#endif
namespace App.Utils {

    /**
     * The {@code Wallpaper} class.
     *
     * @since 1.0.0
     */

    public class Wallpaper {

        // Signal to inform that download is finished
        public signal void finish_download ();

        private string              uri_endpoint;                   // URI http of picture in unsplash
        public  string              full_picture_path {get; set;}   // Path for wallpaper picture
        private ProgressBar         bar;                            // Downloading Progress
        private string              img_file_name;                  // Based on id_photo & username

        // Base path for wallpaper picture
        private string BASE_DIR = Path.build_filename (Environment.get_user_data_dir (), "backgrounds") + "/";

        // Progress bar in plank
        #if WITH_UNITY
        private LauncherEntry launcher;
        #endif
        /*********************************** 
            Constructor
            * uri_endpoint is the direct url image
            * id_photo is used for naming the file
            * username is used for naming the file
            * bar to update progress
        ************************************/
        public Wallpaper (string uri_endpoint, string id_photo, string username, ProgressBar bar) {
            this.uri_endpoint = uri_endpoint;
            this.bar = bar;
            this.img_file_name = username + "_" + id_photo + ".jpeg";
            this.full_picture_path = BASE_DIR + img_file_name;
            #if WITH_UNITY
                this.launcher = LauncherEntry.get_for_desktop_id (Constants.ID + ".desktop");
            #endif    
        }

        /*********************************************************************** 
            Method to manage all process to download and put a new Wallpaper
            * opt is used to put in GSetting the wallpaper size
            * Show notification
            * Finally set the configuration to change the wallpaper greeter
        ***********************************************************************/
        public void update_wallpaper (string opt = "zoom") {
            if (check_directory ()) {
                if (download_picture ()) {
                    set_wallpaper (opt);
                    show_notify ();
                    set_to_greeter ();
                } else {
                    show_message ("Error", "Download issue", "dialog-warning");    
                }
            } else {
                show_message ("Error", "Directory issue", "dialog-warning");
            }
        }

        /*********************************************************************** 
            Method to create if is necessary the directory 
            in /home/user/.local/share/backgrounds/
        ***********************************************************************/
        private bool check_directory () {
            var dir = File.new_for_path (BASE_DIR);
            print ("make directory with parents");
		    if (!dir.query_exists ()) {
                try{
                    print ("make directory with parents");
			    	dir. make_directory_with_parents();
			    } catch (Error e){
				    show_message ("Error check Directory", e.message, "dialog-error");
				    return false;
			    }
            }
            return true;
        }

        /*********************************************************************** 
            Method to download a photo from API unsplash
            * Using the copy_async method to white the file
            * Update progress via show_progress method
            * Emit finish_download signal
        ***********************************************************************/
        public bool download_picture () {
            MainLoop loop = new MainLoop ();

            var file_path = File.new_for_path (full_picture_path);
            var file_from_uri = File.new_for_uri (uri_endpoint);
            var progress = 0.0;

            if (!file_path.query_exists ()) {
                #if WITH_UNITY
                launcher.progress_visible = true;
                #endif
                
                file_from_uri.copy_async.begin (file_path, 
                FileCopyFlags.OVERWRITE | FileCopyFlags.ALL_METADATA, 
                GLib.Priority.DEFAULT, null, (current_num_bytes, total_num_bytes) => {
		        // Report copy-status:
                    progress = (double) current_num_bytes / total_num_bytes;
		            total_num_bytes = total_num_bytes == 0 ? Constants.SIZE_IMAGE_AVERAGE : total_num_bytes;
		            //print ("%" + int64.FORMAT + " bytes of %" + int64.FORMAT + " bytes copied.\n", current_num_bytes, total_num_bytes);
			        show_progress (progress);
	            }, (obj, res) => {
		            try {
			            bool tmp = file_from_uri.copy_async.end (res);
                        print ("Result: %s\n", tmp.to_string ());
                        #if WITH_UNITY
                        launcher.progress_visible = false;
                        #endif
                        finish_download ();
		            } catch (Error e) {
			            //show_message ("Error", e.message, "dialog-error");
		            }
		                loop.quit ();
	                });
			} else {
                //print ("Picture %s already exist\n", img_file_name);
                finish_download ();
				bar.set_fraction (1);
				return true;
            }
            loop.run ();
            return true;
        }

        /*********************************************************************** 
            Method to update GSetting properties
        ***********************************************************************/
        public void set_wallpaper (string picture_options = "zoom") {
			GLib.Settings settings = new GLib.Settings ("org.gnome.desktop.background");
            settings.set_string ("picture-uri", "file://" + this.full_picture_path);
            settings.set_string ("picture-options", picture_options);
            settings.reset ("color-shading-type");
            if (settings.get_string ("picture-options") == "none") {
                settings.reset ("picture-options");
            }
            settings.apply ();
            GLib.Settings.sync ();
        }

        /*********************************************************************** 
            Method to show progress in download
        ***********************************************************************/
        private void show_progress (double progress) {
            bar.set_fraction (progress);
            #if WITH_UNITY
            launcher.progress = progress;
            #endif
        }

        /*********************************************************************** 
            Method to show desktop notification
        ***********************************************************************/
        public void show_notify () {
            var notification = new Notification (_("Wallpaper ready!"));
            notification.set_body (_("Your new wallpaper is ready!"));
            GLib.Application.get_default ().send_notification ("notify.app", notification);
        }

        /*********************************************************************** 
            Method to copy the downloaded background to 
            '/var/lib/lightdm-data/user/wallpaper/'
            * Check if directory exist
            * Copy image process
            * Base from:
            * https://github.com/elementary/switchboard-plug-pantheon-shell/blob/master/set-wallpaper-contract/set-wallpaper.vala
        ***********************************************************************/
        public void set_to_greeter () {
            var variable = Environment.get_variable ("XDG_GREETER_DATA_DIR");
            if (variable != null) {
                MainLoop loop = new MainLoop ();
                File? dest = null;
                var file_path = File.new_for_path (full_picture_path);
                var greeter_data_dir = Path.build_filename (variable, "wallpaper");
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
            } else {
                show_message ("Error", _("Greeter not found"), "dialog-error");
            }
        }

        /************************************
           Dialog that show error messages
        ************************************/
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
