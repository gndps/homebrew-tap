class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.2/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "973794fff0dd1f61b71f0d9a02f3763a077d0f643e977398b65d83e38844c681"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.2/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "314a40f1eb5b988571fd73e3ece60f9e409aa6ffbccc40769bb71abb5fdb86ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.2/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "148e412528c42213b214eacdbaccd129b36a6c15f19529722945b334ee79ab04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.2/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cc715ee12f6936c7ddb634f059cd3a20b37550d482781fd858755a3cce71f678"
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
