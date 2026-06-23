class Projenv < Formula
  desc "Project directory bookmark manager with profiles"
  homepage "https://github.com/gndps/projenv"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/projenv/releases/download/v0.1.2/projenv-aarch64-apple-darwin.tar.xz"
      sha256 "b10ac0c9b6659d5c3559fbb7fc8769ed83595497ad8423122b99d5e0e4b883ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/projenv/releases/download/v0.1.2/projenv-x86_64-apple-darwin.tar.xz"
      sha256 "14ba7478acd89fb2d34da67835a10ead095054855198f250497aa26484334811"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/projenv/releases/download/v0.1.2/projenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "16864c12190d9b29438c69774a5a417ca306dc074ed40ad79bf5ec8590d1faf1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/projenv/releases/download/v0.1.2/projenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19c98f202b43d54d67ca5876590ad0fb51c8bca0793ec102bfd9917722e7c757"
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
    bin.install "projenv" if OS.mac? && Hardware::CPU.arm?
    bin.install "projenv" if OS.mac? && Hardware::CPU.intel?
    bin.install "projenv" if OS.linux? && Hardware::CPU.arm?
    bin.install "projenv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
