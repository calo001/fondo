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
using App.Connection;
using App.Utils;

namespace App.Views {

    public class CardPhotoView : Gtk.Grid {

        private File                    file_photo;
        private Granite.AsyncImage      image;
        private Gtk.Button              btn_view;
        private Gtk.EventBox            eventbox_photo;
        private Gtk.LinkButton          label_autor;
        private Wallpaper               wallpaper;
        private AppConnection           connection;
        private Gtk.ProgressBar         bar;
        private Gtk.Revealer            revealer;
        private Photo                   photo;

        // Construct
        public CardPhotoView (Photo photo) {
            this.photo = photo;
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin_bottom = 10;

            // Create File Object
            this.file_photo = File.new_for_uri (photo.urls_thumb);
            
            // Create AsyncImage object
            this.image = new Granite.AsyncImage(true, true);
            this.image.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            image.set_from_file_async(file_photo, 280, 180, false); // Width, Heigth
            image.has_tooltip = true;
            image.set_tooltip_text (photo.location);

            this.eventbox_photo = new Gtk.EventBox();
            this.eventbox_photo.button_press_event.connect (() => {
                set_as_wallpaper ();
                return true;
            });
            this.eventbox_photo.add(image);

            // Create Button
            this.btn_view = new Gtk.Button.from_icon_name ("window-maximize-symbolic");
            btn_view.get_style_context ().add_class ("button-green");
            btn_view.get_style_context ().add_class ("transition");
            btn_view.halign = Gtk.Align.CENTER;

            btn_view.clicked.connect (() => {
                var prev_win = new PreviewWindow(photo);
                prev_win.show_all ();
                prev_win.load_content();
		    });

            // Autor photo logo
            var logo = new Granite.AsyncImage.from_icon_name_async ("emblem-photos-symbolic", Gtk.IconSize.BUTTON);

            // Create labelAutor
            var link = @"https://unsplash.com/@$(photo.username)?utm_source=$(Constants.PROGRAME_NAME)&utm_medium=referral";
            label_autor = new Gtk.LinkButton.with_label(link, "   " + photo.name);
            this.label_autor.get_style_context ().remove_class ("button");
            this.label_autor.get_style_context ().remove_class ("flat");
            this.label_autor.get_style_context ().add_class ("h4");
            this.label_autor.get_style_context ().add_class ("autor");
            this.label_autor.halign = Gtk.Align.START;
            this.label_autor.xalign = 0f;
            this.label_autor.margin_start = 8;
            this.label_autor.has_tooltip = false;
            this.label_autor.always_show_image = true;
            this.label_autor.set_image (logo);

            // Create Horizontal Grid
            var grid_actions = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            grid_actions.margin_top = 10;
            grid_actions.pack_start(label_autor, true, true, 0);
            grid_actions.pack_end(btn_view, false, false, 0);

            // ProgressBar
            this.bar = new Gtk.ProgressBar ();
            this.bar.get_style_context ().remove_class ("trough");
            this.bar.get_style_context ().add_class ("revealer");
            this.bar.margin_top = 10;
            // Reveal
            this.revealer = new Gtk.Revealer ();
            this.revealer.add (bar);

            // Add view to custom Grid
            this.add(eventbox_photo);
            this.add(revealer);
            this.add(grid_actions);

        }

        public void set_as_wallpaper () {
            print ("Intento poner wallpaper");
            this.revealer.set_reveal_child (true);
            this.connection = new AppConnection();
            string url_photo = connection.get_url_photo(photo.links_download_location);
            this.wallpaper = new Wallpaper (url_photo, photo.id, photo.username, bar);
            this.wallpaper.update_wallpaper ();
        }
    }

}
