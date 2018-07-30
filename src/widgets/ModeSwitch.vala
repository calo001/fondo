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

public class ModeSwitch : Gtk.Grid {
    /**
     * Whether the {@link Gtk.Switch} widget is pointing to the secondary icon or not.
     */
    public bool active { get; set; }

    /**
     * The icon name to use for the primary icon for the switch.
     */
    public string primary_icon_name { get; construct set; }

    /**
     * The contents of the tooltip on the primary icon.
     */
    public string primary_icon_tooltip_text { get; set; }

    /**
     * The icon name to use for the secondary icon for the switch.
     */
    public string secondary_icon_name  { get; construct set; }

    /**
     * The contents of the tooltip on the secondary icon.
     */
    public string secondary_icon_tooltip_text { get; set; }

    /**
     * Constructs a new {@link Granite.ModeSwitch}.
     *
     * @param primary_icon_name The icon name to use for the primary icon for the switch.
     * @param secondary_icon_name The icon name to use for the secondary icon for the switch.
     */
    public ModeSwitch (string primary_icon_name, string secondary_icon_name) {
        Object (
            primary_icon_name: primary_icon_name,
            secondary_icon_name: secondary_icon_name
        );
    }

    construct {
        var primary_icon = new Gtk.Image ();
        primary_icon.pixel_size = 16;

        var primary_icon_box = new Gtk.EventBox ();
        primary_icon_box.add_events (Gdk.EventMask.BUTTON_RELEASE_MASK);
        primary_icon_box.add (primary_icon);

        var mode_switch = new Gtk.Switch ();
        mode_switch.valign = Gtk.Align.CENTER;
        mode_switch.get_style_context ().add_class ("mode-switch");

        var secondary_icon = new Gtk.Image ();
        secondary_icon.pixel_size = 16;

        var secondary_icon_box = new Gtk.EventBox ();
        secondary_icon_box.add_events (Gdk.EventMask.BUTTON_RELEASE_MASK);
        secondary_icon_box.add (secondary_icon);

        column_spacing = 6;
        add (primary_icon_box);
        add (mode_switch);
        add (secondary_icon_box);

        bind_property ("primary-icon-name", primary_icon, "icon-name", GLib.BindingFlags.SYNC_CREATE);
        bind_property ("primary-icon-tooltip-text", primary_icon, "tooltip-text");
        bind_property ("secondary-icon-name", secondary_icon, "icon-name", GLib.BindingFlags.SYNC_CREATE);
        bind_property ("secondary-icon-tooltip-text", secondary_icon, "tooltip-text");

        this.notify["active"].connect (() => {
            if (Gtk.StateFlags.DIR_RTL in get_state_flags ()) {
                mode_switch.active = !active;
            } else {
                mode_switch.active = active;
            }
        });

        mode_switch.notify["active"].connect (() => {
            if (Gtk.StateFlags.DIR_RTL in get_state_flags ()) {
                active = !mode_switch.active;
            } else {
                active = mode_switch.active;
            }
        });

        primary_icon_box.button_release_event.connect (() => {
            active = false;
            return Gdk.EVENT_STOP;
        });

        secondary_icon_box.button_release_event.connect (() => {
            active = true;
            return Gdk.EVENT_STOP;
        });
    }
}
