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

    [DBus (name = "org.freedesktop.DisplayManager.AccountsService")]
    public interface AccountsServiceUser : Object {
        [DBus (name = "BackgroundFile")]
        public abstract string background_file { owned get; set; }
    }

    /**
     * The {@code AccountService} used to provide AccountService
     *
     * @since 1.3.8
     */
    public class AccountServiceProvider {

        /**
         * This static property represents the {@code Settings} type.
         */
        private static AccountsServiceUser? instance = null;

        private AccountServiceProvider () {
            
        }

        /**
         * Returns a single instance of this class.
         * 
         * @return {@code AccountsServiceUser}
         */
        public static unowned AccountsServiceUser? get_instance () {
            if (instance == null) {
                try {
                    string uid = "%d".printf ((int) Posix.getuid ());
                    instance = Bus.get_proxy_sync (BusType.SYSTEM,
                            "org.freedesktop.Accounts",
                            "/org/freedesktop/Accounts/User" + uid);
                } catch (Error e) {
                    warning (e.message);
                }
            }

            return instance;
        }
    }
}
