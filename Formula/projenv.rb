class Projenv < Formula
  desc "Project directory bookmark manager with profiles"
  homepage "https://github.com/gndps/projenv"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/projenv/releases/download/v0.1.1/projenv-aarch64-apple-darwin.tar.xz"
      sha256 "47eb3be9f407ad39c7a71cfcf1c0453f1537afaa9c8753d14a593a0b7facdb74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/projenv/releases/download/v0.1.1/projenv-x86_64-apple-darwin.tar.xz"
      sha256 "c0dfe211aa5ed6488b92de220f761440a297a0bf5f0c3d4ec0214308d4a7b3c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/projenv/releases/download/v0.1.1/projenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "213dfd38efbd01d2856486daf83f542ad18d95905ee9e52fb8537742f2619ff8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/projenv/releases/download/v0.1.1/projenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "393c625ef4ac411a2fcb3b8b5d28c451f507889b3ddc7d6dba1b30fb78657696"
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

    "\#{cpu}-\#{os}"
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

    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
