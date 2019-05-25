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
using App.Models;
using App.Connection;
using App.Utils;
using App.Widgets;
using App.Popover;
using App.Windows;
using Gtk;

namespace App.Views {

    /**
     * The {@code CardPhotoView} class.
     *
     * @since 1.0.0
     */

    public class CardPhotoView : Gtk.Box {

        public signal void set_as_wallpaper(string opt = "zoom");

        private File                    file_photo;
        private Granite.AsyncImage      image;
        private Button                  btn_view;
        private Button                  btn_share;
        private Button                  photo_button;
        private LinkButton              label_autor;
        private Wallpaper               wallpaper;
        private AppConnection           connection;
        private ProgressBar             bar;
        private Revealer                revealer;
        private Overlay                 overlay;
        private Photo                   photo;
        public  WallpaperPopover        popup;
        public  SharePopover            popupShare;

        private int                     w_photo;
        private int                     h_photo;

        /***********************************
                    Constructor
        ************************************/
        public CardPhotoView (Photo photo) {
            this.connection = AppConnection.get_instance();
            this.photo = photo;
            this.can_focus = false;
            this.orientation = Gtk.Orientation.VERTICAL;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.START;
            this.margin_start = 8;
            this.margin_end = 8;
            this.margin_top = 12;
            this.margin_bottom = 12;
            this.get_style_context ().add_class ("mycard");

            /******************************************
                    File from url thumb
            ******************************************/
            file_photo = File.new_for_uri (photo.urls.small);

            /******************************************
                    Create AsyncImage object
            ******************************************/
            image = new Granite.AsyncImage(true, true);
            image.get_style_context ().add_class ("backimg");
            var w_max = 310;
            var h_max = 430;
            w_photo = (int) photo.width;
            h_photo = (int) photo.height;

            // Resize photo with a max height and width
            if (w_photo > w_max) {
                scale (w_photo, w_max);
                if (h_photo > h_max) {
                    scale (h_photo, h_max);
                }
            }

            image.set_from_file_async.begin(file_photo, w_photo, h_photo, false);
            image.has_tooltip = true;
            var txt_tooltip = (photo.user.location != null) ? @"🌎  $(photo.user.location)" : S.AN_AMAZING_PLACE;;
            image.set_tooltip_text (txt_tooltip);

            /******************************************
                    Create Popover for options
            ******************************************/
            popup = new WallpaperPopover(photo.width, photo.height, this);
            // Detect signal from click on an option from popup
            popup.wallpaper_option.connect((opt) => {
                popup.set_visible (false);
                setup_wallpaper(opt);
            });

            /******************************************
                        Fullscreen button
            ******************************************/
            btn_view = new Gtk.Button.from_icon_name ("window-maximize-symbolic");
            btn_view.get_style_context ().add_class ("button-green");
            btn_view.get_style_context ().remove_class ("button");
            btn_view.get_style_context ().add_class ("transition");
            btn_view.can_focus = false;
            btn_view.margin = 8;
            btn_view.halign = Gtk.Align.END;
            btn_view.valign = Gtk.Align.START;
            btn_view.can_default = true;

            /******************************************
                        Share button
            ******************************************/
            btn_share = new Gtk.Button.from_icon_name ("mail-send-symbolic");
            btn_share.get_style_context ().add_class ("button-green");
            btn_share.get_style_context ().remove_class ("button");
            btn_share.get_style_context ().add_class ("transition");
            btn_share.can_focus = false;
            btn_share.margin = 8;
            btn_share.margin_top = 42;
            btn_share.halign = Gtk.Align.END;
            btn_share.valign = Gtk.Align.START;
            btn_share.can_default = true;

            /******************************************
                    Popover for share
            ******************************************/
            popupShare = new SharePopover (this.photo.user.name, this.photo.id, btn_share);
            btn_share.button_release_event.connect ( () => {
                popupShare.set_visible (true);
                return true;
		    });

            // Click on button to launch Fullscreen window
            btn_view.clicked.connect (() => {
                this.set_sensitive (false);
                var prev_win = new PreviewWindow(photo);
                prev_win.show_all ();
                prev_win.load_content();

                prev_win.set_as_wallpaper.connect (() => {
                    setup_wallpaper ();
                });

                prev_win.closed_preview.connect (() => {
                    this.set_sensitive (true);
                });
		    });

            /********************************************************
                    Create Overlay (contain img, btnFullScreen)
            ********************************************************/
            overlay = new Gtk.Overlay();
            overlay.can_focus = false;
            overlay.halign = Gtk.Align.CENTER;

            overlay.add_overlay (btn_view);
            overlay.add_overlay (btn_share);
            overlay.add (image);
            overlay.width_request = w_photo;
            overlay.height_request = h_photo;

            /********************************************************
                    Button to use hover effect
            ********************************************************/
            photo_button = new Button();
            photo_button.get_style_context ().add_class ("photo");
            photo_button.add(overlay);
            photo_button.can_focus = false;

            photo_button.button_release_event.connect ( (event) => {
                if (event.type == Gdk.EventType.BUTTON_RELEASE && event.button == 3) {
                    popup.set_visible (true);
                } else {
                    setup_wallpaper();
                }
                return true;
            } );

            /******************************************
                        Create Label Autor
            ******************************************/
            label_autor = new Gtk.LinkButton.with_label(photo.autor_link (), photo.user.name);
            label_autor.get_style_context ().add_class ("button");
            label_autor.get_style_context ().remove_class ("link");
            label_autor.get_style_context ().add_class ("transition");
            label_autor.get_style_context ().add_class ("autor");
            label_autor.get_style_context ().add_class ("flat");
            label_autor.margin_top = 8;
            label_autor.halign = Gtk.Align.CENTER;
            label_autor.has_tooltip = false;
            label_autor.can_focus = false;

            /******************************************
                        Progressbar card
            ******************************************/
            bar = new Gtk.ProgressBar ();
            bar.margin_top = 8;
            bar.margin_start = 4;
            bar.margin_end = 4;

            /******************************************
                        Revealer for progress
            ******************************************/
            revealer = new Gtk.Revealer ();
            revealer.add (bar);

            /******************************************
                        Add all views
            ******************************************/
            this.add(photo_button);
            this.add(revealer);
            this.add(label_autor);
        }

        /***********************************
            Scale a size with a max size
        ************************************/
        private void scale (int w_h_photo, int w_h_card) {
            double card_scale = (double) w_h_card / (double) w_h_photo;
            w_photo = (int)(w_photo * card_scale);
            h_photo = (int)(h_photo* card_scale);
        }

        /*************************************************
        Set the wallpaper with option "zoom" by default
        * Get url of image from and set the url to a Wallpaper Object
        * Finish signal is recived and  enabled the View
        * Update the wallpaper
        **************************************************/
        public void setup_wallpaper (string opt = "zoom") {
            this.set_sensitive (false);
            revealer.set_reveal_child (true);

            string? url_photo = connection.get_url_photo(photo.links.download_location);
            wallpaper = new Wallpaper (url_photo, photo.id, photo.user.name, bar);
            wallpaper.finish_download.connect (() => {
                this.set_sensitive (true);
            });
            wallpaper.update_wallpaper (opt);
        }

        /*************************************************
        Detect mode size of photo
        **************************************************/
        public string size () {
            if ( w_photo > h_photo ) {
                return Constants.LANDSCAPE;
            } else if ( w_photo < h_photo ) {
                return Constants.PORTRAIT;
            } else {
                return Constants.LANDSCAPE;   
            }
        }
    }

}
