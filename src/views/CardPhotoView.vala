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

using App.Configs;
using App.Structs;

namespace App.Views {

    public class CardPhotoView : Gtk.Grid {

        private File                    file_photo;
        private File                    file_avatar;
        private Granite.AsyncImage      image;
        private Granite.AsyncImage      image_avatar;
        private Gtk.Button              btn_view;

        // Construct
        public CardPhotoView (Photo photo) {

            this.orientation = Gtk.Orientation.VERTICAL;
            this.get_style_context ().add_class ("card-hover");
            this.margin_bottom = 10;

            // Create File Object
            this.file_photo = File.new_for_uri (photo.urls_thumb);
            
            // Create AsyncImage object
            this.image = new Granite.AsyncImage(true, true);
            image.set_from_file_async(file_photo, 280, 180, false); // Width, Heigth
            image.has_tooltip = true;
            image.set_tooltip_text (photo.location);

            // Create Button
            this.btn_view = new Gtk.Button.with_label(_("Preview"));
            btn_view.get_style_context ().add_class ("button-green");
            btn_view.get_style_context ().add_class ("transition");
            btn_view.halign = Gtk.Align.CENTER;

            // Create labelAutor
            var label_autor = new Gtk.Label(photo.name);
            label_autor.get_style_context ().add_class ("h3");
            label_autor.xalign = 0.5f;

            // Create avatar user
            this.file_avatar = File.new_for_uri(photo.profile_image_small);
            this.image_avatar = new Granite.AsyncImage(true, true);
            image_avatar.set_from_file_async(file_avatar, 15, 15, false); // Width, Heigth
            image_avatar.get_style_context ().add_class ("card");
            image_avatar.valign = Gtk.Align.CENTER;

            // Create grid info user
            //var grid_user = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            //grid_user.pack_start(image_avatar, false, false, 3);
            //grid_user.pack_start(label_autor, false, false, 3);

            var grid_user = new Gtk.Grid();
            grid_user.margin_top = 5;
            grid_user.halign = Gtk.Align.CENTER;
            grid_user.column_spacing = 10;
            grid_user.attach(image_avatar, 1, 1, 1, 1);
            grid_user.attach(label_autor, 2, 1, 1, 1);

            // Create Horizontal Grid
            var grid_actions = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
            grid_actions.pack_start(grid_user, true, true, 0);
            grid_actions.pack_end(btn_view, false, false, 0);

            // Add view to custom Grid
            this.add(image);
            this.add(grid_actions);
        }
    }

}
