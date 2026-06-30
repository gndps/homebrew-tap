class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.1/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "20d922e35c40cc13fd1d313c03449598156e2f3b070dcc65c349c18e0b7f24a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.1/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "40f1ac9744bff665788b111efc34cab97ad2888f41c60619efbddcf9d96974ae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.1/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8647b8a490a3c6317422c99f281338ed8b2b8c17e71c88b2616c751cc6c351b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.3.1/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e119e32242cb4689529fc68654232a607aa63b60fe02b6e48189f1d5f3341dc6"
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
