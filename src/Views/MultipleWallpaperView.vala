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

namespace App.Views {

    /**
     * The {@code MultipleWallpaperView} class to hold all logic about MultipleWallpapers
     *
     * @since 1.0.0
     */
    public class MultipleWallpaperView : Gtk.Grid {

        public signal void close_multiple_view ();
        public signal void multiple_selection (bool isMultiple);

        private unowned List<CardPhotoView?>    selected_photos;
        private bool                            is_multiple;
        private Gtk.Label                       label_info;

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

            attach (label_info,         0, 0, 1, 1);
            attach (multiple_select,    0, 1, 1, 1);
        }

        public void update_photos(List<CardPhotoView?> photos) {
            selected_photos = photos;
            string selected_num = "Selected: %d\n".printf((int) photos.length());

            label_info.set_text(selected_num);
        }
    }
}
