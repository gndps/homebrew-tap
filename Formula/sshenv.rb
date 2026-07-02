class Sshenv < Formula
  desc "SSH key profile manager — switch between SSH key pairs"
  homepage "https://github.com/gndps/sshenv"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.7/sshenv-aarch64-apple-darwin.tar.xz"
      sha256 "228c0338d6945040a68bf5ecc3125659c155d2bab6d74c18dbfe249f40a68e27"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.7/sshenv-x86_64-apple-darwin.tar.xz"
      sha256 "327bf743c5c75c68c52fae71bd0282260f762590e7356924c655aa0322049174"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.7/sshenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f217b09cc225dcc6507d5d60f1380855dae4bec64670f3df58d03523ee03734f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.7/sshenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3289162316c6e04b86524244662ec7f515fc5e53af68a065e3f46da3eaac5241"
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
