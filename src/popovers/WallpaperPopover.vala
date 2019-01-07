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
namespace App.Popover {

    /**
     * The {@code PopupWallpaper} class is responsible for displaying a popup menu content.
     *
     * @see Gtk.HeaderBar
     * @since 1.1.0
     */
    public class WallpaperPopover : Gtk.Popover {
        public signal void wallpaper_option(string option_wall);
        public int64 width {get; set;}
        public int64 height {get; set;}

        public WallpaperPopover(int64 width, int64 height, Gtk.Widget relative_to) {
            Object (
                width: width,
                height: height,
                relative_to: relative_to,
                position: Gtk.PositionType.TOP,
                modal: true
            );

            var grid_content = new Gtk.Grid ();
            grid_content.margin = 12;
            grid_content.column_spacing = 8;
            grid_content.row_spacing = 8;

            var label = new Label(S.OPTIONS);
            var buttom_cen = new Button.with_label(S.CENTERED);
            var buttom_scal = new Button.with_label(S.SCALED);
            var buttom_zoom = new Button.with_label(S.ZOOM);
            var buttom_span = new Button.with_label(S.SPANNED);
            string size = width.to_string() + " x " + height.to_string();
            var label_size = new Label(size);

            label.get_style_context ().add_class ("title-popup");
            label_size.get_style_context ().add_class ("title-text");
            buttom_cen.get_style_context ().add_class("button-green-popup");
            buttom_scal.get_style_context ().add_class("button-green-popup");
            buttom_zoom.get_style_context ().add_class("button-green-popup");
            buttom_span.get_style_context ().add_class("button-green-popup");

            buttom_cen.get_style_context ().add_class("flat");
            buttom_scal.get_style_context ().add_class("flat");
            buttom_zoom.get_style_context ().add_class("flat");
            buttom_span.get_style_context ().add_class("flat");

            buttom_cen.clicked.connect ( ()=>{
                wallpaper_option("centered");
            } );

            buttom_scal.clicked.connect ( ()=>{
                wallpaper_option("scaled");
            } );

            buttom_zoom.clicked.connect ( ()=>{
                wallpaper_option("zoom");
            } );

            buttom_span.clicked.connect ( ()=>{
                wallpaper_option("spanned");
            } );

            grid_content.attach(label, 0, 0, 1, 1);         
            grid_content.attach(buttom_cen, 0, 1, 1, 1);
            grid_content.attach(buttom_scal, 0, 2, 1, 1);
            grid_content.attach(buttom_span, 0, 3, 1, 1);
            grid_content.attach(buttom_zoom, 0, 4, 1, 1);
            grid_content.attach(label_size, 0, 5, 1, 1);
            grid_content.show_all();
            add (grid_content);
        }
    }
}
