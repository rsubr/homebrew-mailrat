cask "mailrat" do
  version "0.3.6"
  sha256 "315794c517e6ff1e60848bc2cb333d573d9e5ab5a48e7ea5c481a33be842f959"

  url "https://github.com/rsubr/mailrat/releases/download/v#{version}/mailrat-macos-arm64.zip"
  name "mailrat"
  desc "Native Gmail desktop client with TUI and CLI"
  homepage "https://github.com/rsubr/mailrat"

  depends_on arch: :arm64
  depends_on :macos

  app "mailrat.app"
  binary "#{appdir}/mailrat.app/Contents/MacOS/mailrat"

  # The app is not yet signed or notarized; drop the quarantine flag so
  # Gatekeeper does not block the first launch. Also relaunches the app after
  # an upgrade if it was running beforehand (flag set by the preflight below).
  postflight_steps do
    on_macos do
      run "/usr/bin/xattr",
          args: ["-dr", "com.apple.quarantine", "{{appdir}}/mailrat.app"]
    end
    if_path_exists "/tmp/.mailrat-was-running" do
      remove "/tmp/.mailrat-was-running"
      run "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister",
          args:         ["-f", "{{appdir}}/mailrat.app"],
          must_succeed: false
      run "/usr/bin/open", args: ["-a", "{{appdir}}/mailrat.app"], must_succeed: false
    end
  end

  # Runs before the quit below. Records whether the GUI app was running so
  # postflight can relaunch it. -x with an anchored pattern matches only the
  # bare GUI process, not `mailrat tui` or other CLI invocations.
  uninstall_preflight_steps do
    if_path_exists "/tmp/.mailrat-was-running" do
      remove "/tmp/.mailrat-was-running"
    end
    run "/bin/sh",
        args:           ["-c", "/usr/bin/pgrep -xf '.*mailrat\\.app/Contents/MacOS/mailrat$' " \
                               "&& /usr/bin/touch /tmp/.mailrat-was-running"],
        must_succeed:   false,
        print_stderr:   false,
        writable_paths: ["/tmp/.mailrat-was-running"]
  end

  # Graceful quit before the app bundle is replaced (sends Apple quit event,
  # waits for exit; Homebrew only falls back to TERM/KILL if this times out).
  uninstall quit:   "com.mailrat.app",
            signal: [["TERM", "com.mailrat.app"]]
end
