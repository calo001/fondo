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

namespace App.Utils {
    public class WallpaperSettings : Granite.Services.Settings {
        public PictureMode picture_options { get; set; }

	    public string picture_uri { get; set; }

	    public string primary_color { get; set; }

	    public WallpaperSettings () {
		    base ("org.gnome.desktop.background");
	    }

	    protected override void verify (string key) {

		    switch (key) {

			    case "primary-color":
				    Gdk.Color bg;
				    if (!Gdk.Color.parse (primary_color, out bg))
					    primary_color = "#000000";
				    break;
		    }
	    }
    }

    public enum PictureMode {
	NONE = 0,
    WALLPAPER = 1,
	CENTERED = 2,
	SCALED = 3,
	STRETCHED = 4,
	ZOOMED = 5,
    TILED = 6;

	public void get_options (out bool stretch_x, out bool stretch_y, out bool center_x, out bool center_y) {

		switch (this) {

			case PictureMode.CENTERED:
				stretch_x = false;
				stretch_y = false;
				center_x = true;
				center_y = true;
				break;
			case PictureMode.SCALED:
				stretch_x = false;
				stretch_y = true;
				center_x = true;
				center_y = false;
				break;
			case PictureMode.STRETCHED:
				stretch_x = true;
				stretch_y = true;
				center_x = false;
				center_y = false;
				break;
			case PictureMode.ZOOMED:
				stretch_x = true;
				stretch_y = false;
				center_x = false;
				center_y = true;
				break;
			default:
				stretch_x = false;
				stretch_y = false;
				center_x = false;
				center_y = false;
				break;
		}
	}
}
}
