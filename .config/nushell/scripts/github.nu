# Get Github project latest version number
def "github latestversion" [
  project: string # Project name
] {
  curl -sSL -w "%{url_effective}\n" -I $"https://github.com/($project)/releases/latest" -o /dev/null | path basename
}

# Get Github project latest downloads url
def "github latestdownloads" [
  project: string # Project name
] {
  (http get $"https://api.github.com/repos/($project)/releases/latest").assets.browser_download_url
}

# Get Github project latest download url given a pattern
def "github latestdownload" [
  project: string # Project name
  pattern: string # Pattern to search for
] {
  github latestdownloads $project | where $it =~ $pattern
}
