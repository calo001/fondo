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

namespace App {

    /**
     * The {@code Application} class is a foundation for all granite-based applications.
     *
     * @see Granite.Application
     * @since 1.0.0
     */
    public class Application : Gtk.Application {

        /**
         * Constructs a new {@code Application} object.
         */
        public Application () {
            Object (
                application_id: "com.github.calo001.fondo.background",
                flags: ApplicationFlags.FLAGS_NONE
            );
        }

        /**
         * Handle attempts to start up the application
         * @return {@code void}
         */
        public override void activate () {
            message ("activated backrgound fondo");
            //message ("dummy");
            //var config_normal = Model.getDummyConfigNormal ();
            //message ("json_node");
            //var json_node = config_normal.to_json_node ();
            //message ("config again");
            //var config = Model.Config.from_json_node (json_node);

            var data = "{\r\n    \"normal\": {\r\n        \"id\": 100001,\r\n        \"picture_url\": \"url..\"\r\n    },\r\n    \"slideshow\": {\r\n        \"id\": 1000002,\r\n        \"picture_files\": [\r\n            \"url1...\",\r\n            \"url2...\"\r\n        ],\r\n        \"start_time\": 40000,\r\n        \"interval\": 3000000,\r\n        \"latest_picture\": \"url2...\"\r\n    },\r\n    \"daynight\": {\r\n        \"id\": 1000003,\r\n        \"day_picture\": \"url2...\",\r\n        \"night_picture\": \"url2...\",\r\n        \"schedule_day\": [1,2,3,4,5],\r\n        \"schedule_night\": [6,7,8,9]\r\n    }\r\n}";
            var data2 = "{\"slideshow\": {\r\n        \"id\": 1000002,\r\n        \"picture_files\": [\r\n            \"url1...\",\r\n            \"url2...\"\r\n        ],\r\n        \"start_time\": 40000,\r\n        \"interval\": 3000000,\r\n        \"latest_picture\": \"url2...\"\r\n    },\r\n    \"daynight\": {\r\n        \"id\": 1000003,\r\n        \"day_picture\": \"url2...\",\r\n        \"night_picture\": \"url2...\",\r\n        \"schedule_day\": [1,2,3,4,5],\r\n        \"schedule_night\": [6,7,8,9]\r\n    }\r\n}";
            var data3 = "{\"daynight\": {\r\n        \"id\": 1000003,\r\n        \"day_picture\": \"url2...\",\r\n        \"night_picture\": \"url2...\",\r\n        \"schedule_day\": [1,2,3,4,5],\r\n        \"schedule_night\": [6,7,8,9]\r\n    }\r\n}";
            var data4 = "{\r\n    \"normal\": {\r\n        \"id\": 100001,\r\n        \"picture_url\": \"url..\"\r\n    }}";
            var data5 = "{\"slideshow\": {\r\n        \"id\": 1000002,\r\n        \"picture_files\": [\r\n            \"url1...\",\r\n            \"url2...\"\r\n        ],\r\n        \"start_time\": 40000,\r\n        \"interval\": 3000000,\r\n        \"latest_picture\": \"url2...\"\r\n    }}";
            

            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (data);
                Json.Node node = parser.get_root ();
                var config = Model.Config.from_json_node (node);
                message (config.json_string);
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
            }

            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (data2);
                Json.Node node = parser.get_root ();
                var config = Model.Config.from_json_node (node);
                message (config.json_string);
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
            }

            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (data3);
                Json.Node node = parser.get_root ();
                var config = Model.Config.from_json_node (node);
                message (config.json_string);
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
            }

            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (data4);
                Json.Node node = parser.get_root ();
                var config = Model.Config.from_json_node (node);
                message (config.json_string);
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
            }

            try {
                Json.Parser parser = new Json.Parser ();
                parser.load_from_data (data5);
                Json.Node node = parser.get_root ();
                var config = Model.Config.from_json_node (node);
                message (config.json_string);
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
            }

            hold ();
        }
    }
}
