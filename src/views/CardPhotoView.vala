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

namespace App.Views {

    public class CardPhotoView : Gtk.Grid {

        private File                    file;
        private Granite.AsyncImage      image;
        private Gtk.Button              btn_view;

        // Construct
        public CardPhotoView (string link_photo) {

            this.orientation = Gtk.Orientation.VERTICAL;
            this.get_style_context ().add_class ("card-hover");
            this.margin_bottom = 10;

            // Create File Object
            this.file = File.new_for_uri (link_photo);
            
            // Create AsyncImage object
            this.image = new Granite.AsyncImage(true, true);
            image.set_from_file_async(file, 280, 180, false); // Width, Heigth

            // Create Button
            this.btn_view = new Gtk.Button.with_label(_("Preview"));
            btn_view.get_style_context ().add_class ("button-green");
            btn_view.get_style_context ().add_class ("transition");
            btn_view.halign = Gtk.Align.CENTER;

            // Create labelAutor
            var label_autor = new Gtk.Label(_("Autor name"));
            label_autor.get_style_context ().add_class ("h2");
            label_autor.xalign = 0.5f;

            // Create Horizontal Grid
            var grid_actions = new Gtk.Box(Gtk.Orientation.VERTICAL, 3);
            grid_actions.pack_start(label_autor, true, true, 0);
            grid_actions.pack_end(btn_view, false, false, 0);

            // Add view to custom Grid
            this.add(image);
            this.add(grid_actions);
        }
    }

}
