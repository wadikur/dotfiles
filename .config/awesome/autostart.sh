#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of AwesomeWM
# TODO: run_once

function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

## run (only once) processes which spawn with different name
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi
if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi

if (command -v system-config-printer-applet && ! pgrep applet.py ); then
    system-config-printer-applet &
fi


# Music
#run mpd ~/.config/mpd/mpd.conf

# Emacs daemon
# run emacs --daemon

# Load terminal colorscheme and settings
#xrdb ~/.Xresources

# Urxvt daemon
#run urxvtd -q -o -f

# Mpv input file
#mkfifo /tmp/mpv.fifo

# For desktop effects
run compton --config ~/.config/compton/compton.conf

# Enable numlock on login
run numlockx
run pa-applet
run pamac-tray

# For battery notifications
 run xfce4-power-manager
#run autolock
run xautolock -time 8 -locker $HOME/.personalConfig/cool_lockscreen/lock.sh 
#run xidlehook --not-when-fullscreen --not-when-audio --timer 60 "$HOME/.personalConfig/cool_lockscreen/lock.sh" ""
# Network manager tray icon
run nm-applet

run redshift

run conky conky
# Keyboard
#setxkbmap -layout "us,gr" -option "grp:alt_shift_toggle"
#setxkbmap -layout "us,gr,ru" -option "grp:alt_shift_toggle"

# Caps Lock is Escape (Escape remains as is)
setxkbmap -option caps:swapescape
# Kill redshift processes
# pkill redshift

# Scratchpad
#scratchpad

# Update battery status and send signals
CHARGING="$(udevadm info --path=/sys/class/power_supply/BAT0 | grep POWER_SUPPLY_STATUS | grep Charging)"
if [ ${#CHARGING} -eq "0" ]; then
    AWESOME_SIGNAL="charger_unplugged"
else
    AWESOME_SIGNAL="charger_plugged"
fi
awesome-client "awesome.emit_signal(\"$AWESOME_SIGNAL\")"


#SSH-agent auto run
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
# fi
# if [[ ! "$SSH_AUTH_SOCK" ]]; then
#     eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")"
# fi
eval $(keychain --eval --agents ssh github_rsa)



