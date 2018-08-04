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

using App.Widgets;
using App.Views;
using App.Connection;

namespace App.Controllers {

    /**
     * The {@code AppController} class.
     *
     * @since 1.0.0
     */
    public class AppController {

        private Gtk.Application            application;
        private App.Widgets.HeaderBar      headerbar;
        private Gtk.Stack                  stack;
        private AppView                    page_1;
        private AppView                    page_2;
        private AppView                    page_3;
        private AppView                    page_4;
        private AppView                    page_5;
        private AppConnection              connection;
        private Gtk.Box                    screen;
        private Gtk.ApplicationWindow      window { get; private set; default = null; }
        /**
         * Constructs a new {@code AppController} object.
         */
        public AppController (Gtk.Application application) {
            // Base instances
            this.application = application;
            this.window = new Window (this.application);

            // Load data from unsplash
            this.connection = new AppConnection ();
            this.connection.load_pages ();

            // Create pages
            this.page_1 = new AppView (connection.get_thumbs_page(0, 6));
            this.page_2 = new AppView (connection.get_thumbs_page(6, 12));
            this.page_3 = new AppView (connection.get_thumbs_page(12, 18));
            this.page_4 = new AppView (connection.get_thumbs_page(18, 24));
            this.page_5 = new AppView (connection.get_thumbs_page(24, 30));

            // Stack
            this.stack = new Gtk.Stack();
            this.stack.set_transition_duration (500);
            this.stack.add_named (page_1, "page_1");
            this.stack.add_named (page_2, "page_2");
            this.stack.add_named (page_3, "page_3");
            this.stack.add_named (page_4, "page_4");
            this.stack.add_named (page_5, "page_5");
            this.stack.set_visible_child_name ("page_1");

            //Create label unsplash
            var unsplash_link = "https://unsplash.com/?utm_source=Foto&utm_medium=referral";
            var unsplash_text = "Photos from Unsplash";
            var link_unsplash = new Gtk.LinkButton.with_label(unsplash_link, unsplash_text);
            link_unsplash.margin_bottom = 10;
            link_unsplash.get_style_context ().add_class ("link");
            link_unsplash.get_style_context ().remove_class ("button");
            link_unsplash.get_style_context ().remove_class ("flat");
            link_unsplash.get_style_context ().add_class ("h4");
            link_unsplash.has_tooltip = false;

            // Screen box
            this.screen = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            this.screen.pack_start (this.stack);
            this.screen.pack_start (link_unsplash);

            // Headerbar setup
            this.headerbar = new App.Widgets.HeaderBar ();
            this.headerbar.randomize_button.clicked.connect (() => next_stack () );

            // Keyboard actions
            this.window.key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                print ("Key" + keycode.to_string());
                    if (keycode == 65 || keycode == 114) {
                        next_stack ();
                    } else if (keycode == 113) {
                        prev_stack ();
                    } else if (keycode == 10) {
                        set_wallpaper_by_number (1, this.stack.visible_child_name);
                    } else if (keycode == 11) {
                        set_wallpaper_by_number (2, this.stack.visible_child_name);
                    } else if (keycode == 12) {
                        set_wallpaper_by_number (3, this.stack.visible_child_name);
                    } else if (keycode == 13) {
                        set_wallpaper_by_number (4, this.stack.visible_child_name);
                    } else if (keycode == 14) {
                        set_wallpaper_by_number (5, this.stack.visible_child_name);
                    } else if (keycode == 15) {
                        set_wallpaper_by_number (6, this.stack.visible_child_name);
                    } else if (keycode == 9) {
                        this.window.close ();
                    }
                return true;
            });

            this.window.add (this.screen);
            this.window.set_titlebar (this.headerbar);
            this.application.add_window (window);
        }

        protected void set_wallpaper_by_number (int num_card, string page) {
            if (page == "page_1") {
                page_1.use_card_for_wallpaper (num_card);
            } else if (page == "page_2") {
                page_2.use_card_for_wallpaper (num_card);
            } else if (page == "page_3") {
                page_3.use_card_for_wallpaper (num_card);
            } else if (page == "page_4") {
                page_4.use_card_for_wallpaper (num_card);
            } else if (page == "page_5") {
                page_5.use_card_for_wallpaper (num_card);
            }
        }

        protected bool match_keycode (int keyval, uint code) {
            Gdk.KeymapKey [] keys;
            Gdk.Keymap keymap = Gdk.Keymap.get_for_display (Gdk.Display.get_default ());
            if (keymap.get_entries_for_keyval (keyval, out keys)) {
                foreach (var key in keys) {
                    if (code == key.keycode)
                        return true;
                    }
                }
            return false;
        }

        public void next_stack () {
            this.stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT);
            if (this.stack.visible_child_name == "page_1") {
                this.stack.visible_child_name = "page_2";
            } else if (this.stack.visible_child_name == "page_2") {
                this.stack.visible_child_name = "page_3";
            } else if (this.stack.visible_child_name == "page_3") {
                this.stack.visible_child_name = "page_4";
            } else if (this.stack.visible_child_name == "page_4") {
                this.stack.visible_child_name = "page_5";
            } else if (this.stack.visible_child_name == "page_5") {
                this.stack.visible_child_name = "page_1";
            }
        }

        public void prev_stack () {
            this.stack.set_transition_type (Gtk.StackTransitionType.SLIDE_RIGHT);
            if (this.stack.visible_child_name == "page_1") {
                this.stack.visible_child_name = "page_5";
            } else if (this.stack.visible_child_name == "page_2") {
                this.stack.visible_child_name = "page_1";
            } else if (this.stack.visible_child_name == "page_3") {
                this.stack.visible_child_name = "page_2";
            } else if (this.stack.visible_child_name == "page_4") {
                this.stack.visible_child_name = "page_3";
            } else if (this.stack.visible_child_name == "page_5") {
                this.stack.visible_child_name = "page_4";
            }
        }

        public void activate () {
            window.show_all ();
            //app_view.activate ();
        }

        public void quit () {
            window.destroy ();
        }
    }
}
