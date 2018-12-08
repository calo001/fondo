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
using App.Configs;

namespace App.Controllers {

    /**
     * The {@code AppController} class.
     *
     * @since 1.0.0
     */
    public class AppController {

        private Gtk.Application            application;
        private App.Widgets.HeaderBar      headerbar;
        private CategoriesView             categories;
        private PhotosView                 view;
        private PhotosView                 result_search_view;
        private AppViewError               view_error;
        private AppConnection              connection;
        private Gtk.ScrolledWindow         scrolled_main;
        private Gtk.ScrolledWindow         scrolled_search;
        private Gtk.Stack                  stack;
        private App.Window                 window { get; private set; default = null; }
        private int                        num_page;
        /**
         * Constructs a new {@code AppController} object.
         */
        public AppController (Gtk.Application application) {
            /************************************************************* 
                    Base instance
            * num page, indicate the number page for API UNSPLASH Endpoint
            ***********************************************************/
            this.application = application;
            this.connection = AppConnection.get_instance();
            this.num_page = 1;

            window = new App.Window (this.application);
            scrolled_main = new Gtk.ScrolledWindow (null, null);
            scrolled_search = new Gtk.ScrolledWindow (null, null);
            
            // View that contains all card with photos
            view = new PhotosView ();
            result_search_view = new PhotosView ();

            // Container for Title and scrolledWindow
            var content_scroll = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            var content_search_scroll = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            var header_photos = new Gtk.Label (_("Today"));
            header_photos.get_style_context ().add_class ("hphoto");
            header_photos.wrap = true;
            header_photos.margin_start = 20;
            header_photos.margin_end = 20;

            content_scroll.add (header_photos);
            content_scroll.add (view);

            content_search_scroll.add (header_photos);
            content_search_scroll.add (result_search_view);

            scrolled_main.add (content_scroll);
            scrolled_search.add (content_search_scroll);

            // Check the internet connection
            check_internet();

            // Categories stack
            categories = new CategoriesView ();

            var content_categories = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            content_categories.add (header_photos);
            content_categories.add (categories);

            // Show when GET request is in progress
            var box_loading = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            box_loading.halign = Gtk.Align.CENTER;
            box_loading.valign = Gtk.Align.CENTER;
            
            var spinner = new Gtk.Spinner();
            spinner.active = true;
            spinner.get_style_context ().add_class ("card");
            spinner.get_style_context ().add_class ("card_spinner");
            box_loading.add(spinner);
            

            // Contains the spinner and scroll and chances theirs visibility
            stack = new Gtk.Stack ();
            stack.set_transition_duration (500);
            
            stack.add_named(box_loading, "spinner");
            stack.add_named(content_categories, "categories");
            stack.add_named(scrolled_main, "scrolled");
            stack.add_named(scrolled_search, "search"); 
            stack.visible_child_name = "spinner";

            window.add (stack);
            application.add_window (window);
        }

        /****************************************** 
        Checking if internet connection is enabled
        ******************************************/
        private void check_internet() {
            if (App.Utils.check_internet_connection ()) {
                set_ui ();
            } else {
                set_error_ui ();
            }
        }

        /****************************************** 
         UI for no internet connection
        ******************************************/
        private void set_error_ui () {
            var header_simple = new Gtk.HeaderBar ();
            header_simple.set_title (Constants.PROGRAME_NAME);
            header_simple.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            window.set_titlebar (header_simple);

            view_error = new AppViewError();
            view_error.close_window.connect(() => {
                window.close();
            }); 

            scrolled_main.add (view_error);
        }

        /****************************************** 
         UI for main content
        ******************************************/
        private void set_ui () {
            headerbar = new App.Widgets.HeaderBar ();
            window.set_titlebar (this.headerbar);

            headerbar.search_view.connect ( () => {
                stack.set_transition_type (Gtk.StackTransitionType.CROSSFADE);
                stack.set_visible_child_name ("categories");
            });

            headerbar.home_view.connect ( () => {
                stack.set_transition_type (Gtk.StackTransitionType.CROSSFADE);
                stack.set_visible_child_name ("scrolled");
            });

            connection.load_page(num_page);

            // Signal catched when request is success and setup the photos 
            connection.request_page_success.connect ( (list) => {
                if (num_page > 1) {
                    view.insert_cards(list);
                } else if (num_page == 1) {
                    view.insert_cards(list);
                    stack.set_visible_child_full ("scrolled", Gtk.StackTransitionType.SLIDE_UP);
                }
            } );

            // signal catched when scroll reaches the edge
            scrolled_main.edge_reached.connect( (pos)=> {
                if (pos == Gtk.PositionType.BOTTOM) {
                    num_page++;
                    connection.load_page(num_page);
                }
            } );
        }

        /*****************
          Show the window
        *****************/
        public void activate () {
            window.show_all ();
        }

        /*****************
        Close the window
        *****************/
        public void quit () {
            window.destroy ();
        }
    }
}
