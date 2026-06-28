class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.6.0/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "fbdd1c192961e82db087969b6c0cac5b12706f37d2a7b3b5721bb338879dbd34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.6.0/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "7c18cf888f20cb02a1789cc860055c98179844c89b74d564fa7b62e9c7510515"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.6.0/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b912eae783343bb7699e4049375e0d9bcfd6aecca124a0dacd8e55457af0efb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.6.0/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0cb84c357d395642c209d7c80d7ef12b30269636781477de60c7996f3d162044"
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
