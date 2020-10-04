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
        private Gtk.ProgressBar                     image_bar;   // Global Generation bar
        private Gtk.ProgressBar                     global_bar;   // Global Generation bar

        /**
         * Constructs a new {@code MultipleWallpaperView} object.
         */
        public MultipleWallpaperView () {
            is_multiple = false;

            label_info = new Gtk.Label ("Select multiple Wallpapers");

            Gtk.Button multiple_select = new Gtk.Button();
            multiple_select.set_label("Activate Multiple Selection");
            multiple_select.valign = Gtk.Align.CENTER;
            multiple_select.tooltip_text = "Selección múltiple";
            multiple_select.clicked.connect ( ()=> {
                is_multiple = !is_multiple;
                multiple_selection(is_multiple);
            });


            Gtk.Button generate_btn = new Gtk.Button();
            generate_btn.set_label("Generate!");
            generate_btn.valign = Gtk.Align.CENTER;
            generate_btn.tooltip_text = "Generate";
            generate_btn.clicked.connect ( ()=> {
                print("Generate!!!!");
                generate_multiple_wallpaper();
            });

            image_bar = new Gtk.ProgressBar ();
            global_bar = new Gtk.ProgressBar ();

            attach (label_info,         0, 0, 1, 1);
            attach (multiple_select,    0, 1, 1, 1);
            attach (generate_btn,       0, 2, 1, 1);
            attach (image_bar,          0, 3, 1, 1);
            attach (global_bar,         0, 4, 1, 1);

        }

        public void update_photos(List<CardPhotoView?> photos) {
            selected_photos = photos;
            string selected_num = "Selected: %d\n".printf((int) photos.length());

            label_info.set_text(selected_num);
        }

        public void generate_multiple_wallpaper() {
            AppConnection connection = AppConnection.get_instance();
            List<Wallpaper> wallpaper_list = new List<Wallpaper>();
            selected_photos.foreach( ( photo_card ) => {
                Photo photo = photo_card.get_photo();

                string? url_photo = connection.get_url_photo(photo.links.download_location);
                Wallpaper wallpaper = new Wallpaper (url_photo, photo.id, photo.user.name, image_bar);
                if (wallpaper.download_picture()) {
                    print("Success!!: %s\n", wallpaper.full_picture_path);
                    wallpaper_list.append(wallpaper);
                } else {
                    print("Error\n");
                }
            });

            MultiWallpaper multiple_wallpaper = new MultiWallpaper(wallpaper_list);
            multiple_wallpaper.set_wallpaper();
        }
    }
}
