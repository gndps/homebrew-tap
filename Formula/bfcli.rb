class Bfcli < Formula
  desc "A simple shell file sourcing manager"
  homepage "https://github.com/gndps/bfcli"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.4/bfcli-aarch64-apple-darwin.tar.xz"
      sha256 "4bb1340913a7446ff13c3aad0fd7d9fd6fb6ea9efbf38eed345c1bb63ab47af5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.4/bfcli-x86_64-apple-darwin.tar.xz"
      sha256 "12489e4b5b3d1aa6dff432a451474c4f62e3075ab1f405a43ee5da725bf953c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.4/bfcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea4e9aa77b92abc9464e6ef27af4b65ec3d5b636820c5acce4a5ac233d546ea3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.4/bfcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d64cacb6ed8ab85a48342fd690332f0c9a536eb7672a3352e48950d7f10f8cb"
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
