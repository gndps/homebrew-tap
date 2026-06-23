class PyenvTakeout < Formula
  desc "Manage Python virtual environments with deterministic path-based names"
  homepage "https://github.com/gndps/pyenv-takeout"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.1/pyenv-takeout-aarch64-apple-darwin.tar.xz"
      sha256 "060704812ed57c8784c92577c91719abeb8cad16778ec1fb628d3f6965f81f57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.1/pyenv-takeout-x86_64-apple-darwin.tar.xz"
      sha256 "f329626125375b6fabc842df8cdcee815d1eb725adeced4d38131dc3c3684226"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.1/pyenv-takeout-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "918c0dc6a69b972f0d040feae4914fa24aa14723305f61ad96e4886faad26e79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.1/pyenv-takeout-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c8571ce43fff06404cc7cd0790e6e0ad30bac0fae8e38d83f2942142d3668c1"
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

    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
