/*
* Copyright (C) 2020 - Fondo
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

using Gtk;
using App.Configs;
namespace App.Utils {

    /**
     * The {@code XMLBackground} class. Generates and saves to disk an XML file
     * with the requested format for a wallpaper slideshow
     */

    public class XMLBackground {

        private File                    collection_file;
        private unowned List<string>    background_list;
        private int                     static_time;
        private int                     transition_time;
        private DateTime                start_time;


        public XMLBackground (string collection_file, List<string> wallpapers_path_list, int static_time, int transition_time, DateTime start_time) {
            this.background_list = wallpapers_path_list;
            this.collection_file = File.new_for_path(collection_file);
            this.static_time = static_time;
            this.transition_time = transition_time;
            this.start_time = start_time;
        }

        private string generate_xml() {
            int num_backgrounds = (int) this.background_list.length();

            string full_string = "<background>\n" + generate_starttime();

            for (int i = 0; i < num_backgrounds; i++) {
                string current = this.background_list.nth_data(i);
                full_string += generate_static(current, static_time);
                
                var next_transition = i + 1 >= num_backgrounds ? 0 : i + 1;
                string next = this.background_list.nth_data(next_transition);
                full_string += generate_transition(current, next, transition_time);    
            }
            full_string += "</background>";

            return full_string;
        }

        /**
         *  Writes an XML background file and returns the file
        */
        public File write_background () {
            try {
                string xml_text = this.generate_xml ();

                // delete if file already exists
                if (collection_file.query_exists ()) {
                    collection_file.delete ();
                }

                var dos = new DataOutputStream (collection_file.create (FileCreateFlags.REPLACE_DESTINATION));

                uint8[] data = xml_text.data;
                long written = 0;
                while (written < data.length) {
                    // sum of the bytes of 'xml_text' that already have been written to the stream
                    written += dos.write (data[written:data.length]);
                }

                GLib.message ("File %s written successfully.\n", collection_file.get_path ());

            } catch (Error e) {
                stderr.printf ("%s\n", e.message);
            }
            return collection_file;
        }

        private string generate_starttime () {
            string year = "%d".printf (start_time.get_year());
            string month = "%d".printf (start_time.get_month());
            string day = "%d".printf (start_time.get_day_of_month());
            string hour = "%d".printf (start_time.get_hour());
            string minute = "%d".printf (start_time.get_minute());
            string second = "%d".printf (start_time.get_second());


            string starttime = "<starttime>\n" +
                    "\t<year>" + year + "</year>\n" +
                    "\t<month>"+ month + "</month>\n" +
                    "\t<day>" + day + "</day>\n" +
                    "\t<hour>" + hour + "</hour>\n" +
                    "\t<minute>" + minute + "</minute>\n" +
                    "\t<second>" + second + "</second>\n" +
                    "</starttime>\n";
            return starttime;
        }

        private string generate_static (string background, int duration) {
            string duration_str = "%g.0".printf (duration);
            string safe_background = scape_string(background);
            return "<static>\n" +
                "\t<duration>" + duration_str + "</duration>\n" +
                "\t<file>" + safe_background + "</file>\n" +
                "</static>\n";
        }

        private string generate_transition (string background_from, string background_to, int duration) {
            string duration_str = "%g.0".printf (duration);
            string safe_bkg_from = scape_string(background_from);
            string safe_bkg_to = scape_string(background_to);
            return "<transition>\n" +
                "\t<duration>" + duration_str + "</duration>\n" +
                "\t<from>" + safe_bkg_from + "</from>\n" +
                "\t<to>" + safe_bkg_to + "</to>\n" +
                "</transition>\n";
        }

        private string scape_string(string unsafe_string) {
            return GLib.Markup.escape_text(unsafe_string);
        }
    }
}
