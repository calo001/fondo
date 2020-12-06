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
using App.Models;

namespace App.Popover {

    /**
     * The {@code PopupWallpaper} class is responsible for displaying a popup menu content.
     *
     * @see Gtk.HeaderBar
     * @since 1.1.0
     */
    public class PhotoDetailPopover : Gtk.Popover {
        public signal void set_as_wallpaper ();
        
        public PhotoDetailPopover(Photo photo, Gtk.Widget relative_to) {
            Object (
                relative_to: relative_to,
                position: Gtk.PositionType.TOP,
                modal: true
            );

            var grid_content = new Gtk.Grid ();

            var grid_user = new Gtk.Grid ();
            grid_user.margin = 16;
            grid_user.column_spacing = 8;
            grid_user.row_spacing = 8;

            var file_profile_image = File.new_for_uri (photo.user.profile_image.medium);
            var image_profile_image = new Granite.AsyncImage(true, true);
            image_profile_image.get_style_context ().add_class ("card");
            image_profile_image.margin_end = 8;
            image_profile_image.set_from_file_async.begin(file_profile_image, 95, 95, false);
            image_profile_image.valign = Gtk.Align.CENTER;
            grid_user.attach(image_profile_image, 0, 0, 1, 3);

            var name = new Gtk.Label (photo.user.name);
            name.expand = true;
            name.get_style_context ().add_class ("h1");
            name.expand = true;
            name.halign = Gtk.Align.START;
            name.selectable = true;
            grid_user.attach(name,                2, 0, 1, 1);

            if (photo.user.bio != null) {
                var bio = new Gtk.Label (photo.user.bio);
                bio.expand = true;
                bio.halign = Gtk.Align.START;
                bio.xalign = 0;
                bio.selectable = true;
                bio.wrap = true;
                bio.width_chars = 1;
                bio.max_width_chars = 50;
                grid_user.attach(bio,                 2, 1, 1, 1);
            }

            var location = new Gtk.Label (photo.user.location);
            location.expand = true;
            location.halign = Gtk.Align.START;
            location.selectable = true;
            grid_user.attach(location,            2, 2, 1, 1);

            var separator = new Separator (Orientation.HORIZONTAL);

            /* ************************************************************** */

            var grid_details = new Gtk.Grid ();
            grid_details.margin = 16;
            grid_details.column_spacing = 8;
            grid_details.row_spacing = 8;

            var lbl_created_at = new Gtk.Label (photo.created_at);
            lbl_created_at.expand = true;
            lbl_created_at.halign = Gtk.Align.START;
            lbl_created_at.selectable = true;
            var lbl_created_at_img = new Image.from_icon_name ("office-calendar-symbolic", IconSize.BUTTON);
            grid_details.attach (lbl_created_at_img,    0, 0, 1, 1);
            grid_details.attach (lbl_created_at,        1, 0, 1, 1);

            var lbl_width = new Gtk.Label (photo.width.to_string () + " px");
            lbl_width.expand = true;
            lbl_width.halign = Gtk.Align.START;
            lbl_width.selectable = true;
            var lbl_width_img = new Image.from_icon_name ("object-flip-horizontal-symbolic", IconSize.BUTTON);
            grid_details.attach (lbl_width_img,         0, 1, 1, 1);
            grid_details.attach (lbl_width,             1, 1, 1, 1);

            var lbl_height = new Gtk.Label (photo.height.to_string () + " px");
            lbl_height.expand = true;
            lbl_height.halign = Gtk.Align.START;
            lbl_height.selectable = true;
            var lbl_height_img = new Image.from_icon_name ("object-flip-vertical-symbolic", IconSize.BUTTON);
            grid_details.attach (lbl_height_img,        0, 2, 1, 1);
            grid_details.attach (lbl_height,            1, 2, 1, 1);
            
            if (photo.description != null) {
                var lbl_description = new Gtk.Label (photo.description);
                lbl_description.expand = true;
                lbl_description.halign = Gtk.Align.START;
                lbl_description.selectable = true;
                lbl_description.wrap = true;
                lbl_description.width_chars = 1;
                lbl_description.max_width_chars = 50;
                var lbl_description_img = new Image.from_icon_name ("format-justify-left-symbolic", IconSize.BUTTON);
                grid_details.attach (lbl_description_img,   0, 3, 1, 1);
                grid_details.attach (lbl_description,       1, 3, 1, 1);
            }

            var lbl_color = new Gtk.Label (photo.color);
            lbl_color.expand = true;
            lbl_color.halign = Gtk.Align.START;
            lbl_color.selectable = true;
            var lbl_color_img = new Image.from_icon_name ("applications-graphics-symbolic", IconSize.BUTTON);
            grid_details.attach (lbl_color_img,         0, 4, 1, 1);
            grid_details.attach (lbl_color,             1, 4, 1, 1);

            /************************************************** */

            var btn_set_wallpaper = new Gtk.Button.with_label (S.SET_AS_WALLPAPER);
            btn_set_wallpaper.halign = Gtk.Align.CENTER;
            btn_set_wallpaper.get_style_context (). add_class ("suggested-action");

            var btn_user_profile = new Gtk.LinkButton.with_label (photo.autor_link, S.USER_PROFILE);
            btn_user_profile.halign = Gtk.Align.CENTER;
            btn_user_profile.get_style_context ().add_class ("button");
            btn_user_profile.get_style_context ().remove_class ("link");

            var box_btns = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 8);
            box_btns.halign = Gtk.Align.END;
            box_btns.add (btn_user_profile);
            box_btns.add (btn_set_wallpaper);

            btn_set_wallpaper.clicked.connect (() => {
                set_as_wallpaper ();
            });

            grid_details.attach (box_btns,              1, 5, 1, 1);

            grid_details.show_all ();
            grid_content.attach (grid_user,    0, 0, 1, 1);         
            grid_content.attach (separator,    0, 1, 1, 1);
            grid_content.attach (grid_details, 0, 2, 1, 1);
            grid_content.show_all ();
            add (grid_content);
        }
    }
}
