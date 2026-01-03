class Dotfiles < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles/releases/download/v1.0.1/dotfiles-aarch64-apple-darwin.tar.xz"
      sha256 "daec6165800cf08ec330aed4da5be5a026f2f0ada667d9553f9a000f23a93b11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles/releases/download/v1.0.1/dotfiles-x86_64-apple-darwin.tar.xz"
      sha256 "56e740bd0b23e07b5c586ce3b284cab991f7347040f7dcf3cab50dd50a1ff52c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles/releases/download/v1.0.1/dotfiles-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "04784bfc377745820ad5f597fd04d3c7ad1a9f524278b59fec7b79c3f0fc0230"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles/releases/download/v1.0.1/dotfiles-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "337aa24a29f7c71946baa05199be279881fd49380e5406c93a95c9f5e406c62f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "dotfiles" if OS.mac? && Hardware::CPU.arm?
    bin.install "dotfiles" if OS.mac? && Hardware::CPU.intel?
    bin.install "dotfiles" if OS.linux? && Hardware::CPU.arm?
    bin.install "dotfiles" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
