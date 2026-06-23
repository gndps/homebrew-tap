class PyenvTakeout < Formula
  desc "Manage Python virtual environments with deterministic path-based names"
  homepage "https://github.com/gndps/pyenv-takeout"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.0/pyenv-takeout-aarch64-apple-darwin.tar.xz"
      sha256 "6203bb205dd38056e34dde527517e961d30a961bea23a42869bc87a45d94e372"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.0/pyenv-takeout-x86_64-apple-darwin.tar.xz"
      sha256 "bed8bf24abd2b6129066e0d48a85937c481091793d8617fa66cef9d21d325ec0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.0/pyenv-takeout-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1a7306922d377fd9dbbf0a194b2e3787053772233d49b4b9dd06f185d6d70b75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/pyenv-takeout/releases/download/v0.1.0/pyenv-takeout-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6ede0dd02aa3a521186561990db62c32f0f95fdb2369e1ac807d04c981fbf62"
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
