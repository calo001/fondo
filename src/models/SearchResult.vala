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

namespace App.Models {
    /**
     * The {@code Photo} class model.
     *
     * @since 1.0.0
     */

    public class SearchResult : Object {
        public int64 total { get; set; }
        public int64 total_pages { get; set; }
        public unowned List<Photo?> results { get; set; }
    }

    public class SearchResultUtil {
        public static SearchResult from_json(Json.Node root)
        {
            var search = Json.gobject_deserialize (typeof (SearchResult), root) as SearchResult;
            
            var array = root.get_object ().get_array_member ("results");
            foreach (unowned Json.Node item in array.get_elements ()) {
                Photo photo = PhotoUtil.one_from_json (item);
                if (photo != null) {
                    search.results.append (photo);
                }
            }            
            return search;
        }

        public static Json.Node from_object(SearchResult search)
        {
            return Json.gobject_serialize (search);
        }
    }
}
