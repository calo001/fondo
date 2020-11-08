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
using App.Models;

namespace App.Dock {
    public void start () {
        progress_dock_visibility (true);
    }

    public void stop () {
        progress_dock_visibility (false);
    }

    private void progress_dock_visibility (bool visible) {
        Granite.Services.Application.set_progress_visible.begin (visible, (obj, res) => {
            try {
                Granite.Services.Application.set_progress_visible.end (res);
            } catch (GLib.Error e) {
                critical (e.message);
            }
        });
    }

    private void update_dock_progress (double progress) {
        Granite.Services.Application.set_progress.begin (progress, (obj, res) => {
            try {
                Granite.Services.Application.set_progress.end (res);
            } catch (GLib.Error e) {
                GLib.critical (e.message);
            }
        });
    }
}
    