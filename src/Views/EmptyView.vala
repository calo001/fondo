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
namespace App.Views {

    /**
     * The {@code EmptyView} class.
     *
     * @since 1.0.0
     */
    public class EmptyView : Gtk.Box {
        /**
         * Constructs a new {@code EmptyView} object.
         */
        public EmptyView () {
            this.orientation = Gtk.Orientation.VERTICAL;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.CENTER;

            var image = new Gtk.Image.from_icon_name  ("system-search", Gtk.IconSize.DIALOG);
		    var label_title = new Gtk.Label (S.PHOTOS_NOT_FOUND);
		    var label_description = new Gtk.Label (S.EMPTY_SEARCH_DESCRIPTION);

		    label_title.get_style_context ().add_class ("h2");
		    label_description.get_style_context ().add_class ("h4");
        
            add(image);
            add(label_title);
            add(label_description);
        }

    }
}