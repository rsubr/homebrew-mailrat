cask "mailrat" do
  version "0.1.0"
  sha256 "02a7c9597012668d6e3275bf0204eea7000ebb7949374ff8edc88c0617988265"

  url "https://github.com/rsubr/mailrat/releases/download/v#{version}/mailrat-macos-arm64.zip"
  name "mailrat"
  desc "Native Gmail desktop client with TUI and CLI"
  homepage "https://github.com/rsubr/mailrat"

  depends_on arch: :arm64

  app "mailrat.app"
  binary "#{appdir}/mailrat.app/Contents/MacOS/mailrat"

  # The app is not yet signed or notarized; drop the quarantine flag so
  # Gatekeeper does not block the first launch. (Homebrew 7+ install steps.)
  postflight_steps do
    on_macos do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{appdir}}/mailrat.app"]
    end
  end
end
