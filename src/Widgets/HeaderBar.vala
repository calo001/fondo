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
    public class HeaderBar : Hdy.HeaderBar {
        public Gtk.SearchEntry      search {get; set;}
        private Gtk.Button          multiple_menu; 
        public signal void          search_view ();
        public signal void          search_activated (string value);
        public signal void          on_menu_click ();

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

            /********************
             * Search Input
             *******************/

            search = new Gtk.SearchEntry();
            search.placeholder_text = S.SEARCH_PHOTOS_UNSPLASH;
            search.margin = 3;
            search.hexpand = true;
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

            menu_button.clicked.connect ( ()=> {
                on_menu_click ();
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

            this.custom_title = search;
            this.pack_start (multiple_menu);
            this.pack_end (menu_button);
        }
    }
}
