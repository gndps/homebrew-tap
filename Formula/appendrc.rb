class Appendrc < Formula
  desc "Manage and time shell sourcable files"
  homepage "https://github.com/gndps/appendrc"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.2/appendrc-aarch64-apple-darwin.tar.xz"
      sha256 "01e2b15d591ccaea56b0a4f986beecd5d89e7136960af311056b116bcb05747d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.2/appendrc-x86_64-apple-darwin.tar.xz"
      sha256 "57d49b1cf851b3a350a6a518629b495a403d0db6625a419942e6be386d4e09f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.2/appendrc-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "21bd4404f953e6ac6b0f5c5e14142c384cde5eb0b64ba7e7c244a443866f0a9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/appendrc/releases/download/v0.1.2/appendrc-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4daea8d9693247a2b11736151568fa9a21deefe738e00bc18e81ee82363710a0"
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
