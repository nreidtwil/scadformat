class Scadformat < Formula
  desc "Source code formatter / beautifier for OpenSCAD"
  homepage "https://github.com/hugheaves/scadformat"
  url "https://github.com/hugheaves/scadformat/archive/refs/tags/v0.10.tar.gz"
  sha256 "b798efba0ed99daaa9d1a9a3dac1cb79f267ab88d6e27803bd0c3c53d39c3d83"
  license "GPL-2.0-or-later"
  head "https://github.com/hugheaves/scadformat.git", branch: "main"

  depends_on "antlr" => :build
  depends_on "go" => :build

  def install
    system formula_opt_bin("antlr")/"antlr", "-o", "internal/parser", "-visitor", "-Dlanguage=Go", "OpenSCAD.g4"
    system "patch", "-p0", "--binary", "-i", "openscad_base_visitor.go.patch"
    (buildpath/"cmd/version.txt").write "v#{version}\n"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/scadformat.go"
  end

  test do
    assert_match "test_var", pipe_output(bin/"scadformat", "test_var = 1;\n", 0)
  end
end
