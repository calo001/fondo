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
using App.Structs;

namespace App.Connection {

     /**
     * The {@code AppConnection} class.
     *
     * @since 1.0.0
     */
    public class AppConnection {

        private static List<Photo?> list_thumbs = new List<Photo?> ();

        private const string URI_UNSPLASH = Constants.API_UNSPLASH +
                         "photos/random/?client_id=" +
                         Constants.ACCESS_KEY_UNSPLASH +
                         Constants.API_PARAMS;

        public AppConnection() {}

        public Soup.Message api_connection(string uri) {
            var session = new Soup.Session ();
            var message = new Soup.Message ("GET", uri);

            MainLoop loop = new MainLoop ();

            // Send a request:
	        session.queue_message (message, (sess, mess) => {
		        // Process the result:
		        print ("Status Code: %u\n", mess.status_code);
		        print ("Message length: %lld\n", mess.response_body.length);
		        //print ("Data: \n%s\n", (string) mess.response_body.data);
		        loop.quit ();
	        });

	        loop.run ();

            return message;
        }


        public bool load_pages () {
            Soup.Message message = api_connection(URI_UNSPLASH);

            var parser = new Json.Parser ();
            try {
                parser.load_from_data ((string) message.response_body.flatten ().data, -1);
                get_data (parser);
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
                return false;
            }
            return true;
        }

        private void get_data (Json.Parser parser) {
            var node = parser.get_root ();
            unowned Json.Array array = node.get_array ();
            foreach (unowned Json.Node item in array.get_elements ()) {
                var object = item.get_object();
                var photo_info = Photo() {
                    id =                        object.get_string_member ("id"),
                    width =                     object.get_int_member ("width"),
                    height =                    object.get_int_member ("height"),
                    urls_thumb =                object.get_object_member ("urls")
                                                      .get_string_member ("small"),
                    links_download_location =   object.get_object_member ("links")
                                                      .get_string_member ("download_location"),
                    username =                  object.get_object_member ("user")
                                                      .get_string_member ("username"),
                    name =                      object.get_object_member ("user")
                                                      .get_string_member ("name"),
                    location =                  object.get_object_member ("location")
                                                      .get_string_member ("title")
                    };
                    list_thumbs.append (photo_info);
	            }
        }

        public string get_url_photo (string links_download_location) {
            string uri = links_download_location + "/?client_id=" + Constants.ACCESS_KEY_UNSPLASH;
            Soup.Message message = api_connection(uri);
            string url = "";
            var parser = new Json.Parser ();
            try {
                parser.load_from_data ((string) message.response_body.data, -1);
                var node = parser.get_root ();
                url = node.get_object ().get_string_member ("url");
            } catch (Error e) {
                print ("Unable to parse the string: %s\n", e.message);
                return url;
            }
            return url;
        }

        public List<Photo?> get_thumbs_page (int start, int end) {
            var page = new List<Photo?> ();
            for (int i = start; i < end; i++) {
                page.append (list_thumbs.nth_data (i));
            }
            return page;
        }
    }
}
