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
     * The {@code SearchView} class.
     *
     * @since 1.0.0
     */
    public class CategoriesView : Gtk.FlowBox {
        private ButtonCategory btn_nature; 
        private ButtonCategory btn_animal;
        private ButtonCategory btn_food_drink;
        private ButtonCategory btn_space;
        private ButtonCategory btn_sport;
        private ButtonCategory btn_business_work;
        private ButtonCategory btn_woman;
        private ButtonCategory btn_man;
        private ButtonCategory btn_architecture;
        private ButtonCategory btn_technology;
        private ButtonCategory btn_texture_pattern;
        private ButtonCategory btn_flatlay;

        public signal void search_category (string value);

        /**
         * Constructs a new {@code SearchView} object.
         */
        public CategoriesView () {
            this.min_children_per_line = 2;
            this.max_children_per_line = 4;
            this.column_spacing = 12;
            this.row_spacing = 12;
            this.margin = 8;
            this.homogeneous = true;
            
            btn_nature = new ButtonCategory(_("Nature"), "btn-nature");
            btn_animal = new ButtonCategory(_("Animal"), "btn_animal");
            btn_food_drink = new ButtonCategory(_("Food & drink"), "btn_food_drink");
            btn_space = new ButtonCategory(_("Space"), "btn_space");
            btn_sport = new ButtonCategory(_("Sport"), "btn_sport");
            btn_business_work = new ButtonCategory(_("Business\n& work"), "btn_business_work");
            btn_woman = new ButtonCategory(_("Woman"), "btn_woman");
            btn_man = new ButtonCategory(_("Man"), "btn_man");
            btn_architecture = new ButtonCategory(_("Architecture"), "btn_architecture");
            btn_technology = new ButtonCategory(_("Technology"), "btn_technology");
            btn_texture_pattern = new ButtonCategory(_("Texture\n& pattern"), "btn_texture_pattern");
            btn_flatlay = new ButtonCategory(_("Flat lay"), "btn_flatlay");

            btn_nature.clicked.connect ( ()=> {
                search_category ("Nature");
            } );

            btn_animal.clicked.connect ( ()=> {
                search_category ("Animal");
            } );

            btn_food_drink.clicked.connect ( ()=> {
                search_category ("Food & drink");
            } );

            btn_space.clicked.connect ( ()=> {
                search_category ("Space");
            } );

            btn_sport.clicked.connect ( ()=> {
                search_category ("Sport");
            } );

            btn_business_work.clicked.connect ( ()=> {
                search_category ("Business & work");
            } );

            btn_woman.clicked.connect ( ()=> {
                search_category ("Woman");
            } );

            btn_man.clicked.connect ( ()=> {
                search_category ("Man");
            } );

            btn_architecture.clicked.connect ( ()=> {
                search_category ("Architecture");
            } );

            btn_technology.clicked.connect ( ()=> {
                search_category ("Technology");
            } );

            btn_texture_pattern.clicked.connect ( ()=> {
                search_category ("Textures & Patterns");
            } );

            btn_flatlay.clicked.connect ( ()=> {
                search_category ("Flat lay");
            } );

            this.add (btn_nature);
            this.add (btn_animal);
            this.add (btn_food_drink);
            this.add (btn_space);
            this.add (btn_sport);
            this.add (btn_business_work);
            this.add (btn_woman);
            this.add (btn_man);
            this.add (btn_architecture);
            this.add (btn_technology);
            this.add (btn_texture_pattern);
            this.add (btn_flatlay);
        }

    }
}
