xrandr \
    --output DP-1 --off \
    --output VGA-1 --off \

if xrandr --query | grep "HDMI-1 connected"
then
    xrandr \
        --output HDMI-1 --auto --primary \
        --output eDP-1 --auto --below HDMI-1 \

else
    xrandr \
        --output HDMI-1 --off \
        --output eDP-1 --auto --primary \

fi
