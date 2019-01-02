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

        // Signals for Classes tha use this class
        public signal void request_page_success(List<Photo?> list);

        private static AppConnection? instance;
        private Soup.Session session;

        public AppConnection() {
            this.session = new Soup.Session();
        }

        // Parse data from API
        public void load_page (int num_page) {
            //print("\n\nPAGINA #" + num_page.to_string() + "\n\n");
            //print(uri + "\n");
            
            var uri = Constants.URI_PAGE + 
                      "&page=" + num_page.to_string() + 
                      "&per_page=" + "24" +
                      "&order_by=" + "latest";
            
            //var uri = "http://jsonplaceholder.typicode.com/todos/1";
            var message = new Soup.Message ("GET", uri);

            session.queue_message (message, (sess, mess) => {
                // Process the result:
                print (uri);
		        print ("Status Code: %u\n", mess.status_code);
		        print ("Message length: %lld\n", mess.response_body.length);
                //print ("Data: \n%s\n", (string) mess.response_body.data);
                
                var parser = new Json.Parser ();
                try {
                    parser.load_from_data ((string) mess.response_body.flatten ().data, -1);
                    var list = get_data (parser);
                    request_page_success(list);
                } catch (Error e) {
                    show_message("Request page fail", 
                                  e.message,
                                  "dialog-error");
                }
            });
        }

        // Create all structure Photo
        private List<Photo?> get_data (Json.Parser parser) {
            List<Photo?> list_thumbs = new List<Photo?> ();

            var node = parser.get_root ();
            unowned Json.Array array = node.get_array ();
            foreach (unowned Json.Node item in array.get_elements ()) {
                var object = item.get_object();
                var photo_info = Photo() {
                    id =                        object.get_string_member ("id"),
                    width =                     object.get_int_member    ("width"),
                    height =                    object.get_int_member    ("height"),
                    urls_thumb =                object.get_object_member ("urls")
                                                      .get_string_member ("small"),
                    links_download_location =   object.get_object_member ("links")
                                                      .get_string_member ("download_location"),
                    username =                  object.get_object_member ("user")
                                                      .get_string_member ("username"),
                    name =                      object.get_object_member ("user")
                                                      .get_string_member ("name"),
                    location =                  object.get_object_member ("user")
                                                      .get_string_member ("location")
                    };
                    list_thumbs.append (photo_info);
                }
            return list_thumbs;
        }

        // Get an image from: links_download_location
        public string? get_url_photo (string links_download_location) {
            string uri = links_download_location + 
                         "/?client_id=" + 
                         Constants.ACCESS_KEY_UNSPLASH;
            
            //print(uri + "\n");
            //print("\nGET URL PHOTO\n");
            var message = new Soup.Message ("GET", uri);
            string? image = null;

            MainLoop loop = new MainLoop ();
            session.queue_message (message, (sess, mess) => {
                // Process the result:
		        //print ("Status Code: %u\n", mess.status_code);
		        //print ("Message length: %lld\n", mess.response_body.length);
                //print ("Data: \n%s\n", (string) mess.response_body.data);
                
                var parser = new Json.Parser ();
                try {
                    //parser.load_from_data ((string) message.response_body.flatten ().data, -1);
                    parser.load_from_data ((string) mess.response_body.flatten ().data, -1);
                    var node = parser.get_root ();
                    image = node.get_object ().get_string_member ("url");
                    loop.quit ();     
                } catch (Error e) {
                    show_message("Unable to parse the string", 
                                  e.message,
                                  "dialog-error");
                }
            });
            loop.run ();
            return image;
        }

        /**
         * Returns a single instance of this class.
         * 
         * @return {@code Settings}
         */
        public static unowned AppConnection get_instance () {
            if (instance == null) {
                instance = new AppConnection ();
            }
            return instance;
        }

        /************************************
           Dialog that show error messages
        ************************************/
        private void show_message (string txt_primary, string txt_secondary, string icon) {
            var message_dialog = new Granite.MessageDialog.with_image_from_icon_name (
                txt_primary,
                txt_secondary,
                icon,
                Gtk.ButtonsType.CLOSE
            );

            message_dialog.run ();
            message_dialog.destroy ();
        }
    }
}
