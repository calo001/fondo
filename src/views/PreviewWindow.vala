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

using App.Structs;
using App.Utils;
using App.Connection;

namespace App.Views {
    public class PreviewWindow : Gtk.Window {
        private Granite.AsyncImage      image;
        private Wallpaper               wallpaper;
        private Gtk.ProgressBar         bar;
        private Gtk.Stack               stack;
        private AppConnection           connection;
        private Photo                   photo;
        private int                     w_photo;
        private int                     h_photo;

        public PreviewWindow (Photo photo){
            this.w_photo = (int) photo.width;
            this.h_photo = (int) photo.height;
            this.photo = photo;
            var css_provider = new Gtk.CssProvider ();
            try {
                css_provider.load_from_data (
                """
                    .prev-window {
                        background:
                        linear-gradient(27deg, #151515 5px, transparent 5px) 0 5px,
                        linear-gradient(207deg, #151515 5px, transparent 5px) 10px 0px,
                        linear-gradient(27deg, #222 5px, transparent 5px) 0px 10px,
                        linear-gradient(207deg, #222 5px, transparent 5px) 10px 5px,
                        linear-gradient(90deg, #1b1b1b 10px, transparent 10px),
                        linear-gradient(#1d1d1d 25%, #1a1a1a 25%, #1a1a1a 50%, transparent 50%, transparent 75%, #242424 75%, #242424);
                        background-color: #131313;
                        background-size: 20px 20px;
                    }
                    """
                );
                Gtk.StyleContext.add_provider_for_screen (
                    Gdk.Screen.get_default (),
                    css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION );
                get_style_context ().add_class ("prev-window");
            } catch (Error e) {
                message ("error loading CSS provider");
            }
		    fullscreen ();

            var label = new Gtk.Label("Loading ...");
            label.get_style_context ().add_class ("h1");
            bar = new Gtk.ProgressBar ();

            // Container
            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 20);
            box.valign = Gtk.Align.CENTER;
            box.halign = Gtk.Align.CENTER;
            box.pack_start(label, true, true, 0);
            box.pack_start(bar, true, true, 0);

            // Image
            image = new Granite.AsyncImage ();

            // Stack
            stack = new Gtk.Stack();
            stack.set_transition_duration (500);
            stack.set_transition_type (Gtk.StackTransitionType.CROSSFADE);

            stack.add_named (box, "box");
            stack.add_named (image, "image");
            stack.set_visible_child_name ("box");

            this.add (stack);
        }

        public void load_content () {

		    connection = new AppConnection();
            var url_photo = connection.get_url_photo(photo.links_download_location);
            wallpaper = new Wallpaper(url_photo, photo.id, photo.username, bar);
            wallpaper.download_picture ();
            var path_wallpaper = wallpaper.full_picture_path;

            // Create File Object
            var file_photo = File.new_for_path (path_wallpaper);
            //var file_photo = File.new_for_path ("/home/carlos/.local/share/backgrounds/AGe9S2Uj8Lg.jpeg");

            // Calc Screen Width & Heigth
            int w_screen;
            int h_screen;
            this.get_size (out w_screen, out h_screen);
            if (w_photo > w_screen) {
                scale (w_photo, w_screen);
                if (h_photo > h_screen) {
                    scale (h_photo, h_screen);
                }
            }
            // Show image
            image.set_from_file_async (file_photo, w_photo, h_photo, true);
            stack.set_visible_child_name ("image");
        }

        private void scale (int w_h_photo, int w_h_screen) {
            double monitor_scale = (double) w_h_screen / (double) w_h_photo;
            w_photo = (int)(w_photo * monitor_scale);
            h_photo = (int)(h_photo* monitor_scale);
        }
    }

}
