#!/bin/bash
# aTrust tray launcher, installed as /usr/bin/atrust by this package.
#
# Lifecycle: start aTrustDaemon.service when it is not running, run the tray, stop the
# service again when the tray exits.
# Privileges: the daemon creates the tun device and installs fib rules, which needs
# CAP_NET_ADMIN in the host network namespace, so it is a root system service. Starting and
# stopping it is authorised through polkit: one authentication prompt per active session,
# cached for five minutes.
#
# Two preloads, both measured on the host:
#   * The bundled SQLCipher: inside the tray process Electron/Chromium pulls in the system
#     libsqlite3.so.0, whose sqlite3_* symbols collide with the bundled
#     resources/bin/libsqlite3.so and break its provider initialisation, so submitting an
#     address segfaults. Preloading the bundled copy keeps the client's sqlite3_* calls
#     inside the client.
#   * LD_LIBRARY_PATH: the bundled bin/ and lib/ directories take precedence over system
#     libraries of the same name.
set -u

APP=/usr/share/sangfor/aTrust
SVC=aTrustDaemon.service

export LD_LIBRARY_PATH="$APP/uem/bin:$APP/uem/lib:$APP/resources/bin:$APP/resources/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export LD_PRELOAD="$APP/resources/bin/libsqlite3.so${LD_PRELOAD:+ $LD_PRELOAD}"
export ELECTRON_IS_DEV=0
export ELECTRON_FORCE_IS_PACKAGED=true
export NODE_ENV=production

# Client and daemon share the state under /usr/share/sangfor/.aTrust; this is the umask the
# vendor's own tray script sets as well
umask u=rwx,g=rwx,o=rwx

# A tray is already running: its Electron single-instance lock takes over this start, and
# no service is touched
if pgrep -f "^$APP/aTrustTray --no-sandbox" >/dev/null; then
    exec "$APP/aTrustTray" --no-sandbox --disable-gpu "$@"
fi

if ! systemctl is-active --quiet "$SVC"; then
    if systemctl start "$SVC"; then
        # A forking start returns once aTrustAgent has forked; the plugin daemon behind it needs
        # a moment before the tray's first query, otherwise the client reports the core service
        # as not started
        sleep 2
    else
        printf 'atrust: could not start %s; authenticate the polkit prompt, or run "systemctl start %s" as root\n' "$SVC" "$SVC" >&2
        command -v notify-send >/dev/null 2>&1 &&
            notify-send -u critical atrust "$SVC is not running. Authenticate the polkit prompt, or run 'systemctl start $SVC' as root."
    fi
fi

cd "$APP" || exit 1
"$APP/aTrustTray" --no-sandbox --disable-gpu "$@"
rc=$?

if ! systemctl stop "$SVC"; then
    printf 'atrust: could not stop %s (polkit authentication cancelled?); the daemon keeps running\n' "$SVC" >&2
    command -v notify-send >/dev/null 2>&1 &&
        notify-send atrust "could not stop $SVC; the daemon keeps running"
fi
exit "$rc"
