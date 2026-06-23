class Projenv < Formula
  desc "Project directory bookmark manager with profiles"
  homepage "https://github.com/gndps/projenv"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/projenv/releases/download/v0.1.0/projenv-aarch64-apple-darwin.tar.xz"
      sha256 "77a57c11ef127a93962903d33808bc7bd360eeab22dcc56674dfe64d1cf9f885"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/projenv/releases/download/v0.1.0/projenv-x86_64-apple-darwin.tar.xz"
      sha256 "a5edd8c926ad1bf8de3ce9c10cc816df0bce201ff4ed2c155a1be0725bd2f5cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/projenv/releases/download/v0.1.0/projenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81438d4471fe741e9a70ee65fd149c18d19511558f6d311e9b5b39f63daf84cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/projenv/releases/download/v0.1.0/projenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4c533379f803617e90e3aef2eb3a494bbfdcc46d7a7e8614219b6912f0b73c44"
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
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
