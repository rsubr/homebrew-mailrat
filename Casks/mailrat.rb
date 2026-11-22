cask "mailrat" do
  version "0.1.0"
  sha256 "02a7c9597012668d6e3275bf0204eea7000ebb7949374ff8edc88c0617988265"

  # The source repo is private, so the zip is fetched through the GitHub API
  # asset endpoint using HOMEBREW_GITHUB_API_TOKEN (a token with `repo` scope).
  url "https://api.github.com/repos/rsubr/mailrat/releases/assets/777908934",
      header: [
        "Accept: application/octet-stream",
        "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN") do
          odie "Set HOMEBREW_GITHUB_API_TOKEN to a GitHub token with repo access to install mailrat"
        end}",
      ]
  name "mailrat"
  desc "Native Gmail desktop client with TUI and CLI"
  homepage "https://github.com/rsubr/mailrat"

  depends_on arch: :arm64

  app "mailrat.app"
  binary "#{appdir}/mailrat.app/Contents/MacOS/mailrat"

  # The app is not yet signed or notarized; drop the quarantine flag so
  # Gatekeeper does not block the first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/mailrat.app"]
  end
end
