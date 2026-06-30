class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.4/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "3bd727f4bd6a31e3dd3963a739d0687167a9937e1a92700cb267b1fde7abd365"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.4/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "c7da962c03c6e556079a49c6b1e2e6c7f405fd46168c161211f41e6795f5a962"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.4/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a3f048a3fa012a2c84ac83e2d73aa22a63a208a3285a1d10a3916ed2e78be49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.2.4/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58d754f7548a6f2e6b4931d5f6177139beb87f984dd00200bcbcb7b183cd299e"
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
