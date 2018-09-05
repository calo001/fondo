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
using App.Widgets;
using Gtk;

namespace App.Views {

    /**
     * The {@code CardPhotoView} class.
     *
     * @since 1.0.0
     */

    public class CardPhotoView : Gtk.Grid {

        private File                    file_photo;
        private Granite.AsyncImage      image;
        private Button                  btn_view;
        private EventBox                eventbox_photo;
        private LinkButton              label_autor;
        //private Wallpaper               wallpaper;
        //private AppConnection           connection;
        private ProgressBar             bar;
        private Revealer                revealer;
        private Overlay                 overlay;
        private Photo                   photo;
        private PopupWallpaper          popup_content;
        private Popover                 popup;
        private Gtk.Box                 grid_actions;
        
        // Construct
        public CardPhotoView (Photo photo) {
            this.photo = photo;
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin_bottom = 10;
            this.margin_top = 10;
            this.margin_start = 10;
            this.margin_end = 10;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.CENTER;

            // Create File Object
            file_photo = File.new_for_uri (photo.urls_thumb);
            
            // Create AsyncImage object
            image = new Granite.AsyncImage(true, true);
            image.set_from_file_async.begin(file_photo, 280, 180, false); // Width, Heigth
            image.has_tooltip = true;
            image.get_style_context ().add_class ("photo");            
            var txt_tooltip = photo.location == null ? _("🌎  An amazing place in the world") : "🌎  " + photo.location;
            image.set_tooltip_text (txt_tooltip);

            // Create and attach popup
            popup = new Popover(this);
            popup.position = Gtk.PositionType.BOTTOM;
            popup.modal = true;
            popup_content = new PopupWallpaper(photo.width, photo.height);
            popup.add(popup_content);

            // Detect signal
            popup_content.wallpaper_option.connect((opt) => {
                popup.set_visible (false);
                //set_as_wallpaper(opt);
            });

            eventbox_photo = new Gtk.EventBox();
            eventbox_photo.button_release_event.connect ((event) => {
                if (event.type == Gdk.EventType.BUTTON_RELEASE && event.button == 3) {
                    print("click derecho");
                    popup.set_visible (true);
                } else {
                    this.set_sensitive (false);  
                    //set_as_wallpaper ();
                }
                return true;
            });
            eventbox_photo.add(image);
    
            // Create Button full screen
            btn_view = new Gtk.Button.from_icon_name ("window-maximize-symbolic");
            btn_view.get_style_context ().add_class ("button-green");
            btn_view.get_style_context ().remove_class ("button");
            btn_view.get_style_context ().add_class ("transition");
            btn_view.can_focus = false;
            btn_view.margin = 8;
            btn_view.halign = Gtk.Align.END;
            btn_view.valign = Gtk.Align.START;

            btn_view.clicked.connect (() => {
                this.set_sensitive (false);
                var prev_win = new PreviewWindow(photo);
                prev_win.closed_preview.connect (() => {
                    this.set_sensitive (true);            
                });
                prev_win.show_all ();
                prev_win.load_content();
		    });

            // setup overlay
            overlay = new Gtk.Overlay();
            
            overlay.add (eventbox_photo);
            overlay.add_overlay (btn_view);            

            overlay.width_request = 280;
            overlay.height_request = 180;

            // Create labelAutor
            var link = @"https://unsplash.com/@$(photo.username)?utm_source=$(Constants.PROGRAME_NAME)&utm_medium=referral";
            label_autor = new Gtk.LinkButton.with_label(link, _("By ") + photo.name);
            label_autor.get_style_context ().remove_class ("button");
            label_autor.get_style_context ().remove_class ("link");
            label_autor.get_style_context ().add_class ("transition");
            label_autor.get_style_context ().add_class ("autor");
            label_autor.get_style_context ().remove_class ("flat");
            label_autor.halign = Gtk.Align.CENTER;
            label_autor.has_tooltip = false;
            label_autor.can_focus = false;

            // Create Horizontal Grid
            grid_actions = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
            grid_actions.margin_top = 5;
            grid_actions.pack_start(label_autor, true, true, 0);

            // ProgressBar
            bar = new Gtk.ProgressBar ();
            bar.margin_top = 10;

            // Reveal
            revealer = new Gtk.Revealer ();
            revealer.add (bar);

            // Add view to custom Grid
            this.add(overlay);            
            this.add(revealer);
            this.add(grid_actions);

            show_all_controls();
        }

        private void show_all_controls() {
            overlay.show();
            eventbox_photo.show();
            btn_view.show();
            label_autor.show();
            image.show();
            revealer.show();
            bar.show();
            grid_actions.show();
        }

        /*  public void set_as_wallpaper (string option = "zoom") {
            revealer.set_reveal_child (true);
            connection = new AppConnection();
            string url_photo = connection.get_url_photo(photo.links_download_location);
            wallpaper = new Wallpaper (url_photo, photo.id, photo.username, bar);
            wallpaper.finish_download.connect (() => {
                this.set_sensitive (true);            
                wallpaper.update_wallpaper (option);
            });
        }  */
    }

}
