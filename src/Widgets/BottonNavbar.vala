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
using App.Enums;

namespace App.Widgets {

    /**
     * The {@code BottonNavbar} class is responsible for displaying a button navigation bar.
     *
     */
    public class BottonNavbar : Gtk.Grid {
        public  Navigation  current_tab {get; set;}
        private ButtonTab   btnToday;
        private ButtonTab   btnCategories;
        private ButtonTab   btnHistory;

        public signal void today ();
        public signal void categories ();
        public signal void history ();        

        public BottonNavbar () {
            vexpand = false;
            sensitive = false;
            
            btnToday = new ButtonTab ("go-home-symbolic", S.TODAY_TAB);
            btnCategories = new ButtonTab ("view-grid-symbolic.symbolic", S.CATEGORIES_TAB);
            btnHistory = new ButtonTab ("preferences-system-time-symbolic", S.HISTORY_TAB);

            current_tab = Navigation.TODAY;
            btnToday.on_active ();
            
            btnToday.clicked.connect ( ()=> {
                clean_all ();
                current_tab = Navigation.TODAY;
                btnToday.on_active ();

                today ();
            });

            btnCategories.clicked.connect ( ()=> {
                clean_all ();
                current_tab = Navigation.CATEGORIES;
                btnCategories.on_active ();

                categories ();
            });

            btnHistory.clicked.connect ( ()=> {
                clean_all ();
                current_tab = Navigation.CATEGORIES;
                btnHistory.on_active ();

                history ();
            });

            get_style_context ().add_class ("inline-toolbar");
            get_style_context ().add_class ("transition");
            
            add (btnToday);
            add (btnCategories);
            add (btnHistory);
        }
        
        public void clean_all () {
            btnHistory.on_inactive ();
            btnToday.on_inactive ();
            btnCategories.on_inactive ();
        }
    }
}