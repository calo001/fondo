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
using App.Windows;

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
        private EmptyView                  empty_view;
        private LoadingView                box_loading;
        private FilteringView              filtering_view;
        private AppViewError               view_error;
        private AppConnection              connection;
        private Gtk.ScrolledWindow         scrolled_main;
        private Gtk.ScrolledWindow         scrolled_search;
        private Gtk.Stack                  stack;
        private Gtk.Box                    box_stack;
        private ButtonNavbar               buttonNavbar;
        private Window                     window { get; private set; default = null; }
        private Gtk.Label                  search_label;

        private int                        num_page;
        private int                        num_page_search;
        private string                     current_query;

        private const string STACK_CATEGORIES = "categories";
        private const string STACK_LOADING = "spinner";
        private const string STACK_FILTERING = "filtering";
        private const string STACK_DAILY = "daily";
        private const string STACK_SEARCH = "search";
        private const string STACK_EMPTY = "empty";
        private const string STACK_ERROR = "error"; 
        
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
            this.num_page_search = 1;

            // window setup
            window  =       new Window (this.application);
            headerbar =     new App.Widgets.HeaderBar ();
            window.set_titlebar (this.headerbar);

            // Stack for views
            stack = new Gtk.Stack ();
            stack.set_transition_duration (350);
            stack.hhomogeneous = false;
            stack.interpolate_size = true;

            // Views used in Stock
            scrolled_main =         new Gtk.ScrolledWindow (null, null);
            scrolled_search =       new Gtk.ScrolledWindow (null, null);
            box_loading =           new LoadingView ();
            filtering_view =        new FilteringView ();
            categories =            new CategoriesView ();
            empty_view =            new EmptyView ();         
            view =                  new PhotosView ();
            result_search_view =    new PhotosView ();
            view_error =            new AppViewError();

            view.applying_filter.connect ( () => {
                var current_view = stack.get_visible_child_name ();
                stack.get_visible_child ().sensitive = false;
                if (current_view == STACK_DAILY || current_view == STACK_SEARCH ) {
                    applying_filter (current_view);
                }
            });

            // Daily photos container
            var content_scroll =        new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            var header_photos =         new LabelTop (S.TODAY);
            content_scroll.add (header_photos);
            content_scroll.add (view);

            // Search photos container
            var content_search_scroll = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            search_label = new LabelTop (S.SEARCH_PHOTOS_UNSPLASH);
            content_search_scroll.add (search_label);
            content_search_scroll.add (result_search_view);

            scrolled_main.add (content_scroll);
            scrolled_search.add (content_search_scroll);

            // Categories
            var content_categories = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            var header_categories =  new LabelTop (S.CATEGORIES);
            content_categories.add (header_categories);
            content_categories.add (categories);

            // Setup signals
            categories.search_category.connect ( ( search )=>{
                search_query (search);
            });

            headerbar.search_activated.connect ( ( search )=>{
                search_query (search);
                buttonNavbar.clean_all ();
            });

            view_error.retry.connect(() => {
                check_internet();
            }); 
            
            stack.add_named(box_loading,        STACK_LOADING);
            stack.add_named(filtering_view,     STACK_FILTERING);
            stack.add_named(content_categories, STACK_CATEGORIES);
            stack.add_named(scrolled_main,      STACK_DAILY);
            stack.add_named(scrolled_search,    STACK_SEARCH); 
            stack.add_named(empty_view,         STACK_EMPTY); 
            stack.add_named(view_error,         STACK_ERROR);

            // Navigationbar
            buttonNavbar = new ButtonNavbar ();
            buttonNavbar.valign = Gtk.Align.END;
            buttonNavbar.halign = Gtk.Align.FILL;
            buttonNavbar.hexpand = true;

            buttonNavbar.daily.connect ( () => {
                stack.set_visible_child_full (STACK_DAILY, Gtk.StackTransitionType.SLIDE_UP);
                view.set_sensitive (true);
            });

            buttonNavbar.categories.connect ( () => {
                stack.set_visible_child_full (STACK_CATEGORIES, Gtk.StackTransitionType.SLIDE_UP);
                view.set_sensitive (false);
            });

            buttonNavbar.history.connect ( () => {
                view.set_sensitive (false);
            });

            // Window Overlay
            box_stack = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box_stack.add (stack);
            box_stack.add (buttonNavbar);
            window.add (box_stack);
            application.add_window (window);

            check_internet();
        }

        private void applying_filter (string stack_back) {
            stack.set_visible_child_full (STACK_LOADING, Gtk.StackTransitionType.NONE);
            MainLoop loop = new MainLoop ();
            TimeoutSource time = new TimeoutSource (1000);
            time.set_callback (() => {
                stack.set_visible_child_full (stack_back, Gtk.StackTransitionType.CROSSFADE);
                stack.get_visible_child ().sensitive = true;
                return true;
            });
            time.attach (loop.get_context ());
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
            stack.show.connect ( ()=>{
                stack.set_visible_child_full (STACK_ERROR, Gtk.StackTransitionType.SLIDE_UP);
            });
        }

        /****************************************** 
         UI for main content
        ******************************************/
        private void set_ui () {
            stack.set_visible_child_full (STACK_LOADING, Gtk.StackTransitionType.SLIDE_UP);
            connection.load_page(num_page);

            // Signal catched when request is success and setup the photos 
            connection.request_page_success.connect ( (list) => {
                if (num_page > 1) {
                    view.insert_cards(list);
                } else if (num_page == 1) {
                    headerbar.search.sensitive = true;
                    view.insert_cards(list);
                    stack.set_visible_child_full (STACK_DAILY, Gtk.StackTransitionType.SLIDE_UP);
                }
            } );

            // Signal catched when a search request is success and setup the photos 
            connection.request_page_search_success.connect ( (list) => {
                headerbar.search.sensitive = true;
                if (list.length () > 0) {
                    result_search_view.insert_cards(list);
                    stack.set_visible_child_full (STACK_SEARCH, Gtk.StackTransitionType.SLIDE_UP);
                } else if (num_page_search == 1) {
                    stack.set_visible_child_full (STACK_EMPTY, Gtk.StackTransitionType.SLIDE_UP);
                }
            } );

            // signal catched when scroll reaches the edge
            scrolled_main.edge_reached.connect( (pos)=> {
                if (pos == Gtk.PositionType.BOTTOM) {
                    num_page++;
                    connection.load_page(num_page);
                }
            } );

            // signal catched when scroll reaches the edge
            scrolled_search.edge_reached.connect( (pos)=> {
                if (pos == Gtk.PositionType.BOTTOM) {
                    num_page_search++;
                    connection.load_search_page(num_page_search, current_query);
                }
            } );
        }

        private void search_query (string search) {
            num_page_search = 1;
            current_query = search;
            result_search_view.clean_list ();
            connection.load_search_page(num_page_search, search);
            update_iu_for_search (search);
        }

        private void update_iu_for_search (string search) {
            headerbar.search.sensitive = false;
            scrolled_search.get_vadjustment ().set_value (0);
            stack.set_visible_child_full (STACK_LOADING, Gtk.StackTransitionType.SLIDE_DOWN);
            search_label.label = search;
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
