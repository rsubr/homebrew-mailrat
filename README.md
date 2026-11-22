# homebrew-mailrat

Homebrew tap for [mailrat](https://github.com/rsubr/mailrat), a native Gmail desktop client (Apple silicon).

```sh
brew tap rsubr/mailrat
brew install --cask mailrat
```

This installs `mailrat.app` and puts the `mailrat` command (TUI and CLI) on your `PATH`.

## Updating the cask for a new release

1. Tag `vX.Y.Z` in rsubr/mailrat; CI publishes `mailrat-macos-arm64.zip` and its `.sha256`.
2. In `Casks/mailrat.rb` set `version` and `sha256` (from the `.sha256` asset).
