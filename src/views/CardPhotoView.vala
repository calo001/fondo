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
        private Gtk.Button              btn_use;

        // Construct
        public CardPhotoView () {
            
            // Setup styles
            //this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            this.orientation = Gtk.Orientation.VERTICAL;

            // Create File Object
            this.file = File.new_for_uri (Constants.IMAGE);
            
            // Create AsyncImage object
            this.image = new Granite.AsyncImage(true, true);
            image.set_from_file_async(file, 280, 180, false); // Width, Heigth
            image.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            image.get_style_context ().add_class ("transition");
            image.get_style_context ().add_class ("photo");

            // Create Buttons
            this.btn_view = new Gtk.Button.with_label(_("View"));
            this.btn_use = new Gtk.Button.with_label(_("Use"));
            btn_view.get_style_context ().add_class ("button-green");
            btn_view.get_style_context ().add_class ("transition");
            btn_use.get_style_context ().add_class ("button-green");
            btn_use.get_style_context ().add_class ("transition");
            btn_view.margin = 10;
            btn_view.margin_right= 5;
            btn_use.margin = 10;
            btn_use.margin_left =5;

            // Create labelAutor
            var label_autor = new Gtk.Label(_("Autor name"));
            label_autor.get_style_context ().add_class ("label_autor");
            label_autor.margin = 15;
            label_autor.width_request =120;

            // Create Horizontal Grid
            var grid_actions = new Gtk.Grid();
            grid_actions.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            grid_actions.get_style_context ().add_class ("grid_actions");
            //grid_actions.column_spacing= 2;
            grid_actions.attach(label_autor, 0, 0, 4, 1);
            grid_actions.attach(btn_view, 4, 0, 2, 1);
            grid_actions.attach(btn_use, 6, 0, 2, 1);

            // Add view to custom Grid
            this.add(image);
            this.add(grid_actions);
        }
    }

}
