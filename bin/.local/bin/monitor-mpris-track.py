import os
import dbus

try:
    from gi.repository import GLib
except ImportError:
    import glib as GLib

from dbus import Interface as DBusInterface
from dbus.mainloop.glib import DBusGMainLoop
from dbus.exceptions import DBusException
from enum import Enum

class DBusSignals(str, Enum):
    NameOwnerChanged = "NameOwnerChanged"
    PropertiesChanged = "PropertiesChanged"

    def __str__(self):
        return self.value

class Notifier:
    def __init__(self, bus):
        """Initialize connection to desired client"""
        
        if bus != None:
            self.notify_interface = DBusInterface(
                    object = bus.get_object(
                        "org.freedesktop.Notifications",
                        "/org/freedesktop/Notifications"),
                    dbus_interface = "org.freedesktop.Notifications")
    
    def notify(self, app_name = "", notif_id = 0, artUrl = "",
            title = "Notification:", body = "", actions = [], hints = {}, timeout = 0):
            
        processed_actions = actions if isinstance(actions, list) else []
        processed_hints = hints if isinstance(hints, dict) else {}

        self.notify_interface.Notify(
                app_name,
                notif_id,
                artUrl,
                title,
                body,
                dbus.Array(processed_actions, signature = 'as'),
                dbus.Dictionary(processed_hints, signature = 'si'),
                timeout)

class FirefoxMPRISWatcher(object):
    def __init__(self):
        """Initialize Mother Fucker!"""

        bus_loop = DBusGMainLoop(set_as_default = True)
        self.bus = dbus.SessionBus(mainloop = bus_loop)
        mainloop = GLib.MainLoop()
        self.notify_id = None
        self.previousTitle = ''
            
        # setup interfaces
        self.session_bus = self.bus.get_object(
                "org.freedesktop.DBus",
                "/org/freedesktop/DBus")

        
        self.notifier = Notifier(self.bus)
        self.firefox_mpris_client = self.get_connected_firefox_instance_name()

        try:
            self.props_changed_listener()
        except (DBusException):
            print("noop") # TODO: handle this better
            raise

        self.session_bus.connect_to_signal(
                DBusSignals.NameOwnerChanged,
                self.handle_name_owner_changed,
                arg0=self.firefox_mpris_client)

        mainloop.run()

    def get_connected_firefox_instance_name(self):
        return list(filter(lambda v: v.find("MediaPlayer2.firefox.instance") != -1,
            self.session_bus.ListNames()))[0]

    def props_changed_listener(self):
        """Hook up callback to PropertiesChanged event"""

        self.firefox = self.bus.get_object(
                self.firefox_mpris_client,
                "/org/mpris/MediaPlayer2")

        self.firefox.connect_to_signal(
                DBusSignals.PropertiesChanged,
                self.handle_properties_changed)

    def handle_name_owner_changed(self, name, older_owner, new_owner):
        """Introspect the NameOwnerChanged signal to work out if firefox mpris client has started"""

        if name == self.firefox_mpris_client:
            if new_owner and new_owner != older_owner:
                print('[MPRIS] registering new ff client ...')
                self.props_changed_listener()
            else:
                print('[MPRIS] ff client cleaning up ...')
                self.firefox = None
                self.previousTitle = ''

    def handle_properties_changed(self, interface, changed_props, invalidated_props):
        """Handle track changes"""

        metadata = changed_props.get("Metadata", {})

        if metadata:
            artUri = str(metadata.get('mpris:artUrl'))

            # current mpris client sends many on
            # change events (to update art uri, etc) .. we are using art uri state
            # check to ensure we aren't sending duplicate notifications
            # (NOTE: if art cannot be fetched, will not display notif)
            if artUri and artUri != 'None':
                title = str(metadata.get("xesam:title"))

                # avoid further duplications - if current title matches previous
                # title, don't notify
                if title != self.previousTitle:
                    album = str(metadata.get("xesam:album"))
                    artist = str(metadata.get("xesam:artist")[0])
                    self.previousTitle = title

                    self.notify_with_metadata(title, album, artist, artUri)

    def notify_with_metadata(self, title, album, artist, art):
        message_to_send = "{} - <i>{}</i>".format(title, artist)
        self.notifier.notify(title = "Now Playing:",
                body = message_to_send,
                artUrl = art)

if __name__ == "__main__":
    FirefoxMPRISWatcher()
