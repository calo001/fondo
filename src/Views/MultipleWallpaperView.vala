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
using App.Widgets;

namespace App.Views {

    /**
     * The {@code MultipleWallpaperView} class to hold all logic about MultipleWallpapers
     *
     * @since 1.0.0
     */
    public class MultipleWallpaperView : Gtk.Grid {

        public signal void close_multiple_view ();

        private List<CardPhotoView?>                selected_photos;
        private bool                                is_multiple;
        private Gtk.Label                           label_info;
        private Gtk.Label                           generate_label;
        private Gtk.Button                          generate_btn;
        private Gtk.Image                           image_header;
        private Gtk.Image                           image_info;
        private Gtk.Grid                            download_container;
        private Gtk.ProgressBar                     global_bar;  // Global Generation bar
        private Gtk.Stack                           stack;
        private MultiplePreviewWidget               images_preview;
        private const string STACK_BUTTON =                 "register_button";
        private const string STACK_SLIDESHOW_DOWNLADING =   "slideshow_downloading";

        /**
         * Constructs a new {@code MultipleWallpaperView} object.
         */
        public MultipleWallpaperView () {
            this.set_column_spacing (20);
            this.set_row_spacing (10);
            selected_photos = new List<CardPhotoView>();

            is_multiple = true;

            label_info = new Gtk.Label (S.WALLPAPER_SLIDESHOW);
            label_info.get_style_context ().add_class ("mw_head");

            image_header = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/fondo-slideshow.svg");

            generate_btn = new Gtk.Button();
            generate_btn.get_style_context ().add_class ("action_suggest_btn");
            generate_btn.set_label("Generate!");
            generate_btn.valign = Gtk.Align.CENTER;
            generate_btn.tooltip_text = "Generate";
            generate_btn.set_no_show_all(true);
            generate_btn.clicked.connect ( ()=> {
                show_preparing_progress (STACK_SLIDESHOW_DOWNLADING);
                generate_multiple_wallpaper ();
            });

            image_info = new Gtk.Image ();
            image_info.gicon = new ThemedIcon ("view-paged-symbolic");
            image_info.xalign = 1;
            image_info.expand = true;

            generate_label = new Gtk.Label ("Select 1 or more photos by clicking on ");
            generate_label.get_style_context ().add_class ("mw_info");
            generate_label.set_no_show_all(true);
            generate_label.xalign = 0;

            var loading_spinner = new LoadingView ();

            download_container = new Gtk.Grid ();
            download_container.get_style_context ().add_class ("multiple_wallpaper_popup");

            var download_lbl = new Gtk.Label ("Preparing slideshow ...");
            download_lbl.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
            download_lbl.margin_start = 8;

            global_bar = new Gtk.ProgressBar ();
            global_bar.get_style_context ().add_class ("global_progress_bar");
            global_bar.margin_start = 8;

            download_container.attach (loading_spinner,    0, 1, 1, 2);
            download_container.attach (download_lbl,       1, 1, 1, 1);
            download_container.attach (global_bar,         1, 2, 2, 1);

            images_preview = new MultiplePreviewWidget();
            images_preview.delete_preview_image.connect ((photo_card) => {
                photo_card.set_select (false);
                remove_card(photo_card);
            });

            stack = new Gtk.Stack ();
            stack.add_named (download_container,    STACK_SLIDESHOW_DOWNLADING);
            stack.add_named (generate_btn,          STACK_BUTTON);
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            stack.set_no_show_all (true);

            attach (image_header,       0, 0, 3, 1);
            attach (label_info,         0, 1, 3, 1);
            attach (generate_label,     0, 3, 1, 1);
            attach (image_info,         1, 3, 1, 1);
            attach (images_preview,     0, 4, 3, 1);
            attach (stack,              0, 5, 3, 3);

            update_visibility ();
        }


        public void remove_card (CardPhotoView new_card) {
            selected_photos.remove(new_card);

            string selected_num = "";
            if (get_num_selected () > 0) {
                selected_num = "%d photos selected".printf(get_num_selected());
            } else {
                selected_num = "Select 1 or more photos by clicking on ";
            }

            generate_label.set_text(selected_num);
            update_visibility ();
            images_preview.delete_card(new_card);
        }

        public void add_card (CardPhotoView new_card) {
            selected_photos.append(new_card);

            string selected_num = "%d photos selected".printf(get_num_selected());
            generate_label.set_text(selected_num);
            update_visibility ();
            images_preview.attach_photo (new_card);
        }

        public void generate_multiple_wallpaper() {
            AppConnection connection = AppConnection.get_instance();
            List<Wallpaper> wallpaper_list = new List<Wallpaper>();

            double progress_step = 1.0 / get_num_selected();
            double global_progress = 0;
            int step = 0;

            selected_photos.foreach( ( photo_card ) => {
                Photo photo = photo_card.get_photo();

                string? url_photo = connection.get_url_photo(photo.links.download_location);
                Wallpaper wallpaper = new Wallpaper (url_photo, photo.id, photo.user.name);
                wallpaper.on_progress.connect ((p) => {
                    global_progress = calculate_progress (p, step);
                    update_global_progress (global_progress, wallpaper);
                });

                if (wallpaper.download_picture()) {
                    print("Success!: %s\n", wallpaper.full_picture_path);
                    wallpaper_list.append(wallpaper);
                    //global_progress += progress_step;
                } else {
                    print("Error\n");
                }

                step ++;
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
                show_preparing_progress (STACK_BUTTON);
            } else {
                stack.set_visible (false);
            }
        }

        private int get_num_selected () {
            if (selected_photos != null) {
                return (int) selected_photos.length();
            } else {
                return 0;
            }
        }

        private double calculate_progress (double progress_step, int step) {
            var progress = (progress_step / (double) selected_photos.length()) + (double) (step * (1 / (double) selected_photos.length())) ;
            return progress;
        }

        private void end_global_progress () {
            show_preparing_progress (STACK_BUTTON);
            Granite.Services.Application.set_progress_visible.begin (false, (obj, res) => {
                try {
                    Granite.Services.Application.set_progress_visible.end (res);
                } catch (GLib.Error e) {
                    critical (e.message);
                }
            });
            show_notify_success();
        }

        private void update_global_progress (double progress, Wallpaper wallpaper) {
            global_bar.set_fraction (progress);
            print ("\n\nProgreso: ");
            print (progress.to_string ());
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

        private void show_preparing_progress (string stack_name) {
            stack.set_visible (true);

            if (stack_name == STACK_BUTTON) {
                generate_btn.set_visible (is_multiple);
            } else {
                download_container.show_all ();
            }

            stack.set_visible_child_name (stack_name);
        }

    }
}
