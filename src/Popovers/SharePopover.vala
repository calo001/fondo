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

using App.Connection;
using App.Configs;
using App.Widgets;
using App.Models;
using App.Utils;

namespace App.Popover {
    public class SharePopover : Gtk.Popover {  
        private DownloadContainerWidget                     download_container;
        private Gtk.Button                                  open_file_btn;
        private Gtk.Stack                                   stack;
        private Photo                                       photo;
        private string                                      local_file_path;
        public string body { get; set; }
        public string uri { get; set; }
        public string autor { get; set; }
        private const string STACK_BUTTON =                 "open_button";
        private const string STACK_DOWNLADING =             "downloading";
    
        public SharePopover (Photo photo, Gtk.Widget relative_to) {
            Object (
                autor: photo.user.name,
                body: S.PHOTO_BY + photo.user.name + S.ON_UNSPLASH,
                uri: @"https://unsplash.com/photos/$(photo.id)",
                relative_to: relative_to,
                position: Gtk.PositionType.BOTTOM,
                modal: true
            );

            this.photo = photo;

            var share_label = new Gtk.Label (S.SHARE) {
                expand = true,
                halign = Gtk.Align.START
            };
            var autor_label = new Gtk.Label (body) {
                hexpand = true,
                halign = Gtk.Align.START,
                selectable = true,
                halign = Gtk.Align.START
            };
            autor_label.get_style_context ().add_class ("h3");
            share_label.get_style_context ().add_class ("h1");

            var email_button = new Gtk.Button.from_icon_name ("internet-mail", Gtk.IconSize.DND);
            email_button.tooltip_text = S.EMAIL;
            email_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var facebook_button = new Gtk.Button.from_icon_name ("online-account-facebook", Gtk.IconSize.DND);
            facebook_button.tooltip_text = "Facebook";
            facebook_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var twitter_button = new Gtk.Button.from_icon_name ("online-account-twitter", Gtk.IconSize.DND);
            twitter_button.tooltip_text = "Twitter";
            twitter_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var tumblr_button = new Gtk.Button.from_icon_name ("online-account-tumblr", Gtk.IconSize.DND);
            tumblr_button.tooltip_text = "Tumblr";
            tumblr_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var reddit_button = new Gtk.Button.from_icon_name ("online-account-reddit", Gtk.IconSize.DND);
            reddit_button.tooltip_text = "Reddit";
            reddit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            var telegram_button = new Gtk.Button.from_icon_name ("online-account-telegram", Gtk.IconSize.DND);
            telegram_button.tooltip_text = "Telegram";
            telegram_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var whatsapp_button = new Gtk.Button.from_icon_name ("online-account-whatsapp", Gtk.IconSize.DND);
            whatsapp_button.tooltip_text = "WhatsApp";
            whatsapp_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var copy_link_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            copy_link_button.tooltip_text = S.COPY_LINK;
            copy_link_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            var download_button = new Gtk.Button.from_icon_name ("browser-download-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            download_button.tooltip_text = S.DOWNLOAD;
            download_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var service_grid = new Gtk.Grid ();
            service_grid.margin = 6;
            service_grid.add (email_button);
            service_grid.add (facebook_button);
            service_grid.add (twitter_button);
            service_grid.add (reddit_button);
            service_grid.add (tumblr_button);
            service_grid.add (telegram_button);
            service_grid.add (whatsapp_button);

            download_container = new DownloadContainerWidget (S.DOWNLOADING) {
                margin_start = 12,
                margin_end = 12,
                margin_bottom = 12
            };

            open_file_btn = new Gtk.Button.with_label (S.OPEN_FOLDER) {
                expand = true,
                margin = 16
            };

            open_file_btn.clicked.connect ( () => {
                GLib.message ("file://" + local_file_path);
                App.Utils.show_file_in_filemanager.begin("file://" + local_file_path);
                hide ();
            });

            open_file_btn.get_style_context ().add_class ("action_suggest_btn");
            open_file_btn.get_style_context ().add_class ("text-button");

            stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
                no_show_all = true,
                homogeneous = false
            };

            stack.add_named (download_container,    STACK_DOWNLADING);
            stack.add_named (open_file_btn,             STACK_BUTTON);

            var system_grid = new Gtk.Grid ();
            system_grid.margin = 8;
            system_grid.margin_start = 16;
            system_grid.attach (share_label,        0,0,1,1);
            system_grid.attach (autor_label,        0,1,3,1);
            system_grid.attach (copy_link_button,   1,0,1,1);
            system_grid.attach (download_button,    2,0,1,1);
    
            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.add (system_grid);
            grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            grid.add (service_grid);
            grid.add (stack);
            grid.show_all ();
            copy_link_button.grab_focus ();
    
            add (grid);

            download_button.clicked.connect (show_dialog);
    
            copy_link_button.clicked.connect (() => {
                copy_to_clipboard ();
                show_clipboard_notification (this.uri);
                hide ();
            });
    
            email_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("mailto:?body=%s %s".printf (this.body, this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });
    
            facebook_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("https://www.facebook.com/sharer/sharer.php?u=%s".printf (this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });
    
            twitter_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("http://twitter.com/home/?status=%s %s".printf (this.body, this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });

            reddit_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("http://www.reddit.com/submit?title=%s&url=%s".printf (this.body, this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });
    
            tumblr_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("https://www.tumblr.com/share/link?url=%s".printf (this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });
    
            telegram_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("https://t.me/share/url?url=%s".printf (this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });

            whatsapp_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("https://web.whatsapp.com/send?text=%s".printf (this.uri), null);
                } catch (Error e) {
                    warning ("%s", e.message);
                }
                hide ();
            });
        }

        public void show_dialog () {
            var filter = new Gtk.FileFilter();
            filter.set_filter_name (S.JPEG_IMAGE_FILTER);
            filter.add_pattern ("*.jpg");
            filter.add_pattern ("*.jpeg");
            
            var dialog = new Gtk.FileChooserNative (S.SAVE_PHOTO, null, Gtk.FileChooserAction.SAVE, S.SAVE_BUTTON, S.CANCEL_BUTTON);
            dialog.add_filter (filter);
            dialog.set_current_name(photo.file_name);
            dialog.set_do_overwrite_confirmation (true);

            if (dialog.run() == Gtk.ResponseType.ACCEPT) {
                var file_path = dialog.get_filename();
                save_file (file_path);
            }
        }

        private void save_file (string file_path) {
            AppConnection connection = AppConnection.get_instance();
            string? url_photo = connection.get_url_photo (photo.links.download_location);
            Wallpaper wallpaper = new Wallpaper (url_photo, photo.id, photo.user.name);
            wallpaper.on_progress.connect ((progress) => {
                show_progress (progress);
            });

            wallpaper.finish_download.connect (() => {
                show_open_file_browser (file_path);
            });        

            wallpaper.download_picture (file_path, true);
        }

        private void show_progress (double progress) {
            download_container.show_all ();
            open_file_btn.show_all ();
            stack.set_visible (true);
            stack.set_visible_child_name (STACK_DOWNLADING);
            download_container.set_progress (progress);
        }

        private void show_open_file_browser (string file_path) {
            stack.set_visible_child_name (STACK_BUTTON);
            local_file_path = file_path;
        }

        private void copy_to_clipboard () {
            var clipboard = Gtk.Clipboard.get_for_display (get_display (), Gdk.SELECTION_CLIPBOARD);
            clipboard.set_text (this.uri, -1);
        }

        private void show_clipboard_notification(string url) {
            var notification = new Notification (S.CLIPBOARD_TITLE_NOTIFICATION);
            notification.set_body (S.CLIPBOARD_MSG_NOTIFICATION.printf (url));
            var icon = new ThemedIcon ("com.github.calo001.fondo.success");
            notification.set_icon (icon);
            GLib.Application.get_default ().send_notification ("notify.app", notification);
        }
    }
}
