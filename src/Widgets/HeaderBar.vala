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
using App.Configs;

namespace App.Widgets {

    /**
     * The {@code HeaderBar} class is responsible for displaying top bar. Similar to a horizontal box.
     *
     * @see Gtk.HeaderBar
     * @since 1.0.0
     */
    public class HeaderBar : Gtk.HeaderBar {
        public Gtk.SearchEntry      search {get; set;}
        private Gtk.Button          multiple_menu; 
        public signal void          search_view ();
        public signal void          search_activated (string value);

        /**
         * Constructs a new {@code HeaderBar} object.
         *
         * @see App.Configs.Properties
         * @see icon_settings
         */
        public HeaderBar (MultipleWallpaperView multiple_wallpaper) {
            this.set_title ("Fondo");
            this.show_close_button = true;

            get_style_context ().add_class ("transition");
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            get_style_context ().add_class ("output-header");

            var gtk_settings = Gtk.Settings.get_default ();

            /************************
                Mode Switch widget
            ************************/
            var mode_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
            mode_switch.primary_icon_tooltip_text = S.LIGHT_BACKGROUND;
            mode_switch.secondary_icon_tooltip_text = S.DARK_BACKGROUND;
            mode_switch.valign = Gtk.Align.CENTER;
            mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");

            var context = get_style_context ();
            mode_switch.notify["active"].connect (() => {
                detect_dark_mode (gtk_settings, context);
            });

            App.Application.settings.bind ("use-dark-theme", mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);

            /********************
             * Search Input
             *******************/

            search = new Gtk.SearchEntry();
            search.placeholder_text = S.SEARCH_PHOTOS_UNSPLASH;
            search.margin = 3;
            search.expand = true;
            search.sensitive = false;
            search.get_style_context ().add_class ("entry");
            search.tooltip_markup = Granite.markup_accel_tooltip (
                {"<Ctrl>F"},
                S.SEARCH_TOOLTIP
            );

            // Magic for drag window while search entry is empty
            search.button_press_event.connect ( (event)=>{
                search.grab_focus_without_selecting ();
                if (search.text_length > 0) {
                    return false;
                } else {
                    return true;
                }
            });

            search.button_release_event.connect_after ( ()=>{
                search_view ();
                return true;
            } );

            search.activate.connect (() => {
                unowned string value = search.get_text ();
                if (value.strip ().length > 0) {
                    search_activated (value.strip ());
                    search.sensitive = false;
                }
            });

            /*
             * Menú options button
             */
            var menu_button = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic", Gtk.IconSize.LARGE_TOOLBAR );
            menu_button.valign = Gtk.Align.CENTER;
            menu_button.tooltip_text = S.ABOUT;

            var pop_menu = new MenuPopover (menu_button);
            menu_button.clicked.connect ( ()=> {
                pop_menu.popup ();
            });

            var themed_icon_multiple = new ThemedIcon ("focus-legacy-systray-symbolic.symbolic");
            Gtk.Image multiple_icon = new Gtk.Image () {
                gicon = themed_icon_multiple,
                icon_size = Gtk.IconSize.LARGE_TOOLBAR
            };

            multiple_menu = new Gtk.Button();
            var popup_multiple = new MultipleWallpaperPopover (multiple_menu, multiple_wallpaper);
            multiple_menu.set_image(multiple_icon);
            multiple_menu.set_always_show_image(true);
            multiple_menu.valign = Gtk.Align.CENTER;
            multiple_menu.tooltip_text = S.GALLERY;
            multiple_menu.clicked.connect ( ()=> {
               popup_multiple.popup ();
            });


            this.set_custom_title (search);
            this.pack_end (menu_button);
            this.pack_end (mode_switch);
            this.pack_end (multiple_menu);
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
