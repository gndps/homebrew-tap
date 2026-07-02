class Bfcli < Formula
  desc "A simple shell file sourcing manager"
  homepage "https://github.com/gndps/bfcli"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.6/bfcli-aarch64-apple-darwin.tar.xz"
      sha256 "8402f1d990fac5c028502368a482a2caeb4baf53aad9a10750a1ebbaf360ce78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.6/bfcli-x86_64-apple-darwin.tar.xz"
      sha256 "e3e6078c6aba5c1699127490af4d68e059b2bc96f78e6e23b5a3fa4cf80b149b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.6/bfcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b53040c027c3c62fdb457045898713bf8897f574a37650a38060d4d1ee22700"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.6/bfcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5583aa520234e7ee40e1187b6342b5c553b96bea424368d89598a3813a44cb1"
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
