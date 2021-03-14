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
    public class MultiplePreviewWidget : Gtk.ScrolledWindow {

        public signal void delete_preview_image (CardPhotoView photo_card);

        private Gee.HashMap<CardPhotoView, MultipleCardFlowBoxChild> card_widget_map;
        private Gtk.FlowBox flowbox;
        private const int ITEMS_PER_ROW = 3;
        private const int VISIBLE_ROWS = 3;
        private const int SCROLLABLE_WIDTH = 350;
        private const int SCROLLABLE_ROW_HEIGHT = 100;

        public MultiplePreviewWidget () {
            this.set_min_content_width(SCROLLABLE_WIDTH);
            this.halign = Gtk.Align.FILL;
            this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);

            flowbox = new Gtk.FlowBox();
            flowbox.set_max_children_per_line(ITEMS_PER_ROW);
            flowbox.set_min_children_per_line(ITEMS_PER_ROW);
            flowbox.homogeneous = true;
            card_widget_map = new Gee.HashMap<CardPhotoView, MultipleCardFlowBoxChild>();

            this.add(flowbox);
            flowbox.show();
        }

        public void attach_photo (CardPhotoView single_card) {
            File file_photo = single_card.get_file_photo();
            Photo photo = single_card.get_photo();
            MultipleCardFlowBoxChild flow_multiple = new MultipleCardFlowBoxChild (photo, file_photo);

            card_widget_map.set(single_card, flow_multiple);

            flow_multiple.on_delete.connect ( () => {
                delete_preview_image (single_card);
                delete_card (single_card);
            });

            flow_multiple.on_click.connect ( () => {
                update_indicator (single_card);
            });

            setup_fist (single_card);
            flowbox.add(flow_multiple);
            recalculate_scroll_size(card_widget_map.size);
            show_all();
        }

        private void recalculate_scroll_size (int num_items) {
            if (num_items == 0) {
                this.set_min_content_height(0);
            } else {
                double current_rows = Math.ceil((double)num_items/VISIBLE_ROWS);
                int rows = int.min(VISIBLE_ROWS, (int)current_rows);
                this.set_min_content_height(SCROLLABLE_ROW_HEIGHT * rows);
            }
        }

        private void setup_fist (CardPhotoView single_card) {
            if (card_widget_map.size == 1) {
                var child_widget = card_widget_map.get (single_card);
                child_widget.show_indicator (true);
                single_card.is_for_greeter = true;
            }
        }

        public void delete_card (CardPhotoView card) {
            var child_widget = card_widget_map.get(card);
            flowbox.remove(child_widget);
            card_widget_map.unset (card);
            if (card.is_for_greeter) {
                set_greeter_default ();
            }
        }

        private void set_greeter_default () {
            if (card_widget_map.size > 0 && flowbox.get_children ().length () > 0) {
                MultipleCardFlowBoxChild child = (MultipleCardFlowBoxChild) flowbox.get_children ().nth_data (0);
                card_widget_map.@foreach ( (card) => {
                    if (card.value == child) {
                        card.value.show_indicator (true);
                        card.key.is_for_greeter = true;        
                    }
                    return true;
                });
            }
        }        

        private void update_indicator (CardPhotoView single_card) {
            var child_widget = card_widget_map.get (single_card);
            card_widget_map.@foreach ( (card) => {
                if (child_widget == card.value) {
                    card.value.show_indicator (true);
                    card.key.is_for_greeter = true;
                } else {
                    card.value.show_indicator (false);
                    card.key.is_for_greeter = false;
                }
                return true;
            });
        }

        public void clear_all () {
            card_widget_map.@foreach( (card) => {
                delete_card (card.key);
                return true;
            } );
            card_widget_map = new Gee.HashMap<CardPhotoView, MultipleCardFlowBoxChild>();
            flowbox.forall ( (flow_b) => flowbox.remove(flow_b) );
        }
    }
}
