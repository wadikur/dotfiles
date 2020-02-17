#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ICON=$DIR/bojackh.png
TMPBG=/tmp/screen.png
maim /tmp/screen.png
convert $TMPBG -scale 12% -scale 834% $TMPBG
#convert -blur 0x4 $TMPBG $TMPBG
convert $TMPBG $ICON -gravity South -composite -matte $TMPBG
i3lock -u -i $TMPBG
