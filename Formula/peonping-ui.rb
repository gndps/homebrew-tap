# Template rendered by .github/workflows/release.yml into gndps/homebrew-tap.
# https://github.com/gndps/peonping-ui/archive/refs/tags/v0.1.0.tar.gz and e7b1175a27565768e4cf8a2a5f3b4c004546625d3cd4d279d02cd474bce09486 are substituted at release time.
class PeonpingUi < Formula
  desc "Local web UI to browse, mix, edit and install OpenPeon (peon-ping) sound packs"
  homepage "https://github.com/gndps/peonping-ui"
  url "https://github.com/gndps/peonping-ui/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e7b1175a27565768e4cf8a2a5f3b4c004546625d3cd4d279d02cd474bce09486"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "build"
    libexec.install "build"

    (bin/"peonping-ui").write <<~SH
      #!/bin/bash
      export PORT="${PORT:-47653}"
      export HOST="${HOST:-127.0.0.1}"
      URL="http://localhost:${PORT}/"
      if [ -z "${PEONPING_NO_OPEN:-}" ] && command -v open >/dev/null 2>&1; then
        ( sleep 1.5; open "$URL" ) &
      fi
      echo "PeonPing UI running at $URL  (Ctrl-C to stop)"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/build/index.js"
    SH
  end

  def caveats
    <<~EOS
      Start the app with:
        peonping-ui
      then open http://localhost:47653 (opens automatically on macOS).

      PeonPing UI drives the existing peon-ping CLI, so install it first:
        https://github.com/PeonPing/peon-ping

      Optional features need extra tools on your PATH:
        brew install yt-dlp ffmpeg   # YouTube clipping, compression, trimming
      ElevenLabs TTS just needs your API key, entered in the app.
    EOS
  end

  test do
    assert_path_exists libexec/"build/index.js"
  end
end
