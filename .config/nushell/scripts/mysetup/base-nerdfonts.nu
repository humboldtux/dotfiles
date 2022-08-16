# Install Nerd Fonts
def "mysetup base nerdfonts" [] { 

    let font = 'JetBrainsMono'
    echo $"Installing Nerd Fonts ($font)"
    mkdir $"/tmp/nerd-fonts/patched-fonts/($font)"
    github latestdownloads ryanoasis/nerd-fonts | where $it =~ $font | to text | fetch -b $in -o $"/tmp/($font).zip"
    unzip -x  /tmp/JetBrainsMono.zip -d $"/tmp/nerd-fonts/patched-fonts/($font)/"
    cd /tmp/nerd-fonts
    wget -q https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh
    bash install.sh $font

}
