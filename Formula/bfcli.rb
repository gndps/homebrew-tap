class Bfcli < Formula
  desc "A simple shell file sourcing manager"
  homepage "https://github.com/gndps/bfcli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.0/bfcli-aarch64-apple-darwin.tar.xz"
      sha256 "08d7befd733f213a647b2f418af00e480d2f42b30f82ccdc760f3cd929e7c435"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.0/bfcli-x86_64-apple-darwin.tar.xz"
      sha256 "bcaa3717e38cf2456b2b658972e7e94074f486b2529cf677c075eadd70110c3c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.0/bfcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f94dc59bc410d04a3590dbe54c83e6fae644cff36cd6efc88573ad8c6ee074b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/bfcli/releases/download/v0.1.0/bfcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6663759180a80f57e85b8df18df9a411b12ee97f7c534021005a3d124e0987f6"
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
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
