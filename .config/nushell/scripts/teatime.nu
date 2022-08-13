# Trigger alarm
def "teatime" [
  duration: duration # Duration
] {
  sleep $duration ; paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga; notify-send "Tea Time!"
}
