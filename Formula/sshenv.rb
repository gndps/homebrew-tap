class Sshenv < Formula
  desc "SSH key profile manager — switch between SSH key pairs"
  homepage "https://github.com/gndps/sshenv"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.2/sshenv-aarch64-apple-darwin.tar.xz"
      sha256 "1e24828aef8ad2224b9242f6c173cedfaddd7fdce4190e0482b1ae76302962c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.2/sshenv-x86_64-apple-darwin.tar.xz"
      sha256 "b8592f625596001e6654a96ebaa019e7482f9664ccad6b55ff3db4257c164a6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.2/sshenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "350e2a1a36c75e867493594cf9af4717eca65e8261eb9a2218bc9fb1f72bcf08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.2/sshenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "733f06ad63445a0de8f837e2aa855287908826908da5e770e1240e57d2da40b4"
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
