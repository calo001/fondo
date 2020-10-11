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

using App.Views;
using App.Models;

namespace App.Widgets {

    /**
     * The {@code MultiplePreviewWidget} class is responsible for displaying
     * a list of selected wallpapers
     *
     */
    public class MultiplePreviewWidget : Gtk.FlowBox {

        public signal void delete_preview_image(CardPhotoView photo_card);

        private List<CardPhotoView> current_photo_cards;

        public MultiplePreviewWidget () {
            this.set_max_children_per_line(2);
            this.set_min_children_per_line(2);
            this.get_style_context ().add_class ("images_preview_grid");

            current_photo_cards = new List<CardPhotoView>();
        }


        public void find_changed_element(List<CardPhotoView> photos) {
            List<CardPhotoView> new_elements = new List<CardPhotoView>();
            for (int i = 0; i < photos.length(); i++) {
                bool included = false;
                for (int j = 0; j < current_photo_cards.length(); j++) {
                    if (photos.nth_data(i) == current_photo_cards.nth_data(j)) {
                        included |= true;
                        break;
                    }
                }
                if (!included) {
                    new_elements.append(photos.nth_data(i));
                }
            }
            add_elements(new_elements);
        }


        public void add_elements (List<CardPhotoView> photos) {
            photos.foreach ((photo_card) => {
                attach_photo(0, photo_card);
                current_photo_cards.append(photo_card);
            });
        }


        public void generate (List<CardPhotoView> photos) {
            find_changed_element(photos);
        }


        private void attach_photo (int photo_num, CardPhotoView single_card) {
            print("2F - %s\n",single_card == null ? "true" : "false");
            File file_photo = single_card.get_file_photo();
            Photo photo = single_card.get_photo();
            var image = new Granite.AsyncImage(true, true);
            image.get_style_context(). add_class ("image_grid");
            image.get_style_context ().add_class ("backimg");
            image.get_style_context ().add_class ("gradient_back");
            var w_max = 80;
            var h_max = 60;
            // var w_photo = (int) w_max;
            // var h_photo = (int) h_max;


            var w_photo = (int) photo.width;
            var h_photo = (int) photo.height;

            // Resize photo with a max height and width
            if (w_photo > w_max) {
                int[] scale_res = scale (w_photo, w_max, w_photo, h_photo);
                w_photo = scale_res[0];
                h_photo = scale_res[1];
                if (h_photo > h_max) {
                    scale_res = scale (h_photo, h_max, w_photo, h_photo);
                    w_photo = scale_res[0];
                    h_photo = scale_res[1];
                }
            }

            image.set_from_file_async.begin(file_photo, w_photo, h_photo, false, null, (res) => {
                image.get_style_context ().remove_class ("gradient_back");
            });


            var overlay = new Gtk.Overlay();
            overlay.add (image);
            overlay.width_request = w_photo;
            overlay.height_request = h_photo;

            var child = new Gtk.FlowBoxChild();
            child.add(overlay);
            child.set_visible(true);

            var btn_delete = new Gtk.Button.from_icon_name ("window-close-symbolic");
            btn_delete.get_style_context ().add_class ("button-action");
            btn_delete.get_style_context ().remove_class ("button");
            btn_delete.can_focus = false;
            btn_delete.halign = Gtk.Align.END;
            btn_delete.valign = Gtk.Align.START;
            btn_delete.can_default = true;
            btn_delete.clicked.connect (() => {
                delete_preview_image(single_card);
                delete_children_special(child);
                current_photo_cards.remove(single_card);
            });

            overlay.add_overlay (btn_delete);

            this.add(child);

            show_all();
        }

        private void delete_children_special (Gtk.Widget element) {
            element.set_no_show_all(true);
            element.set_visible(false);
        }

        private static int[] scale (int w_h_photo, int w_h_card, int width, int height) {
            double card_scale = (double) w_h_card / (double) w_h_photo;
            var w_photo = (int)(width * card_scale);
            var h_photo = (int)(height * card_scale);
            return {w_photo, h_photo};
        }
    }
}
