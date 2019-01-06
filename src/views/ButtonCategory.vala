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


namespace App.Views {

    /**
     * The {@code ButtonCategory} class.
     *
     * @since 1.0.0
     */

    public class ButtonCategory : Gtk.Button {
        private string name_category;
        private string style_category;

        public ButtonCategory (string name_category, string style_category) {
            this.name_category = name_category;
            this.style_category = style_category;

            setup();
        }

        private void setup (){
            this.expand = true;
            this.label = name_category;
            this.get_style_context ().add_class (style_category);
            this.get_style_context ().add_class ("btn-category");
            this.get_style_context ().add_class ("h2");
            this.get_style_context ().add_class ("card");
        }
    }
}
