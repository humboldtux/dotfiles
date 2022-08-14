def "blt pair" [] {
	sudo rfkill unblock bluetooth
	bluetoothctl power on
	bluetoothctl scan on
	DEVICE=$(printf "Soundcore Life Q30 AC:12:2F:9B:3B:6B\nSoundcore Life Q35 AC:12:2F:5D:A5:E6" | fzf)
	DEV=$(echo "$DEVICE" | awk '{print $NF}')
	bluetoothctl trust "$DEV"
	bluetoothctl pair "$DEV"
}

def "blt connect" [] {
	bluetoothctl power on
	let device = (bluetoothctl devices | fzf | awk '{print $2}' | str trim)
	bluetoothctl connect $device
}

def "blt disconnect" [] {
  bluetoothctl disconnect
  bluetoothctl power off
}
