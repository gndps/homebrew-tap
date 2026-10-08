class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.4/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "1a50ae3f0586787099f30b56c3737197b287bb5a4a6ac355d0bb34c3cba377bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.4/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "ba17973b932d1c47984e3cdfe563019c74b90e687c34db7109dc0ba73a4f22c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.4/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11c41a28b1a9ebfbcb6ed0cbcee4124860b74bc8e9d16f4edc9d7a79b8b08dd5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.4/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6235151d764a7ea0b0f00d79adca8a2dc9ca1f31a530b74435d17606d88af12d"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gwtp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "gwtp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gwtp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gwtp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
