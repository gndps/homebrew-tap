class Bfcli < Formula
  desc "A simple shell file sourcing manager"
  homepage "https://github.com/gndps/bfcli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.1/bfcli-aarch64-apple-darwin.tar.xz"
      sha256 "3da906775ff6cdc761a1610a080a26bec70b1a9463f8dcf3c137026241e131ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.1/bfcli-x86_64-apple-darwin.tar.xz"
      sha256 "1326ae201224c34f0ef631766bfced59a71d90d770642c43ea487262ec326cc7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.1/bfcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "967be29edaf107ce71b7f2cd664e05cf67653c872c55d8d49f4cd40bb3084fa0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.1/bfcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6cbd9e9e299e9677cf712313d180c7c18532b002440a5929f4279a0c0654ed8b"
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
    bin.install "bfcli" if OS.mac? && Hardware::CPU.arm?
    bin.install "bfcli" if OS.mac? && Hardware::CPU.intel?
    bin.install "bfcli" if OS.linux? && Hardware::CPU.arm?
    bin.install "bfcli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
