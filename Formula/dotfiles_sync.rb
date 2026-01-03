class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.9/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "d7646a126096900d029e0df3337d19d9f0ca9bd9ba75514540459ee166fe3690"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.9/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "cc8e547c726c4e5c2001d0e5f834a52e4584a5544c8fb6d0b900f2990ab06c76"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.9/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57b213acef6e96935623ec30f8d42b3a80ebd9b0fedbc057ef7cb08e030d4e0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.9/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af0caf81741ed1da55dff9d7339e70b6ae889bd7af1b4220c5f43af9fdad508c"
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
