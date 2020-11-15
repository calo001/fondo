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
     * The {@code MultipleCardPhoto} class is responsible for displaying
     * a photo item in the MultiplePreviewWidget
     *
     */
    public class MultipleCardFlowBoxChild : Gtk.FlowBoxChild {
        private Gtk.Image indicator_greeter; 
        public signal void on_delete ();
        public signal void on_click ();
        public Photo photo {get; private set;}

        public MultipleCardFlowBoxChild (Photo photo, File file_photo) {
            this.photo = photo;
            var image = new Granite.AsyncImage(true, true);
            image.get_style_context(). add_class ("image_grid");
            var w_max = 80;
            var h_max = 60;

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

            var eventbox = new Gtk.EventBox ();
            eventbox.add (image);

            var overlay = new Gtk.Overlay();
            overlay.add (eventbox);
            overlay.width_request = w_photo;
            overlay.height_request = h_photo;

            var btn_delete = new Gtk.Button.from_icon_name ("window-close-symbolic");
            btn_delete.get_style_context ().add_class ("button-action");
            btn_delete.get_style_context ().remove_class ("button");
            btn_delete.can_focus = false;
            btn_delete.halign = Gtk.Align.END;
            btn_delete.valign = Gtk.Align.START;
            btn_delete.can_default = true;
            btn_delete.clicked.connect (() => {
                on_delete ();
            });

            indicator_greeter = new Gtk.Image (); 
            indicator_greeter.gicon = new ThemedIcon ("user-available");
            indicator_greeter.halign = Gtk.Align.CENTER;
            indicator_greeter.valign = Gtk.Align.END;
            indicator_greeter.set_no_show_all (true);
            indicator_greeter.set_has_tooltip (true);
            indicator_greeter.tooltip_text = "Usar en pantalla de login";

            overlay.add_overlay (btn_delete);

            App.Delegate.validate_greeter (() => {
                overlay.add_overlay (indicator_greeter);
            });

            eventbox.button_release_event.connect ( ()=> {
                on_click ();
                return false;
            });

            this.add(overlay);
            this.set_visible(true);
        }

        public void show_indicator (bool show) {
            indicator_greeter.set_visible (show);
        }

        private static int[] scale (int w_h_photo, int w_h_card, int width, int height) {
            double card_scale = (double) w_h_card / (double) w_h_photo;
            var w_photo = (int)(width * card_scale);
            var h_photo = (int)(height * card_scale);
            return {w_photo, h_photo};
        }
    }
}
