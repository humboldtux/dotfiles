source blt.nu
source github.nu
source virtualbox.nu
source nu-getent.nu

def "nu-complete ip-devices" [] {
  /sys/class/net/ | get name | path basename
}

# Show dev ip
def "ip show" [
  dev?: string@"nu-complete ip-devices" # device to show
] {
	ip a s $dev | grep 'inet ' | awk '{print $2}' | awk -F '/' '{print $1}'
}

# mkdir then cd into
def "mkcd" [
  dir: string # dir to create
] {
	mkdir $dir
  cd $dir
}

# Trigger alarm
def "teatime" [
  duration: duration # Duration
] {
  sleep $duration ; paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga; notify-send "Tea Time!"
}

def "video cut" [
  video:  string # Video to cut
  start:  string # Start of cut
  end:    string # End of cut
] {
  ffmpeg -i $video -ss $start -to $end -vcodec copy -acodec copy $"cut-($video)"
}

def meteo [
  location? = "Nice"
] {
	curl $"http://wttr.in/($location)?lang=fr"

	curl $"http://v2.wttr.in/($location)?lang=fr"
}

def "cat_vid" [video: string] {
	let output = '/tmp/tmp.jpg'
	ffmpegthumbnailer -i $video -o $output -s 0
	cat_img $output
}

def transfer [file: string] {
	curl --progress-bar --upload-file $file $"https://transfer.sh/(echo $file | path basename)"
}
