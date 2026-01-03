class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.14/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "214f3d95c551a6a3084a8e9b3ab9083ac0bbdf38b5d0c8e27b1e0ec65b73a679"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.14/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "edfe7c59f9e2bd378c679e075eb7e32a7322c4852a8c173a87e172b1c73d497a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.14/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca80c4311bf8a5d1e0fefb2c15cdca4a9ca4eec1834d2ffaf9059f08164b2db0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.14/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a82da30931bb4be1e6225394bb1aa9614abe4ce501fdaa98ab8670e1f875dfbf"
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
