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
if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 && ! pgrep polkit-gnome-aut) ; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi
# Music
#run mpd ~/.config/mpd/mpd.conf

# Emacs daemon
run emacs --daemon

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

# Network manager tray icon
run nm-applet

# Keyboard
#setxkbmap -layout "us,gr" -option "grp:alt_shift_toggle"
#setxkbmap -layout "us,gr,ru" -option "grp:alt_shift_toggle"

# Caps Lock is Escape (Escape remains as is)
setxkbmap -option caps:swapescape
run xcape -t 250 -e 'Alt_L=Shift_L|4;Alt_R=Shift_R|5;Shift_L=parenleft;Shift_R=parenright'
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
