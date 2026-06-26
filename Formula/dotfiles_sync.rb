class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.5.0/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "0d960f71f93d3c2a569addd3a3d15f67adb549633f1bc182806dad80703ee978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.5.0/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "c1487674381ab2d9e4c3a8ebc33e35e3baf97d21cfc22b729dfaf1cf5888dbc0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.5.0/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "20c4c315fdf07cc000a090f3f15355b8ee2fce32f46ce53e09f79f9700d1389a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.5.0/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "632dde728f08f4e324d702a7227336e45c51ffa3b634f24cff0851061b2af7d2"
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
