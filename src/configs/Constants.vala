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
    
        // API KEY in development, this must to change on production release
            // * Already changed :)
        
        public abstract const string API_UNSPLASH = "https://api.unsplash.com/";
        public abstract const string GET = "photos/?client_id=";
        public abstract const string ACCESS_KEY_UNSPLASH = "db4d69677b2838dfc4f9ef73ee79dcde8412472617bc96adefde321bd08a76f2";
        public abstract const string URI_PAGE = API_UNSPLASH + GET + ACCESS_KEY_UNSPLASH;

        public abstract const string ID = "com.github.calo001.fondo";
        public abstract const string VERSION = "1.1.0";
        public abstract const string PROGRAME_NAME = "Fondo";
        public abstract const string APP_YEARS = "2018";
        public abstract const string APP_ICON = "com.github.calo001.fondo";
        public abstract const string ABOUT_COMMENTS = "Unsplash wallpaper App for elementary OS";
        public abstract const string TRANSLATOR_CREDITS = "Translators";
        public abstract const string MAIN_URL = "https://github.com/calo001/fondo";
        public abstract const string BUG_URL = "https://github.com/calo001/issues";
        public abstract const string HELP_URL = "https://github.com/calo001/wiki";
        public abstract const string URL_CSS = "/com/github/calo001/fondo/css/style.css";
        public abstract const string [] ABOUT_AUTHORS = { "Calo001 <calo_lrc@hotmail.com>" };
        public abstract const Gtk.License ABOUT_LICENSE_TYPE = Gtk.License.CUSTOM;
        public abstract const int SIZE_IMAGE_AVERAGE = 10000000;
    }
}
