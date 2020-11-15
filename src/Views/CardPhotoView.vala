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
using App.Enums;
using App.Delegate;
using Gtk;

namespace App.Views {

    /**
     * The {@code CardPhotoView} class.
     *
     * @since 1.0.0
     */

    public class CardPhotoView : Gtk.Box {

        public signal void set_as_wallpaper(string opt = "zoom");
        public signal void toggled_multiple(bool multiple);

        private File                    file_photo;
        private Granite.AsyncImage      image;
        private Button                  btn_view;
        private Button                  btn_share;
        private Button                  btn_delete;
        private ToggleButton            btn_select;
        private Button                  photo_button;
        private LinkButton              label_autor;
        private Label                   label_dimensions;
        private Wallpaper               wallpaper;
        private AppConnection           connection;
        private ProgressBar             bar;
        private Revealer                revealer;
        private Overlay                 overlay;
        private Photo                   photo;
        private TypeCard                type_card;
        public  WallpaperPopover        popup;
        public  SharePopover            popupShare;

        private int                     w_photo;
        private int                     h_photo;
        public bool                     is_for_greeter {get; set;}

        /***********************************
                    Constructor
        ************************************/
        public CardPhotoView (Photo photo, TypeCard type_card = NORMAL) {
            this.connection = AppConnection.get_instance();
            this.photo = photo;
            this.type_card = type_card;
            this.can_focus = false;
            this.orientation = Gtk.Orientation.VERTICAL;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.START;
            this.margin_start = 8;
            this.margin_end = 8;
            this.margin_top = 12;
            this.margin_bottom = 12;

            this.get_style_context(). add_class ("start_anim");

            /******************************************
                    File from url thumb
            ******************************************/
            file_photo = File.new_for_uri (photo.urls.small);

            /******************************************
                    Create AsyncImage object
            ******************************************/
            image = new Granite.AsyncImage(true, true);
            image.get_style_context ().add_class ("backimg");
            image.get_style_context ().add_class ("gradient_back");
            image.get_style_context ().add_class ("transition");
            image.has_tooltip = true;
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

            image.set_from_file_async.begin(file_photo, w_photo, h_photo, false, null, (res) => {
                image.get_style_context ().remove_class ("gradient_back");
            });

            var txt_tooltip = (photo.user.location != null) ? @"🌎  $(photo.user.location)" : S.AN_AMAZING_PLACE;;
            image.set_tooltip_text (txt_tooltip);

            /******************************************
                    Create Popover for options
            ******************************************/
            popup = new WallpaperPopover(this);
            // Detect signal from click on an option from popup
            popup.wallpaper_option.connect((opt) => {
                popup.set_visible (false);
                setup_wallpaper(opt);
            });

            /******************************************
                        Image dimensions
            ******************************************/
            var text_dimensions = @"$(photo.width.to_string ()) x $(photo.height.to_string ())  px";
            label_dimensions = new Gtk.Label(text_dimensions);
            label_dimensions.get_style_context ().add_class ("label_dimens");
            label_dimensions.margin = 8;
            label_dimensions.halign = Gtk.Align.END;
            label_dimensions.valign = Gtk.Align.END;
            
            setup_fullscreen_btn ();
            setup_share_btn ();
            setup_delete_btn ();
            setup_select_btn ();

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
            
            btn_delete.button_release_event.connect (() => {
                this.set_sensitive (false);
                var dialog_delete = new Granite.MessageDialog.with_image_from_icon_name (
                    S.DELETE_PHOTO_DIALOG_TITLE,
                    S.DELETE_PHOTO_DIALOG_MESSAGE,
                    "edit-delete",
                    Gtk.ButtonsType.NONE
                );

                dialog_delete.add_buttons ("Cancel", Gtk.ButtonsType.CANCEL, "Ok", Gtk.ButtonsType.OK);
                
                dialog_delete.close.connect (() => {
                    this.set_sensitive (true);
                });

                dialog_delete.response.connect ((dialog, response) => {
                    switch (response) {
                        case Gtk.ButtonsType.CANCEL:
                            this.set_sensitive (true);
                            dialog_delete.destroy ();
                            break;
                        case Gtk.ButtonsType.OK:
                            JsonManager jsonManager = new JsonManager ();
                            bool result = jsonManager.delete_photo_by_id (photo.id);

                            if (result) {
                                delete_parent_flow ();
                                delete_photo_file (photo);
                            }

                            this.set_sensitive (true);
                            dialog_delete.destroy ();
                            break;
                    }
                });
                dialog_delete.run ();
                return true;
            });

            /********************************************************
                    Create Overlay (contain img, btnFullScreen)
            ********************************************************/
            overlay = new Gtk.Overlay();
            overlay.can_focus = false;
            overlay.halign = Gtk.Align.CENTER;

            overlay.add_overlay (btn_view);
            overlay.add_overlay (btn_share);
            overlay.add_overlay (btn_delete);
            overlay.add_overlay (btn_select);
            overlay.add_overlay (label_dimensions);
            overlay.add (image);
            overlay.width_request = w_photo;
            overlay.height_request = h_photo;

            /********************************************************
                    Button to use hover effect
            ********************************************************/
            photo_button = new Button();
            photo_button.get_style_context ().add_class ("transition");
            photo_button.get_style_context ().add_class ("photo");
            photo_button.add(overlay);
            photo_button.can_focus = false;

            photo_button.button_release_event.connect ( (event) => {
                if (event.type == Gdk.EventType.BUTTON_RELEASE && event.button == 3) {
                    popup.set_visible (true);
                } else {
                    setup_wallpaper ();
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

            /*****************************************
                        Multiple Selection
            *****************************************/
            btn_select.button_release_event.connect (() => {
                toggle_btn_select();
                return true;
            });
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
            revealer.set_reveal_child (true);
            start_global_progress ();
            this.set_sensitive (false);

            string? url_photo = connection.get_url_photo(photo.links.download_location);
            wallpaper = new Wallpaper (url_photo, photo.id, photo.user.name);
            
            wallpaper.on_progress.connect ((p) => {
                update_global_progress (p, wallpaper);
            });
            
            wallpaper.finish_download.connect (() => {
                stop_global_progress ();
                this.set_sensitive (true);
                save_to_history ();
            });
            wallpaper.update_wallpaper (opt);
        }

        public void save_to_history () {
            JsonManager jsonManager = new JsonManager ();
            var history = jsonManager.add_photo (photo);
            jsonManager.save_history (history);
        }

        /*
         * Set progress for bar widget and Granite service
         */
        private void update_global_progress (double progress, Wallpaper wallpaper) {
            bar.set_fraction (progress);
            update_dock_progress (progress);
        }

        private void stop_global_progress () {
            App.Dock.stop ();
        }

        private void start_global_progress () {
            App.Dock.start ();
        }

        private void update_dock_progress (double progress) {
            App.Dock.update_dock_progress (progress);
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

        /*************************************************
        Delete parent view
        **************************************************/
        public void delete_parent_flow () {
            Gtk.Widget widget_parent = this.get_parent ();
            Gtk.StyleContext style = widget_parent.get_style_context ();
            style.changed.connect (() => {
                var state = style.get_state ();
                var opacity = style.get_property ("opacity", state);
                if (opacity.get_double () <= 0.0) {
                    widget_parent.destroy ();
                }
            });
            style.add_class ("deleted");
        }

        private void delete_photo_file (Photo photo) {
            FileManager file_manager = new FileManager();
            file_manager.delete_photo (photo);
        }


        public void activate_selection_btn(bool multiple) {
            btn_select.set_visible(multiple);
        }

        /******************************************
                        Delete button
            ******************************************/
        private void setup_delete_btn () {
            if (type_card == TypeCard.HISTORY) {
                btn_delete = new Gtk.Button.from_icon_name ("edit-delete-symbolic");
                btn_delete.get_style_context ().add_class ("button-action");
                btn_delete.get_style_context ().remove_class ("button");
                btn_delete.get_style_context ().add_class ("transition");
                btn_delete.can_focus = false;
                btn_delete.margin = 8;
                btn_delete.margin_top = 76;
                btn_delete.halign = Gtk.Align.END;
                btn_delete.valign = Gtk.Align.START;
                btn_delete.can_default = true;
            }
        }

        /******************************************
                        Share button
        ******************************************/
        private void setup_share_btn () {
            btn_share = new Gtk.Button.from_icon_name ("mail-send-symbolic");
            btn_share.get_style_context ().add_class ("button-action");
            btn_share.get_style_context ().remove_class ("button");
            btn_share.get_style_context ().add_class ("transition");
            btn_share.can_focus = false;
            btn_share.margin = 8;
            btn_share.margin_top = 42;
            btn_share.halign = Gtk.Align.END;
            btn_share.valign = Gtk.Align.START;
            btn_share.can_default = true;
        }

        /******************************************
                    Fullscreen button
        ******************************************/
        private void setup_fullscreen_btn () {
            btn_view = new Gtk.Button.from_icon_name ("window-maximize-symbolic");
            btn_view.get_style_context ().add_class ("button-action");
            btn_view.get_style_context ().remove_class ("button");
            btn_view.get_style_context ().add_class ("transition");
            btn_view.can_focus = false;
            btn_view.margin = 8;
            btn_view.halign = Gtk.Align.END;
            btn_view.valign = Gtk.Align.START;
            btn_view.can_default = true;
        }

        //
        //
        private void setup_select_btn () {
            Gtk.Image buttonIcon = new Gtk.Image ();
            buttonIcon.gicon = new ThemedIcon ("view-paged-symbolic");
            btn_select = new Gtk.ToggleButton();
            btn_select.set_image(buttonIcon);
            btn_select.set_always_show_image(true);
            btn_select.get_style_context ().add_class ("button-action");
            btn_select.get_style_context ().remove_class ("button");
            btn_select.get_style_context ().add_class ("transition");
            btn_select.can_focus = false;
            btn_select.margin = 8;
            btn_select.halign = Gtk.Align.START;
            btn_select.valign = Gtk.Align.START;
            btn_select.can_default = true;
            btn_select.set_no_show_all(true);
            btn_select.set_visible(false);
        }

        private void toggle_btn_select () {
            if (btn_select.get_active()) {
                btn_select.get_style_context ().remove_class ("button-clicked");
                set_select(false);
            } else {
                btn_select.get_style_context ().add_class ("button-clicked");
                set_select(true);
            }
            
            toggled_multiple(btn_select.get_active());
        }

        public void set_select (bool selected) {
            btn_select.set_active(selected);
        }

        public Photo get_photo () {
            return this.photo;
        }

        public File get_file_photo () {
            return this.file_photo;
        }

        public bool is_multiple_select () {
            return btn_select.get_visible();
        }

        public string get_string () {
            return this.photo.id;
        }
    }

}
