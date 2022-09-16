def "blt install" [] {
	sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq bluetooth bluez bluez-tools rfkill pulseaudio-module-bluetooth
	sudo sed -i s/AutoEnable=true/AutoEnable=false/g /etc/bluetooth/main.conf
	sudo rfkill unblock bluetooth
	sudo systemctl --quiet restart bluetooth.service
	sudo systemctl --quiet enable bluetooth.service
	#sudo usermod -aG lp $env.USER
	sudo adduser $env.USER lp
	newgrp lp	
}

def "blt scan" [] {
	sudo rfkill unblock bluetooth
	bluetoothctl power on
	bluetoothctl scan on
}

def "blt pair" [] {
	let device = (echo "Soundcore Life Q30 AC:12:2F:9B:3B:6B\nSoundcore Life Q35 AC:12:2F:5D:A5:E6" | fzf)
	let dev = (echo $device | awk '{print $NF}' | str trim)
	bluetoothctl trust $dev
	bluetoothctl pair $dev
}

def "blt connect" [] {
	bluetoothctl power on
	let device = (bluetoothctl devices | str trim | fzf)
	let dev = ( $device | awk '{print $2}' | str trim)
	bluetoothctl connect $dev
}

def "blt disconnect" [] {
	bluetoothctl disconnect
	bluetoothctl power off
}
