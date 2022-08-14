source github.nu
source virtualbox.nu
source nu-getent.nu

# Trigger alarm
def "teatime" [
  duration: duration # Duration
] {
  sleep $duration ; paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga; notify-send "Tea Time!"
}
