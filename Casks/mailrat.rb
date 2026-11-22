cask "mailrat" do
  version "0.2.4"
  sha256 "43cdf3b65012c078025d51a7c7bb67c0e62ff44c1e5e2d2637dbba47598146c6"

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
