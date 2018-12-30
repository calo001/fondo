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

namespace App.Popover {
    public class SharePopover : Gtk.Popover {
        public signal void link_copied ();
    
        public string body { get; set; }
        public string uri { get; set; }
        public string autor { get; set; }
    
        public SharePopover (string autor, string uri) {
            Object (
                autor: autor,
                body: _(@"Photo by $autor on Unsplash"),
                uri: _(@"https://unsplash.com/photos/$uri")
            );
        
            var share_label = new Gtk.Label (_("Share"));
            var autor_label = new Gtk.Label (body);
            autor_label.hexpand = true;
            autor_label.halign = Gtk.Align.START;
            share_label.halign = Gtk.Align.START;
            autor_label.get_style_context ().add_class ("h3");
            share_label.get_style_context ().add_class ("h1");

            var email_button = new Gtk.Button.from_icon_name ("internet-mail", Gtk.IconSize.DND);
            email_button.tooltip_text = _("Email");
            email_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var facebook_button = new Gtk.Button();
            var face_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-facebook.svg");
            facebook_button.set_image (face_logo);
            facebook_button.tooltip_text = _("Facebook");
            facebook_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var google_button = new Gtk.Button();
            var google_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-google-plus.svg");
            google_button.set_image (google_logo);
            google_button.tooltip_text = _("Google+");
            google_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var twitter_button = new Gtk.Button();
            var twitter_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-twitter.svg");
            twitter_button.set_image (twitter_logo);
            twitter_button.tooltip_text = _("Twitter");
            twitter_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var tumblr_button = new Gtk.Button();
            var tumblr_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-tumblr.svg");
            tumblr_button.set_image (tumblr_logo);
            tumblr_button.tooltip_text = _("Tumblr");
            tumblr_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var reddit_button = new Gtk.Button ();
            var reddit_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-reddit.svg");
            reddit_button.set_image (reddit_logo);
            reddit_button.tooltip_text = _("Reddit");
            reddit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

            var telegram_button = new Gtk.Button();
            var telegram_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-telegram.svg");
            telegram_button.set_image (telegram_logo);
            telegram_button.tooltip_text = _("Telegram");
            telegram_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var whatsapp_button = new Gtk.Button();
            var whatsapp_logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/online-account-whatsapp.svg");
            whatsapp_button.set_image (whatsapp_logo);
            whatsapp_button.tooltip_text = _("WhatsApp");
            whatsapp_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var copy_link_button = new Gtk.Button.from_icon_name ("edit-copy-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            copy_link_button.tooltip_text = _("Copy link");
            copy_link_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            var size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
            size_group.add_widget (email_button);
            size_group.add_widget (copy_link_button);
    
            var service_grid = new Gtk.Grid ();
            service_grid.margin = 6;
            service_grid.add (email_button);
            service_grid.add (facebook_button);
            service_grid.add (google_button);
            service_grid.add (twitter_button);
            service_grid.add (reddit_button);
            service_grid.add (tumblr_button);
            service_grid.add (telegram_button);
            service_grid.add (whatsapp_button);

            var system_grid = new Gtk.Grid ();
            system_grid.margin = 8;
            system_grid.margin_start = 16;
            system_grid.attach (share_label, 0,0,1,1);
            system_grid.attach (autor_label, 0,1,1,1);
            system_grid.attach (copy_link_button, 1,0,1,2);
    
            var grid = new Gtk.Grid ();
            grid.orientation = Gtk.Orientation.VERTICAL;
            grid.add (system_grid);
            grid.add (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
            grid.add (service_grid);
            grid.show_all ();
    
            add (grid);
    
            copy_link_button.clicked.connect (() => {
                var clipboard = Gtk.Clipboard.get_for_display (get_display (), Gdk.SELECTION_CLIPBOARD);
                clipboard.set_text (this.uri, -1);
    
                link_copied ();
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
    
            google_button.clicked.connect (() => {
                try {
                    AppInfo.launch_default_for_uri ("https://plus.google.com/share?url=%s".printf (this.uri), null);
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
    }
}