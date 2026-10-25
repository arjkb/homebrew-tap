# Template for Formula/zstdir.rb in the arjkb/homebrew-tap repository.
# See RELEASING.md for how to update it for each release.
class Zstdir < Formula
  desc "Compress and extract directories with zstd in one step"
  homepage "https://github.com/arjkb/zstdir"
  url "https://github.com/arjkb/zstdir/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f70ab6a0ecb52e17de5a925a2b5564546baf75ed0764d1e5587835669c2bc111"
  license "GPL-3.0-only"
  head "https://github.com/arjkb/zstdir.git", branch: "main"

  bottle do
    root_url "https://github.com/arjkb/homebrew-tap/releases/download/zstdir-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f8dd744f7d224feb756f9cc0f92d7c4072dca2142242c03cadb51808a83e4dc5"
    sha256 cellar: :any,                 x86_64_linux: "6f49b13496f13e4380e379dd58e169a3250fbb34c5da8757845dc53cdacb3233"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    bin.install_symlink "zstdir" => "unzstdir"
    man1.install "man/zstdir.1"
    man1.install_symlink "zstdir.1" => "unzstdir.1"
  end

  test do
    (testpath/"proj/sub/a.txt").write "hello\n"
    system bin/"zstdir", "proj"
    assert_path_exists testpath/"proj.tar.zst"

    rm_r testpath/"proj"
    system bin/"unzstdir", "proj.tar.zst"
    assert_equal "hello\n", (testpath/"proj/sub/a.txt").read

    assert_match version.to_s, shell_output("#{bin}/zstdir --version")
  end
end
