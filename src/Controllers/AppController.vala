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
using App.Utils;
using App.Enums;

namespace App.Controllers {

    /**
     * The {@code AppController} class.
     *
     * @since 1.0.0
     */
    public class AppController {

        private Window                     window { get; private set; default = null; }
        private Gtk.Application            application;
        private App.Widgets.HeaderBar      headerbar;
        private CategoriesView             categories;
        private PhotosView                 view;
        private PhotosView                 search_view;
        private PhotosView                 history_view;
        private EmptyHistoryView           empty_view_history;
        private EmptyView                  empty_view;
        private LoadingView                box_loading;
        private AppViewError               view_error;
        private AppConnection              connection;
        private Gtk.ScrolledWindow         scrolled_main;
        private Gtk.ScrolledWindow         scrolled_search;
        private Gtk.ScrolledWindow         scrolled_history;
        private Gtk.Stack                  stack;
        private Gtk.Box                    box_stack;
        private BottonNavbar               bottonNavbar;
        private LabelTop                   search_label;
        private LabelTop                   history_label;
        private LabelTotalResults          total_label;
        private MultipleWallpaperView      multiple_wallpaper;

        private int                        num_page;
        private int                        num_page_search;
        private string                     current_query;

        private bool                       is_scrolling; 
        private bool                       is_history_loaded;

        private const string STACK_EMPTY_HISTORY = "empty_history";
        private const string STACK_CATEGORIES = "categories";
        private const string STACK_LOADING = "spinner";
        private const string STACK_HISTORY = "history";
        private const string STACK_SEARCH = "search";
        private const string STACK_TODAY = "today";
        private const string STACK_EMPTY = "empty";
        private const string STACK_ERROR = "error"; 
        
        /**
         * Constructs a new {@code AppController} object.
         */
        public AppController (Gtk.Application application) {
            this.application = application;
            this.connection = AppConnection.get_instance();
            this.num_page = 1;
            this.num_page_search = 1;
            this.is_scrolling = false;
            this.is_history_loaded = false;

            // window setup
            window  =       new Window (this.application);

            // Stack for views
            stack = new Gtk.Stack ();
            stack.transition_duration = 400;
            stack.hhomogeneous = false;
            stack.interpolate_size = true;

            // Views used in Stock
            scrolled_main =         new Gtk.ScrolledWindow (null, null);
            scrolled_search =       new Gtk.ScrolledWindow (null, null);
            scrolled_history =      new Gtk.ScrolledWindow (null, null);
            box_loading =           new LoadingView ();
            categories =            new CategoriesView ();
            empty_view =            new EmptyView ();
            empty_view_history =    new EmptyHistoryView ();       
            view =                  new PhotosView ();
            search_view =           new PhotosView ();
            history_view =          new PhotosView ();
            view_error =            new AppViewError();
            multiple_wallpaper =    new MultipleWallpaperView ();

            // Configure headerbar
            headerbar =     new App.Widgets.HeaderBar (multiple_wallpaper);
            window.set_titlebar (this.headerbar);

            view.applying_filter.connect ( () => {
                check_filter ();
            });

            search_view.applying_filter.connect ( () => {
                check_filter ();
            });

            history_view.applying_filter.connect ( () => {
                check_filter ();
            });

            // Today photos container
            var content_scroll =        new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
            var header_photos =         new LabelTop (S.TODAY);
            content_scroll.add (header_photos);
            content_scroll.add (view);

            // Search photos container
            var content_search_scroll = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
            search_label = new LabelTop (S.SEARCH_PHOTOS_UNSPLASH);
            total_label = new LabelTotalResults (S.TOTAL_RESULTS);
            content_search_scroll.add (search_label);
            content_search_scroll.add (total_label);
            content_search_scroll.add (search_view);

            // History photos container
            var content_history_scroll = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
            history_label = new LabelTop (S.HISTORY);
            content_history_scroll.add (history_label);
            content_history_scroll.add (history_view);

            scrolled_main.add (content_scroll);
            scrolled_search.add (content_search_scroll);
            scrolled_history.add (content_history_scroll);

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
                bottonNavbar.clean_all ();
            });

            view.selected_card.connect ( (photo_card) => {
                multiple_wallpaper.add_card (photo_card);
            });

            search_view.selected_card.connect ( (photo_card) => {
                multiple_wallpaper.add_card (photo_card);
            });

            history_view.selected_card.connect ( (photo_card) => {
                multiple_wallpaper.add_card (photo_card);
            });

            view.removed_card.connect ( (photo_card) => {
                multiple_wallpaper.remove_card (photo_card);
            });

            search_view.removed_card.connect ( (photo_card) => {
                multiple_wallpaper.remove_card (photo_card);
            });

            history_view.removed_card.connect ( (photo_card) => {
                multiple_wallpaper.remove_card (photo_card);
            });

            view_error.retry.connect(() => {
                check_internet();
            }); 

            window.search_accel.connect(() => {
                headerbar.search.grab_focus ();
            });
            
            stack.add_named(box_loading,        STACK_LOADING);
            stack.add_named(content_categories, STACK_CATEGORIES);
            stack.add_named(scrolled_main,      STACK_TODAY);
            stack.add_named(scrolled_search,    STACK_SEARCH);
            stack.add_named(scrolled_history,   STACK_HISTORY); 
            stack.add_named(empty_view,         STACK_EMPTY); 
            stack.add_named(view_error,         STACK_ERROR);
            stack.add_named(empty_view_history, STACK_EMPTY_HISTORY);
            
            // Navigationbar
            bottonNavbar = new BottonNavbar ();
            bottonNavbar.valign = Gtk.Align.END;
            bottonNavbar.halign = Gtk.Align.FILL;
            bottonNavbar.hexpand = true;

            bottonNavbar.today.connect ( () => {
                stack_visible (STACK_TODAY);
            });

            bottonNavbar.categories.connect ( () => {
                stack_visible (STACK_CATEGORIES);
            });

            bottonNavbar.history.connect ( () => {
                var jsonManager = new JsonManager ();
                var history = jsonManager.load_from_file ();
                history.reverse ();
                
                if (history.length () > 0) {
                    stack_visible (STACK_HISTORY);
                    history_view.clean_list ();
                    history_view.insert_cards (history, false, HISTORY);
                } else {
                    stack_visible (STACK_EMPTY_HISTORY);
                }
            });

            // Window Overlay
            box_stack = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            box_stack.add (stack);
            box_stack.add (bottonNavbar);
            window.add (box_stack);
            application.add_window (window);

            check_internet();
        }

        private void applying_filter (string stack_back) {
            if (!this.is_scrolling){
                stack.set_visible_child_full (STACK_LOADING, Gtk.StackTransitionType.NONE);

                MainLoop loop = new MainLoop ();
                TimeoutSource time = new TimeoutSource (400);
                time.set_callback (() => {
                    stack.set_visible_child_full (stack_back, Gtk.StackTransitionType.SLIDE_UP);
                    stack.get_visible_child ().sensitive = true;
                    scrolled_search.get_vadjustment ().set_value (0);
                    scrolled_main.get_vadjustment ().set_value (0);
                    scrolled_history.get_vadjustment ().set_value (0);
                    return false;
                });
                time.attach (loop.get_context ());
            } else {
                stack.get_visible_child ().sensitive = true;
            }
            is_scrolling = false;
        }

        private void check_filter () {
            var current_view = stack.get_visible_child_name ();
            if (current_view == STACK_TODAY || current_view == STACK_SEARCH || current_view == STACK_HISTORY) {
                stack.get_visible_child ().sensitive = false;
                applying_filter (current_view);
            }
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
                    block_ui (true);
                    view.insert_cards(list);
                    stack.set_visible_child_full (STACK_TODAY, Gtk.StackTransitionType.SLIDE_UP);
                }
            } );

            // Signal catched when a search request is success and setup the photos 
            connection.request_page_search_success.connect ( (response) => {
                block_ui (true);
                if (response.results.length () > 0) {
                    search_view.insert_cards(response.results);
                    total_label.update_total (response.total.to_string());
                    stack_visible (STACK_SEARCH);
                } else if (num_page_search == 1) {
                    stack.set_visible_child_full (STACK_EMPTY, Gtk.StackTransitionType.SLIDE_UP);
                }
            } );

            // signal catched when scroll reaches the edge
            scrolled_main.edge_reached.connect( (pos)=> {
                if (pos == Gtk.PositionType.BOTTOM) {
                    this.num_page++;
                    this.is_scrolling = true;
                    connection.load_page(num_page);
                }
            } );

            // signal catched when scroll reaches the edge
            scrolled_search.edge_reached.connect( (pos)=> {
                if (pos == Gtk.PositionType.BOTTOM) {
                    this.num_page_search++;
                    this.is_scrolling = true;
                    connection.load_search_page(num_page_search, current_query);
                }
            } );
        }

        private void search_query (string search) {
            num_page_search = 1;
            current_query = search;
            search_view.clean_list ();
            connection.load_search_page(num_page_search, search);
            update_iu_for_search (search);
        }

        private void update_iu_for_search (string search) {
            block_ui (false);
            scrolled_search.get_vadjustment ().set_value (0);
            stack.set_visible_child_full (STACK_LOADING, Gtk.StackTransitionType.SLIDE_DOWN);
            search_label.label = search;
        }

        private void stack_visible (string new_stack) {
            switch (new_stack) {
                case STACK_TODAY:
                    views_sensitives (true, false, false);
                    stack.set_visible_child_full (STACK_TODAY, Gtk.StackTransitionType.SLIDE_UP);
                    break;
                case STACK_SEARCH:
                    views_sensitives (false, true, false);
                    stack.set_visible_child_full (STACK_SEARCH, Gtk.StackTransitionType.SLIDE_UP);
                    break;
                case STACK_HISTORY:
                    views_sensitives (false, false, true);
                    stack.set_visible_child_full (STACK_HISTORY, Gtk.StackTransitionType.SLIDE_UP);
                    break;
                case STACK_CATEGORIES:
                    stack.set_visible_child_full (STACK_CATEGORIES, Gtk.StackTransitionType.SLIDE_UP);
                    break;
                case STACK_EMPTY_HISTORY:
                    stack.set_visible_child_full (STACK_EMPTY_HISTORY, Gtk.StackTransitionType.SLIDE_UP);
                    break;
                default:
                    views_sensitives (true, false, false);
                    stack.set_visible_child_full (STACK_TODAY, Gtk.StackTransitionType.SLIDE_UP);
                    break;
            }
        }

        private void views_sensitives (bool today, bool search, bool history) {
            view.sensitive          = today;
            search_view.sensitive   = search;
            history_view.sensitive  = history;
        }

        private void block_ui (bool block) {
            headerbar.search.sensitive  = block;
            bottonNavbar.sensitive      = block;
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
