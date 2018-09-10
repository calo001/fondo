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
        private AppView                    view;
        private AppViewError               view_error;
        private AppConnection              connection;
        private Gtk.ScrolledWindow         scrolled;
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

            // Create Main Window instance
            window = new App.Window (this.application);

            // Scroll for AppView
            scrolled = new Gtk.ScrolledWindow (null, null);
            // default 400 x 260
            scrolled.min_content_width = 380;
            scrolled.min_content_height = 520;
            
            // View that contains all card with photos
            view = new AppView ();
            scrolled.add(view);
            view.show();

            // Check the internet connection
            check_internet();

            // Show when GET request is in progress
            Gtk.Spinner spinner = new Gtk.Spinner ();
            spinner.active = true;
            spinner.halign = Gtk.Align.CENTER;

            // Contains the spinner and scroll and chances theirs visibility
            stack = new Gtk.Stack ();
            stack.add_named(spinner, "spinner");
            stack.add_named(scrolled, "scrolled");
            stack.set_visible_child_name ("spinner"); 
            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_UP);
            stack.set_transition_duration (1000);

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

            scrolled.add (view_error);
        }

        /****************************************** 
         UI for main content
        ******************************************/
        private void set_ui () {
            headerbar = new App.Widgets.HeaderBar ();
            window.set_titlebar (this.headerbar);

            connection.load_page(num_page);

            // Signal catched when request is success and setup the photos 
            connection.request_page_success.connect ( (list) => {
                //print("\nSIGNAL RECIVED LENGHT: "+ list.length().to_string() + "\n" );
                //foreach (var item in list) {
                //    print(item.name + "\n");
                //}

                if (num_page > 1) {
                    view.insert_cards(list);
                } else if (num_page == 1) {
                    view.insert_cards(list);
                    stack.set_visible_child_name ("scrolled");
                }
            } );

            // signal catched when scroll reaches the edge
            scrolled.edge_reached.connect( (pos)=> {
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
