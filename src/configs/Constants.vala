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

namespace App.Configs {

    /**
     * The {@code Constants} class is responsible for defining all 
     * the constants used in the application.
     *
     * @since 1.0.0
     */
    public class Constants {
    
        public abstract const string ID = "com.github.calo001.fondo";
        public abstract const string VERSION = "1.0.0";
        public abstract const string PROGRAME_NAME = "Fondo";
        public abstract const string APP_YEARS = "2018";
        public abstract const string APP_ICON = "com.github.calo001.fondo";
        public abstract const string ABOUT_COMMENTS = "";
        public abstract const string TRANSLATOR_CREDITS = "Translators";
        public abstract const string MAIN_URL = "{{ website-url }}";
        public abstract const string BUG_URL = "{{ repo-url }}/issues";
        public abstract const string HELP_URL = "{{ repo-url }}/wiki";
        public abstract const string TRANSLATE_URL = "{{ repo-url }}";
        public abstract const string TEXT_FOR_ABOUT_DIALOG_WEBSITE = "Website";
        public abstract const string TEXT_FOR_ABOUT_DIALOG_WEBSITE_URL = "{{ website-url }}";
        public abstract const string URL_CSS = "/com/github/calo001/fondo/css/style.css";
        public abstract const string [] ABOUT_AUTHORS = { "Calo001 <calo_lrc@hotmail.com>" };
        public abstract const string ACCESS_KEY_UNSPLASH = "https://images.unsplash.com/photo-1502913625325-725506829ddc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjMwODIyfQ&s=9b9f1c49ad1e443388cc3daf691b976d";
        public abstract const Gtk.License ABOUT_LICENSE_TYPE = Gtk.License.CUSTOM;
    }
}
