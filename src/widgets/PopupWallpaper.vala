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

namespace App.Widgets {

    /**
     * The {@code PopupWallpaper} class is responsible for displaying a popup menu.
     *
     * @see Gtk.HeaderBar
     * @since 1.1.0
     */
    public class PopupWallpaper : Gtk.Grid {
        public PopupWallpaper(int64 width, int64 height) {

            this.margin = 12;
            this.column_spacing = 8;
            this.row_spacing = 8;

            var label = new Label(_("Set wallpaper as"));
            var buttom_wall = new Button.with_label(_("Wallpaper"));
            var buttom_cen = new Button.with_label(_("Centered"));
            var buttom_scal = new Button.with_label(_("Scaled"));
            var buttom_stret = new Button.with_label(_("Stretched"));
            var buttom_zoom = new Button.with_label(_("Zoom"));
            var buttom_span = new Button.with_label(_("Spanned"));
            string size = width.to_string() + " x " + height.to_string();
            var label_size = new Label(size);

            label.get_style_context ().add_class ("title-popup");
            label_size.get_style_context ().add_class ("title-text");
            buttom_wall.get_style_context ().add_class("button-green-popup");
            buttom_cen.get_style_context ().add_class("button-green-popup");
            buttom_scal.get_style_context ().add_class("button-green-popup");
            buttom_stret.get_style_context ().add_class("button-green-popup");
            buttom_zoom.get_style_context ().add_class("button-green-popup");
            buttom_span.get_style_context ().add_class("button-green-popup");

            buttom_wall.clicked.connect ( ()=>{
                print("Wall");
            } );

            buttom_cen.clicked.connect ( ()=>{
                print("center");
            } );

            buttom_scal.clicked.connect ( ()=>{
                print("scaled");
            } );

            buttom_stret.clicked.connect ( ()=>{
                print("stretch");
            } );

            buttom_zoom.clicked.connect ( ()=>{
                print("zoom");
            } );

            buttom_span.clicked.connect ( ()=>{
                print("spanned");
            } );

            this.attach(label, 0, 0, 2, 1);
            this.attach(buttom_wall, 0, 1, 1, 1);
            this.attach(buttom_cen, 1, 1, 1, 1);
            this.attach(buttom_scal, 0, 2, 1, 1);
            this.attach(buttom_stret, 1, 2, 1, 1);
            this.attach(buttom_span, 0, 3, 1, 1);
            this.attach(buttom_zoom, 1, 3, 1, 1);
            this.attach(label_size, 0, 4, 2, 1);
            this.show_all();
        }
    }
}