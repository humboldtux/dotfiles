# Get Github project latest version number
def "github latestversion" [
  project: string # Project name
] {
  (fetch $"https://api.github.com/repos/($project)/releases/latest").name
}

# Get Github project latest downloads url
def "github latestdownloads" [
  project: string # Project name
] {
  (fetch $"https://api.github.com/repos/($project)/releases/latest").assets.browser_download_url
}
