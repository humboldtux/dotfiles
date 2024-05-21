# Install BurpSuite
def "mysetup desktop burp" [] {

  if ( ('/opt/BurpSuiteCommunity' | path type) != dir) and (($"($env.HOME)/BurpSuiteCommunity" | path type) != dir) {

    echo 'sys.adminRights$Boolean=true' | lines | save /tmp/response.varfile
    echo 'sys.fileAssociation.extensions$StringArray="burp"' | lines | save --append /tmp/response.varfile
    echo 'sys.fileAssociation.launchers$StringArray="70"' | lines | save --append /tmp/response.varfile
    echo 'sys.installationDir=/opt/BurpSuiteCommunity' | lines | save --append /tmp/response.varfile
    echo 'sys.languageId=en' | lines | save --append /tmp/response.varfile
    echo 'sys.programGroupDisabled$Boolean=false' | lines | save --append /tmp/response.varfile
    echo 'sys.symlinkDir=/usr/local/bin' | lines | save --append /tmp/response.varfile

    echo "Downloading BurpSuite"
    curl -sSL "https://portswigger.net/burp/releases/download?product=community&type=Linux" -o /tmp/burp.sh

    echo "Installation BurpSuite"
    sudo sh /tmp/burp.sh -q -varfile /tmp/response.varfile | ignore

    sudo chown root:root /opt/BurpSuiteCommunity/burpbrowser/*/chrome-sandbox
    sudo chmod u+s /opt/BurpSuiteCommunity/burpbrowser/*/chrome-sandbox

  }

}
