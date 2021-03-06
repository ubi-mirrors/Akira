/*
* Copyright (c) 2019-2020 Alecaddd (https://alecaddd.com)
*
* This file is part of Akira.
*
* Akira is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.

* Akira is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with Akira. If not, see <https://www.gnu.org/licenses/>.
*
* Authored by: Alessandro "Alecaddd" Castellani <castellani.ale@gmail.com>
*/

public class Akira.Partials.ColorField : Gtk.Entry {
    public weak Akira.Window window { get; construct; }

    public ColorField (Akira.Window window) {
        Object (
            window: window
        );
    }

    construct {
        margin_end = 10;
        width_chars = 8;
        max_length = 7;
        hexpand = true;

        focus_in_event.connect (handle_focus_in);
        focus_out_event.connect (handle_focus_out);

        insert_text.connect ((_new_text, new_text_length) => {
            string new_text = _new_text.strip ();

            if (new_text.contains ("#")) {
                new_text = new_text.substring (1, new_text.length - 1);
            } else if (!this.text.contains ("#")) {
                GLib.Signal.stop_emission_by_name (this, "insert-text");

                var builder = new StringBuilder ();
                builder.append (new_text);
                builder.prepend ("#");
                this.text = builder.str;
            }

            bool is_valid_hex = true;
            bool char_is_numeric = true;
            bool char_is_valid_alpha = true;

            char keyval;

            for (var i = 0; i < new_text.length; i++) {
                keyval = new_text [i];

                char_is_numeric = keyval >= Gdk.Key.@0 && keyval <= Gdk.Key.@9;
                char_is_valid_alpha = keyval >= Gdk.Key.A && keyval <= Gdk.Key.F;

                is_valid_hex &= keyval.isxdigit ();
            }

            if (!is_valid_hex) {
                GLib.Signal.stop_emission_by_name (this, "insert-text");
                return;
            }
        });
    }

    private bool handle_focus_in (Gdk.EventFocus event) {
        window.event_bus.disconnect_typing_accel ();
        return false;
    }

    private bool handle_focus_out (Gdk.EventFocus event) {
        window.event_bus.connect_typing_accel ();
        return false;
    }
}
