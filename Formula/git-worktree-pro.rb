class GitWorktreePro < Formula
  desc "A comprehensive git worktree management toolkit"
  homepage "https://github.com/gndps/git-worktree-pro"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.0/git-worktree-pro-aarch64-apple-darwin.tar.xz"
      sha256 "bc4bb57ce939e5d59eb28f3ca704b213a14ee75ed58071c0722213158c0ee74d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.0/git-worktree-pro-x86_64-apple-darwin.tar.xz"
      sha256 "d64925d27b20be3ac0ddbf9fbd6036a4edc8b21f24ed597031c1437c279651d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.0/git-worktree-pro-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "15b268c35048d3a2713df8729f51239c169390058947cb1725ed189e5219991a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/gndps/git-worktree-pro/releases/download/v0.1.0/git-worktree-pro-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8909dd64a7d33ad83c5bafdc62590b6c7449c6dd5b20f55339bfa7898716f49f"
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
