class Sshenv < Formula
  desc "SSH key profile manager — switch between SSH key pairs"
  homepage "https://github.com/gndps/sshenv"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.4/sshenv-aarch64-apple-darwin.tar.xz"
      sha256 "b3bd4931fbbf9e5b6c546afee80bd60e18247843deef4d1290f17033a6b0b8d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.4/sshenv-x86_64-apple-darwin.tar.xz"
      sha256 "03b23dc88dcecb7cdd8499be973b0e31cd1108bc4c6bc4237c68cc63918c703b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.4/sshenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67c78e47948f4e60006991bfd64901b182a0a85310c0aa611e7093f560f9e351"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.4/sshenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "042358ffc841c6dcd9a98eefcf879fad66a3d288b4d3979c9e78628bb2a485c5"
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
    bin.install "sshenv" if OS.mac? && Hardware::CPU.arm?
    bin.install "sshenv" if OS.mac? && Hardware::CPU.intel?
    bin.install "sshenv" if OS.linux? && Hardware::CPU.arm?
    bin.install "sshenv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
