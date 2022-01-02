def nudown [] {fetch https://api.github.com/repos/nushell/nushell/releases | get assets | select name download_count}
def nuver [] {version | pivot key value}
# Download video and audio at the highest quality
alias dlv = 'youtube-dl -iwcR infinite --add-metadata'
alias dla = 'youtube-dl -xwicR infinite -f bestaudio --audio-quality 0 --add-metadata'


# A greeting command that can greet the caller
def greet [
  name: string      # The name of the person to greet
  --age (-a): int   # The age of the person
] {
  echo $name $age
}
