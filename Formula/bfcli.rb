class Bfcli < Formula
  desc "A simple shell file sourcing manager"
  homepage "https://github.com/gndps/bfcli"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.2/bfcli-aarch64-apple-darwin.tar.xz"
      sha256 "e69c7a3460e78a09dcb42b0f5fca9c92fdbdb29e322755b9426f3c87e42ddc18"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.2/bfcli-x86_64-apple-darwin.tar.xz"
      sha256 "a0a6e41c21d5fe47977c50348cf32902f9cfcbd1678fe92999f13a4a2bafd9e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.2/bfcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e5b4f1d9b0030e6bf3e290ba52fea65b8231db7a82ec0d0da9e558d30b6d1fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.2/bfcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "694bf765baf89d5b53c453e93f8fcdbfd5fb764e971b09f0aa21f3baeb845b17"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "bfcli" if OS.mac? && Hardware::CPU.arm?
    bin.install "bfcli" if OS.mac? && Hardware::CPU.intel?
    bin.install "bfcli" if OS.linux? && Hardware::CPU.arm?
    bin.install "bfcli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
