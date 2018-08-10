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
        private AppView?                    page_1;
        private AppView?                    page_2;
        private AppView?                    page_3;
        private AppView?                    page_4;
        private AppView?                    page_5;
        private AppConnection              connection;
        private Gtk.Box                    screen;
        private Gtk.ApplicationWindow      window { get; private set; default = null; }
        /**
         * Constructs a new {@code AppController} object.
         */
        public AppController (Gtk.Application application) {
            // Base instances
            this.application = application;
            window = new Window (this.application);

            // Stack, constains 6 cards
            stack = new Gtk.Stack();
            stack.set_transition_duration (500);
            stack.homogeneous = false;
            stack.interpolate_size = true;

            // Screen box, contains stack and link label to unsplash
            screen = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            screen.pack_start (this.stack);

            // Checking if internet connection is enabled
            if (App.Utils.check_internet_connection ()) {
                if (make_connection ()) {
                    set_ui ();
                }
            } else {
                set_error_ui ();
            }

            /* Setup keyboard actions
             *
             * Key code 65: Spacebar/Blanck
             * Key code 113: Arrow key Left
             * Key code 114: Arrow key Right
             * Key code 9: Esc
             *
             */
            this.window.key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                print ("Key" + keycode.to_string());

                    if (keycode == 65 || keycode == 114) {
                        next_stack ();
                    } else if (keycode == 113) {
                        prev_stack ();
                    } else if (keycode == 9) {
                        this.window.close ();
                    }
                return true;
            });

            window.add (this.screen);
            application.add_window (window);
        }

        // UI for no internet connectio
        private void set_error_ui () {
            // Header bar
            var header_simple = new Gtk.HeaderBar ();
            header_simple.set_title ("Fondo");
            header_simple.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            window.set_titlebar (header_simple);

            // Configuring UI
            var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            var image = new Gtk.Image.from_icon_name  ("network-error", Gtk.IconSize.DIALOG);
		    var label_title = new Gtk.Label ("Network Error");
		    var label_description = new Gtk.Label ("Check the network connection.");
            var button_check_network = new Gtk.Button.with_label (_("Exit"));

		    label_title.get_style_context ().add_class ("h2");
		    label_description.get_style_context ().add_class ("h3");
            button_check_network.get_style_context ().add_class ("destructive-action");

            // Button click
            button_check_network.clicked.connect ( () => {
                window.close();
            } );

            // Set margins
            box.margin = 20;

            // Add content
            box.add(image);
            box.add(label_title);
            box.add(label_description);
            box.add(button_check_network);
            stack.add_named (box, "error_page");
            stack.set_visible_child_name ("error_page");
        }

        // Main UI
        private void set_ui () {
            // Headerbar setup
            headerbar = new App.Widgets.HeaderBar ();
            headerbar.randomize_button.clicked.connect (() => next_stack () );
            window.set_titlebar (this.headerbar);

            // Create pages
            page_1 = new AppView (connection.get_thumbs_page(0, 6));
            page_2 = new AppView (connection.get_thumbs_page(6, 12));
            page_3 = new AppView (connection.get_thumbs_page(12, 18));
            page_4 = new AppView (connection.get_thumbs_page(18, 24));
            page_5 = new AppView (connection.get_thumbs_page(24, 30));

            // Stack
            stack.add_named (page_1, "page_1");
            stack.add_named (page_2, "page_2");
            stack.add_named (page_3, "page_3");
            stack.add_named (page_4, "page_4");
            stack.add_named (page_5, "page_5");

            stack.set_visible_child_name ("page_1");

            //Create label unsplash
            var unsplash_link = "https://unsplash.com/?utm_source=Foto&utm_medium=referral";
            var unsplash_text = _("Photos from Unsplash");
            var link_unsplash = new Gtk.LinkButton.with_label(unsplash_link, unsplash_text);
            link_unsplash.margin_bottom = 20;
            link_unsplash.margin_top = 5;
            link_unsplash.halign = Gtk.Align.CENTER;
            link_unsplash.get_style_context ().remove_class ("flat");
            link_unsplash.get_style_context ().remove_class ("link");
            link_unsplash.get_style_context ().add_class ("suggested-action");

            link_unsplash.has_tooltip = false;

            // Screen box
            screen.pack_start (link_unsplash);

            print ("Fin de set UI");
        }

        private bool make_connection () {
            connection = new AppConnection ();
            return connection.load_pages ();
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

        // Dectec key pressed
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
        }

        public void quit () {
            window.destroy ();
        }
    }
}
