class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.4/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "9f71979ca49ddb9403da3c7a7f6f504b2674250c2b23dc10c90e2aecc9a8a64f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.4/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "c20cc7a381f83b8cde415fb1eb61e8063f17c362c58387177890c770f42c65ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.4/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fe0b038e81ffcf70ec7068d5629be2ef3a641a7d533730ec038d62ace848af2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.4/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51730cffd0fd0af0493a96b625cea5f5b1332abe6b4dade2ff03b4e27ae17ae9"
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
    bin.install "dotfiles_sync" if OS.mac? && Hardware::CPU.arm?
    bin.install "dotfiles_sync" if OS.mac? && Hardware::CPU.intel?
    bin.install "dotfiles_sync" if OS.linux? && Hardware::CPU.arm?
    bin.install "dotfiles_sync" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
