class Appendrc < Formula
  desc "Manage and time shell sourcable files"
  homepage "https://github.com/gndps/appendrc"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.3/appendrc-aarch64-apple-darwin.tar.xz"
      sha256 "afc5ba3e04299a549118d29a98e464d22075821a69ffcc2ef12dfabc4875a7b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.3/appendrc-x86_64-apple-darwin.tar.xz"
      sha256 "5e8709e3fde28b6636c5d014391e199367d0ddcccf273bd6d997e8aa03f5ebe4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.3/appendrc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9366c8cac62daf0ce06c9a5b75279c84ca6f1d7d70e13ff1d72184f26f3c5685"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.3/appendrc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d7e53ba52faf64ff48abd447752164835f63ef9f372189770e83ebf3344aa835"
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
    bin.install "appendrc" if OS.mac? && Hardware::CPU.arm?
    bin.install "appendrc" if OS.mac? && Hardware::CPU.intel?
    bin.install "appendrc" if OS.linux? && Hardware::CPU.arm?
    bin.install "appendrc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
