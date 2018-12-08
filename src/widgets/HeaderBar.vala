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
using App.Views;
using App.Popover;

namespace App.Widgets {

    /**
     * The {@code HeaderBar} class is responsible for displaying top bar. Similar to a horizontal box.
     *
     * @see Gtk.HeaderBar
     * @since 1.0.0
     */
    public class HeaderBar : Gtk.HeaderBar {

        private Gtk.Popover         pop_search;
        private Gtk.SearchEntry     search;
        private Gtk.Revealer        revealer;
        public signal void search_view ();
        public signal void home_view ();

        /**
         * Constructs a new {@code HeaderBar} object.
         *
         * @see App.Configs.Properties
         * @see icon_settings
         */
        public HeaderBar () {
            this.set_title ("Fondo");
            this.show_close_button = true;

            get_style_context ().add_class ("transition");
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            get_style_context ().add_class ("output-header");

            var gtk_settings = Gtk.Settings.get_default ();

            /************************
                Mode Switch widget
            ************************/
            var mode_switch = new ModeSwitch (
                "display-brightness-symbolic",
                "weather-clear-night-symbolic"
            );

            mode_switch.margin_end = 6;
            mode_switch.primary_icon_tooltip_text = _("Light background");
            mode_switch.secondary_icon_tooltip_text = _("Dark background");
            mode_switch.valign = Gtk.Align.CENTER;
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");

            var context = get_style_context ();
            mode_switch.notify["active"].connect (() => {
                detect_dark_mode (gtk_settings, context);
            });

            App.Application.settings.bind ("use-dark-theme", mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);
            
            /*******************
             * Unsplash button 
            *******************/
            var img = new Gtk.Image.from_icon_name ("camera-photo-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            var unsplash_link = "https://unsplash.com/?utm_source=Fondo&utm_medium=referral";
            var unsplash_text = "Unsplash";
            var link_unsplash = new Gtk.LinkButton.with_label(unsplash_link, unsplash_text);
            link_unsplash.get_style_context ().remove_class ("link");
            link_unsplash.get_style_context ().remove_class ("button");
            link_unsplash.get_style_context ().add_class ("flat");
            link_unsplash.get_style_context ().add_class ("unsplash_btn");
            link_unsplash.tooltip_text = _("Photos from Unsplash: Beautiful Free Images & Pictures 🎁");
            link_unsplash.set_image (img);
            link_unsplash.set_always_show_image (true);

            /********************
             * Search Input
             *******************/

            search = new Gtk.SearchEntry();
            search.placeholder_text = _("Search photos Unsplash");
            search.margin = 5;
            search.expand = true;

            search.button_press_event.connect ( ()=>{
                revealer.set_reveal_child (true);
                search_view ();
                return false;
            } );

            /*
             * Menú options button
             */
            var menu_button = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic", Gtk.IconSize.LARGE_TOOLBAR );
            menu_button.tooltip_text = _("Options");

            var pop_content_menu = new MenuPopover();
            var pop_menu = new Gtk.Popover(menu_button);
            pop_menu.get_style_context ().add_class ("pop-menu");
            pop_menu.add(pop_content_menu);
            pop_menu.set_modal (true);

            menu_button.clicked.connect ( ()=> {
                pop_menu.popup ();
            });

            /*
             * daly home
             */
            revealer = new Gtk.Revealer ();
            var daily_button = new Gtk.Button.from_icon_name ("go-home-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            daily_button.tooltip_text = _("Back to daily photos");
            revealer.add (daily_button);
            revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_LEFT;
            daily_button.clicked.connect ( ()=>{
                revealer.set_reveal_child (false);
                home_view ();
            } );

            this.pack_start(revealer);
            this.set_custom_title (search);
            this.pack_end (menu_button);
            this.pack_end (mode_switch);
        }

        /************************ 
         * Toogle the dark mode
        ************************/
        public void detect_dark_mode (Gtk.Settings gtk_settings, Gtk.StyleContext context) {
            if (gtk_settings.gtk_application_prefer_dark_theme) {
                App.Configs.Settings.get_instance ().use_dark_theme = true;
                context.add_class ("dark");
            } else {
                App.Configs.Settings.get_instance ().use_dark_theme = false;
                context.remove_class ("dark");
            }
        }
    }
}
