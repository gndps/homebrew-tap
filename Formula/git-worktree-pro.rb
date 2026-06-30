class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.2/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "2818487aaee72a9a221b12422e916a3c424428dbfe0ed632ad2e582ef942447b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.2/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "8009b5cded3b76cda61b77cef623c5d61ff8f6916839dbd3afa98820de7b5b65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.2/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0137710f106ed00d8b4cb9f426bad8d2780c6cad4d06b8f3bfb6e59cafd2e8a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.2/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3d99e529ed53dc6c0ec4a11f6f35956c83a4fe752ee7087e2c652e70bb5fcb88"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "gwtp" if OS.mac? && Hardware::CPU.arm?
    bin.install "gwtp" if OS.mac? && Hardware::CPU.intel?
    bin.install "gwtp" if OS.linux? && Hardware::CPU.arm?
    bin.install "gwtp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
