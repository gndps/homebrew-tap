class Sshenv < Formula
  desc "SSH key profile manager — switch between SSH key pairs"
  homepage "https://github.com/gndps/sshenv"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.1/sshenv-aarch64-apple-darwin.tar.xz"
      sha256 "c44a7ad8d87b975dbbd24a1c5d00bdac2018df2b41173cdb25885a049586b6b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.1/sshenv-x86_64-apple-darwin.tar.xz"
      sha256 "9fcccbabc7937df2e474777ecfec189121b53a76387853dbb4ed3765853bbf17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.1/sshenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6e6679530b59841d7f336ad581a6470622b9bd34c9891d7c511f3ba3ee620c98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.1/sshenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "582002a433ce0a0817e5e9a1e4d5efe169ea3b146735ce5729dbbf630bbdb0eb"
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
    bin.install "sshenv" if OS.mac? && Hardware::CPU.arm?
    bin.install "sshenv" if OS.mac? && Hardware::CPU.intel?
    bin.install "sshenv" if OS.linux? && Hardware::CPU.arm?
    bin.install "sshenv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
