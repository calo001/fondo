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
using App.Configs;
using App.Utils;
using App.Models;
using App.Connection;

namespace App.Views {

    /**
     * The {@code MultipleWallpaperView} class to hold all logic about MultipleWallpapers
     *
     * @since 1.0.0
     */
    public class MultipleWallpaperView : Gtk.Grid {

        public signal void close_multiple_view ();
        public signal void multiple_selection (bool isMultiple);

        private unowned List<CardPhotoView?>        selected_photos;
        private bool                                is_multiple;
        private Gtk.Label                           label_info;
        private Gtk.Label                           generate_label;
        private Gtk.Button                          generate_btn;
        private Gtk.ProgressBar                     image_bar;   // Single image Generation bar
        private Gtk.ProgressBar                     global_bar;   // Global Generation bar

        /**
         * Constructs a new {@code MultipleWallpaperView} object.
         */
        public MultipleWallpaperView () {
            this.set_column_spacing (50);
            this.set_row_spacing (10);

            is_multiple = false;

            label_info = new Gtk.Label ("Wallpaper Slideshow");
            label_info.get_style_context ().add_class ("mw_head");

            var mode_switch = new Granite.ModeSwitch.from_icon_name ("video-display-symbolic", "view-grid-symbolic");
            mode_switch.primary_icon_tooltip_text = "Set single wallpaper";
            mode_switch.secondary_icon_tooltip_text = "Set wallpaper slideshow";
            mode_switch.valign = Gtk.Align.CENTER;
            mode_switch.halign = Gtk.Align.CENTER;
            mode_switch.button_release_event.connect( () => {
                is_multiple = !mode_switch.active;
                multiple_selection(is_multiple);
                update_visibility ();

                return true;
            });


            generate_btn = new Gtk.Button();
            generate_btn.get_style_context ().add_class ("generate_btn");
            generate_btn.set_label("Generate!");
            generate_btn.valign = Gtk.Align.CENTER;
            generate_btn.tooltip_text = "Generate";
            generate_btn.set_no_show_all(true);
            generate_btn.clicked.connect ( ()=> {
                print("Generate!!!!");
                generate_multiple_wallpaper();
            });

            generate_label = new Gtk.Label ("Select 1 or more wallpapers");
            generate_label.get_style_context ().add_class ("mw_info");
            generate_label.set_no_show_all(true);

            image_bar = new Gtk.ProgressBar ();
            image_bar.set_no_show_all(true);
            global_bar = new Gtk.ProgressBar ();
            global_bar.get_style_context ().add_class ("global_progress_bar");
            global_bar.set_no_show_all(true);

            attach (label_info,         0, 0, 3, 1);
            attach (mode_switch,        0, 1, 3, 1);
            attach (generate_label,     0, 2, 2, 1);
            attach (generate_btn,       2, 2, 1, 1);
            attach (image_bar,          0, 3, 3, 1);
            attach (global_bar,         0, 4, 3, 1);

        }

        public void update_photos(List<CardPhotoView?> photos) {
            selected_photos = photos;
            string selected_num = "%d selected".printf(get_num_selected());

            generate_label.set_text(selected_num);
            update_visibility ();
        }

        public void generate_multiple_wallpaper() {
            AppConnection connection = AppConnection.get_instance();
            List<Wallpaper> wallpaper_list = new List<Wallpaper>();

            global_bar.set_visible(true);
            image_bar.set_visible(true);
            double progress_step = 1.0 / get_num_selected();
            double global_progress = 0;

            selected_photos.foreach( ( photo_card ) => {
                Photo photo = photo_card.get_photo();

                string? url_photo = connection.get_url_photo(photo.links.download_location);
                Wallpaper wallpaper = new Wallpaper (url_photo, photo.id, photo.user.name, image_bar);
                if (wallpaper.download_picture()) {
                    print("Success!!: %s\n", wallpaper.full_picture_path);
                    wallpaper_list.append(wallpaper);
                    global_progress += progress_step;
                } else {
                    print("Error\n");
                }

                // Update global bar
                update_global_progress(global_progress);
            });

            MultiWallpaper multiple_wallpaper = new MultiWallpaper(wallpaper_list);
            multiple_wallpaper.set_wallpaper();

            // Hide progress
            end_global_progress();
        }

        /**
         * Updates visibility of elements depending on wether multiple
         * selection is active
         */
        private void update_visibility () {
            generate_label.set_visible(is_multiple);
            if (get_num_selected () > 0) {
                generate_btn.set_visible(is_multiple);
            }
        }

        private int get_num_selected () {
            if (selected_photos != null) {
                return (int) selected_photos.length();
            } else {
                return 0;
            }
        }

        private void end_global_progress () {
            global_bar.set_visible(false);
            image_bar.set_visible(false);
            Granite.Services.Application.set_progress_visible.begin (false, (obj, res) => {
                try {
                    Granite.Services.Application.set_progress_visible.end (res);
                } catch (GLib.Error e) {
                    critical (e.message);
                }
            });
            show_notify_success();
        }

        private void update_global_progress (double progress) {
            global_bar.set_fraction (progress);
            Granite.Services.Application.set_progress.begin (progress, (obj, res) => {
                try {
                    Granite.Services.Application.set_progress.end (res);
                } catch (GLib.Error e) {
                    critical (e.message);
                }
            });
        }

        private void show_notify_success () {
            var notification = new Notification ("Wallpaper slideshow ready!");
            notification.set_body ("Your new wallpaper slideshow is downloaded and set!");
            var icon = new ThemedIcon ("com.github.calo001.fondo.success");
            notification.set_icon (icon);
            GLib.Application.get_default ().send_notification ("notify.app", notification);
        }
    }
}
