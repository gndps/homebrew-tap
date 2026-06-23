class Appendrc < Formula
  desc "Manage and time shell sourcable files"
  homepage "https://github.com/gndps/appendrc"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.1/appendrc-aarch64-apple-darwin.tar.xz"
      sha256 "e6951af164e9d2cf3e1662cce3628cce4286af142432582c10ce53e85ac2a2a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.1/appendrc-x86_64-apple-darwin.tar.xz"
      sha256 "0c8bb6e3e2543a05e99c964c52d9f40ea5e569fe2f8ddc3fc33c358f41b2c2f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.1/appendrc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9777b447beb63d018060eb0d7fd37ec2191075c4c5049e6a608f6da67146ab2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.1/appendrc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09b0fd34d045e2783c70a6cb8da21e3ece30b9d9d4f7750e889577d4f2cd00bc"
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
