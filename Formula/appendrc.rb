class Appendrc < Formula
  desc "Manage and time shell sourcable files"
  homepage "https://github.com/gndps/appendrc"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.0/appendrc-aarch64-apple-darwin.tar.xz"
      sha256 "1f33ca89e98cbcd16d9afa3f8a0d7cf11a898ec5a70c573110c82052bc849be6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.0/appendrc-x86_64-apple-darwin.tar.xz"
      sha256 "db4dd707d65eeb1e317c65aa7bbfdd2ed7ca685b837ddecebaeb684b21eba485"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.0/appendrc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ef153f16f61e6ad3d2b80f122de76b840e1856b75345e552abb3ade9134f5b2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.0/appendrc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09300462cad4ccaef47e955375721e43fd5bb583f106ddf62c873ea9eb10386a"
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
    bin.install "appendrc" if OS.mac? && Hardware::CPU.arm?
    bin.install "appendrc" if OS.mac? && Hardware::CPU.intel?
    bin.install "appendrc" if OS.linux? && Hardware::CPU.arm?
    bin.install "appendrc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
