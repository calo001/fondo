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

namespace App.Connection {

     /**
     * The {@code AppConnection} class.
     *
     * @since 1.0.0
     */
    public class AppConnection {

        public AppConnection() {

        }

        public int api_connection() {
            var session = new Soup.Session ();
            string uri = Constants.API_UNSPLASH +
                         "photos/random/?client_id=" +
                         Constants.ACCESS_KEY_UNSPLASH +
                         Constants.API_PARAMS;
            var message = new Soup.Message ("GET", uri);

            /* send a sync request */
            session.send_message (message);
            message.response_headers.foreach ((name, val) => {
                stdout.printf ("Name: %s -> Value: %s\n", name, val);
            });

            stdout.printf ("Message length: %lld\n%s\n",
                       message.response_body.length,
                       cadenas(message));
        return 0;
        }

        public string cadenas(Soup.Message message) {
            var parser = new Json.Parser ();
            parser.load_from_data(message.response_body.data);
            var node = parser.get_root ();
            unowned Json.Array array = node.get_array ();

            //foreach (unowned Json.Node item in array.get_elements ()) {
		    //    process_role (item, i);
		    //    i++;
	        //}

            return "gua";
        }
    }
}
