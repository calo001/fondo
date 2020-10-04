/*
* Copyright (C) 2020 Fondo
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
using App.Configs;
using App.Views;
namespace App.Popover {

    /**
     * The {@code MultipleWallpaperPopover} class is responsible for displaying a popup menu
     * for multiple selection of wallpapers.
     *
     * @since 1.3.0
     */
    public class MultipleWallpaperPopover : Gtk.Popover {

        public MultipleWallpaperPopover(Gtk.Widget relative_to, MultipleWallpaperView multiple_view) {
            Object (
                relative_to: relative_to
            );
            get_style_context ().add_class ("multiple_wallpaper_popup");
            set_modal (true);

            var grid = new Gtk.Grid ();


            grid.attach (multiple_view,       0, 3, 1, 1);
            grid.show_all ();
            add (grid);

            multiple_view.close_multiple_view.connect( () => {
                this.popdown();
            });

        }


    }
}
