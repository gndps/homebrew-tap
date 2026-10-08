class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.3/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "37e535be8db05a728bb88e8f8b95be5a9c957f3cd8a7deb49efa78c1610e90da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.3/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "9569ca1d8423024ff8ed5b2d868b7d2d346c94b8fbc5bd6ed149a9601dbb4b6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.3/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1f2b5e395bf19a9417b750fefe50ec09509d022e9f4a1ee6aa1f99c79e2a081"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.3/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9bd5b72e893a916614db4747d8148b6c1d5b6e0c634012f72cf569fc4ac06ed9"
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
