class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.6/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "80eedda8e7af0d064803eb17b7cc41a3d16d1df61bd844c069c7838f1adef608"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.6/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "130ce20acc34df4d3bd6d82f0a97c62b119042fe65f82591fba8ae7826969df9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.6/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84310fddcaf7b1ad991f32dcef94af5b4e0c88fb32e00aaae5ed1acf49239d73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.6/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3cb1f32b44e44db35bd35c28ac9a1b0b035404b3e2e6540b343862eeacd09d23"
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
