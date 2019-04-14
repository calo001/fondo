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
using App.Configs;
namespace App.Popover {

    /**
     * The {@code MenuPopover} class is responsible for displaying a popup menu content.
     *
     * @since 1.3.0
     */
    public class MenuPopover : Gtk.Popover {
        public MenuPopover(Gtk.Widget relative_to) {
            Object (
                relative_to: relative_to
            );          
            get_style_context ().add_class ("pop-menu");
            set_modal (true);

            var grid = new Gtk.Grid ();
            var unsplash_link = "https://unsplash.com/?utm_source=Fondo&utm_medium=referral";
            var logo = new Gtk.Image.from_resource ("/com/github/calo001/fondo/images/unsplashlogo.svg");
            var unsplash_button = new Gtk.LinkButton(unsplash_link);
            unsplash_button.always_show_image = true;
            unsplash_button.image = logo;
            unsplash_button.label = null;
            unsplash_button.tooltip_text = S.UNSPLASH_DESCRIPTION;

            var filter_grid = new Gtk.Grid();

            var button_landscape = new Gtk.RadioButton.with_label (null, "Landscape");
            button_landscape.get_style_context ().add_class (Gtk.STYLE_CLASS_MENUITEM);
            button_landscape.expand = true;

            var button_portrait = new Gtk.RadioButton.with_label (null, "Portrait");
            button_portrait.get_style_context ().add_class (Gtk.STYLE_CLASS_MENUITEM);
            button_portrait.expand = true;

            var button_any = new Gtk.RadioButton.with_label (null, "Any");
            button_any.get_style_context ().add_class (Gtk.STYLE_CLASS_MENUITEM);
            button_any.expand = true;

            button_portrait.join_group (button_landscape);
            button_any.join_group (button_landscape);

            var lbl_filter = new Gtk.Label ("Orientation");
            lbl_filter.get_style_context ().add_class ("h4");

            grid.margin = 0;
            grid.row_spacing = 0;

            filter_grid.attach (lbl_filter,   0, 0, 1, 1);
            filter_grid.attach (button_landscape,   0, 1, 1, 1);
            filter_grid.attach (button_portrait,    0, 2, 1, 1);
            filter_grid.attach (button_any,         0, 3, 1, 1);

            filter_grid.get_style_context ().add_class ("filter-popover");
            filter_grid.expand = true;

            grid.attach (unsplash_button,   0, 1, 1, 1);
            grid.attach (filter_grid,       0, 2, 1, 1);
            grid.show_all ();
            add (grid);

            button_any.active = true;
        }
    }
}
