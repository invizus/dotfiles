#!/usr/bin/env python3
import subprocess
import gi
gi.require_version("Gtk", "4.0")
gi.require_version("Gdk", "4.0")
from gi.repository import Gtk
from gi.repository import Gdk

def get_sinks():
    output = subprocess.run(['wpctl', 'status'], capture_output=True, text=True).stdout
    sinks = []
    in_sink_block = False

    for line in output.splitlines():
        line = line.strip()

        if 'Sinks:' in line:
            in_sink_block = True
            continue

        if in_sink_block and (line.startswith('Sources:') or not line):
            break

        if in_sink_block:
            try:
                line = line.replace('│', '').replace('├', '').replace('─', '').strip()
                if line.startswith('*'):
                    line = line[1:].strip()
                if '. ' not in line:
                    continue

                id_part, rest = line.split('. ', 1)
                id_ = int(id_part.strip())
                name = rest.split('[')[0].strip()

                vol = 1.0
                muted = False

                if 'vol:' in rest:
                    vol_section = rest.split('vol:')[1].split(']')[0].strip()
                    vol_str = vol_section.split()[0]
                    vol = float(vol_str)
                    muted = 'MUTED' in vol_section.upper()


                sinks.append((id_, name, vol, muted))
            except Exception as e:
                print(f"Failed to parse sink line: {line}\nError: {e}")
                continue

    return sinks


class VolumePopup(Gtk.Window):
    def __init__(self):
        super().__init__(title="Volume Control")
        self.set_default_size(300, 300)
        self.set_resizable(False)
        self.set_modal(True)
        self.set_hide_on_close(True)

        # Add ESC key event controller
        controller = Gtk.EventControllerKey.new()
        controller.connect("key-pressed", self.on_key_pressed)
        self.add_controller(controller)


        container = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL,
            spacing=12,
            margin_top=12,
            margin_bottom=12,
            margin_start=12,
            margin_end=12
        )
        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled.set_child(container)
        self.set_child(scrolled)


        for sink_id, name, volume, muted in get_sinks():
            label = Gtk.Label(label=name, xalign=0)

            slider = Gtk.Scale.new_with_range(Gtk.Orientation.HORIZONTAL, 0.0, 1.0, 0.01)
            slider.set_value(volume)
            slider.set_hexpand(True)
            slider.set_draw_value(False)
            slider.connect("value-changed", self.on_slider_changed, sink_id)

            mute_toggle = Gtk.CheckButton(label="Mute")
            mute_toggle.set_active(muted)
            mute_toggle.connect("toggled", self.on_mute_toggled, sink_id)

            row = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
            row.append(label)
            row.append(slider)
            row.append(mute_toggle)
            container.append(row)

        # Add Close button
        close_button = Gtk.Button(label="Close")
        close_button.connect("clicked", lambda button: self.get_application().quit())

        container.append(close_button)

    def on_key_pressed(self, controller, keyval, keycode, state):
        if keyval == Gdk.KEY_Escape:
            self.get_application().quit()
            return True
        return False

    def on_slider_changed(self, slider, sink_id):
        vol = slider.get_value()
        subprocess.run(["wpctl", "set-volume", str(sink_id), f"{vol:.2f}"])

    def on_mute_toggled(self, button, sink_id):
        mute = button.get_active()
        subprocess.run(["wpctl", "set-mute", str(sink_id), "1" if mute else "0"])

def main():
    app = Gtk.Application(application_id="com.example.VolumePopup")

    def on_activate(app):
        win = VolumePopup()
        win.set_application(app)
        win.present()

    print("Detected sinks:", get_sinks())

    app.connect("activate", on_activate)
    app.run(None)

if __name__ == "__main__":
    main()

