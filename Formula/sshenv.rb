class Sshenv < Formula
  desc "SSH key profile manager — switch between SSH key pairs"
  homepage "https://github.com/gndps/sshenv"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.0/sshenv-aarch64-apple-darwin.tar.xz"
      sha256 "dfb2ea669df452bdf82f0fee4571ebd19eb2d8590367dc2d911e9f845ba714e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.0/sshenv-x86_64-apple-darwin.tar.xz"
      sha256 "e1aebcaa5f94ceff117286c70e035bc5ab74a4ff698369bb5c6d2cd1b73976f4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.0/sshenv-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "584397f45cb41b973e32ec82cf5503bd0980416206d9d7634713b662cd5734a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/sshenv/releases/download/v0.1.0/sshenv-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9f03127be1fe27aca14a6319b6a14ed5cd64a4c8e319e446e87da769c83f0e04"
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
