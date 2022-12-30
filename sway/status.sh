# Date and time
day=$(date "+%a")
date_and_week=$(date "+%Y.%m.%d")
current_time=$(date "+%H:%M:%S")

# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

# Brightness
current_brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)
decimal_brightness=$(echo "scale=3; $current_brightness/$max_brightness" | bc)
brightness=$(echo "scale=0; $decimal_brightness*100/1" | bc)

# Volume
volume=$(echo `(pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume:") | awk '{print $5}'`)
mute_value=$(echo `(pactl get-sink-mute @DEFAULT_SINK@ | grep "Mute:") | awk '{print $2}'`)
if [ "$mute_value" = "yes" ]; then
  volume="$volume [MUTE]"
else
  volume="$volume"
fi

# Microphone
mic_value=$(echo `(pactl get-source-mute @DEFAULT_SOURCE@ | grep "Mute:") | awk '{print $2}'`)
if [ "$mic_value" = "yes" ]; then
  mic="DISABLED"
else
  mic="ENABLED"
fi

echo "Mic:" $mic "|" "Vol:" $volume "|" "BRT:" $brightness"%" "|" $battery_status $battery_charge "|" "["$day"]" $date_and_week $current_time
