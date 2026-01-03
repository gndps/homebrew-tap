class DotfilesSync < Formula
  desc "A clean, hassle-free dotfiles manager with git integration"
  homepage "https://github.com/gndps/dotfiles_sync"
  version "1.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.10/dotfiles_sync-aarch64-apple-darwin.tar.xz"
      sha256 "647b8910cb1b4def8b1d8aa661adc29f798bed530cc3f00a69ff4d68398183d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.10/dotfiles_sync-x86_64-apple-darwin.tar.xz"
      sha256 "46ba342df1fe6ae34a3c36b5b6e16d791e47c646c0575c42af0e51790503d3a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.10/dotfiles_sync-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9c7538a0b014fd253885f8a401ef0e8eca36bebcd8eb5f9a5c4337d4e6f4e5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/dotfiles_sync/releases/download/v1.0.10/dotfiles_sync-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53093fd71ffb01e87d43d058a6934e83f54877072dbaed6ac99baac1e6e2d21e"
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
