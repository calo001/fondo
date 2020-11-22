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

using App.Views;

namespace App.Widgets {

    /**
     * The {@code DownloadContainerWidget} class is responsible for displaying a download view 
     * using a progressbar and a message
     *
     */
    public class DownloadContainerWidget : Gtk.Grid {
        private Gtk.ProgressBar global_bar;

        public DownloadContainerWidget (string description) {
            var loading_spinner = new LoadingView ();

            var download_lbl = new Gtk.Label (description) {
                expand = true,
                margin_start = 8
            };
            download_lbl.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            global_bar = new Gtk.ProgressBar () {
                expand = true,
                margin_start = 8
            };
            global_bar.get_style_context ().add_class ("global_progress_bar");

            attach (loading_spinner,    0, 1, 1, 2);
            attach (download_lbl,       1, 1, 1, 1);
            attach (global_bar,         1, 2, 2, 1);
        }

        public void set_progress (double progress) {
            global_bar.set_fraction (progress);
        }
    }
}