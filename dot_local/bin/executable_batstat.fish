#!/usr/bin/env fish

if [ "$(cat /sys/class/power_supply/BAT*/status)" = Charging ]
    set bolt "⚡"
end

set charge_now (cat /sys/class/power_supply/BAT*/charge_now)
set charge_full (cat /sys/class/power_supply/BAT*/charge_full)

if [ -z "$charge_now" ]
    exit
end

set percentage (math "$charge_now * 100 / $charge_full" | cut --delimiter '.' --fields 1)

echo "$bolt$percentage%"
