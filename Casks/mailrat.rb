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

  # Graceful quit before the app bundle is replaced (sends Apple quit event,
  # waits for exit; Homebrew only falls back to TERM/KILL if this times out).
  uninstall quit: "com.mailrat.app"

  # Runs before the quit above. Records whether the GUI app was running so
  # postflight can relaunch it. -x with an anchored pattern matches only the
  # bare GUI process, not `mailrat tui` or other CLI invocations.
  uninstall_preflight do
    flag = "/tmp/.mailrat-was-running"
    File.delete(flag) if File.exist?(flag)
    running = system_command("/usr/bin/pgrep",
                             args:         ["-xf", ".*mailrat\\.app/Contents/MacOS/mailrat$"],
                             print_stderr: false)
    system_command "/usr/bin/touch", args: [flag] if running.exit_status.zero?
  end

  postflight do
    flag = "/tmp/.mailrat-was-running"
    if File.exist?(flag)
      File.delete(flag)
      system_command "/usr/bin/open", args: ["-a", "#{appdir}/mailrat.app"]
    end
  end

  # The app is not yet signed or notarized; drop the quarantine flag so
  # Gatekeeper does not block the first launch. (Homebrew 7+ install steps.)
  postflight_steps do
    on_macos do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{appdir}}/mailrat.app"]
    end
  end
end
