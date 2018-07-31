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

namespace App.Controllers {

    /**
     * The {@code AppController} class.
     *
     * @since 1.0.0
     */
    public class AppController {

        private Gtk.Application            application;
        private Gtk.HeaderBar              headerbar;
        private AppView                    app_view; 
        private Gtk.ApplicationWindow      window { get; private set; default = null; }
        /**
         * Constructs a new {@code AppController} object.
         */
        public AppController (Gtk.Application application) {
            this.application = application;
            this.window = new Window (this.application);
            this.headerbar = new HeaderBar ();

            this.app_view = new AppView ();

            this.window.add (this.app_view);
            this.window.set_titlebar (this.headerbar);
            this.application.add_window (window);
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
