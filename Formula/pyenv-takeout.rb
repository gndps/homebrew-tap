class PyenvTakeout < Formula
  desc "Manage Python virtual environments with deterministic path-based names"
  homepage "https://github.com/gndps/pyenv-takeout"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.2/pyenv-takeout-aarch64-apple-darwin.tar.xz"
      sha256 "acd6b70a74b0670df4facaa4e64f855d56eeba0b6790c0d0f0e5dbdfeccf4abf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.2/pyenv-takeout-x86_64-apple-darwin.tar.xz"
      sha256 "a3a7140075b02efbc56a80086769290ff8500e970e8b7efed03b2593f7c66f90"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.2/pyenv-takeout-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e104bbb6502efdbdc9277ed36b2cd52752948928b37221b0fca92b48cd869ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.2/pyenv-takeout-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a1bd50c446a47381629dfd278d94b23be7d63e80850c2b253b85974980665c36"
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
    bin.install "pyenv-takeout" if OS.mac? && Hardware::CPU.arm?
    bin.install "pyenv-takeout" if OS.mac? && Hardware::CPU.intel?
    bin.install "pyenv-takeout" if OS.linux? && Hardware::CPU.arm?
    bin.install "pyenv-takeout" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
