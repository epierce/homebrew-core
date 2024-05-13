require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.159.tgz"
  sha256 "8a668fac86ed31e253937647f3617e2fce4f27a4e43ddbef73a6a7ac802b8031"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6015d7b43bf6fb1a824942958a1effb2a5ad00e589d11536c49ef1e8ee9ce5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6015d7b43bf6fb1a824942958a1effb2a5ad00e589d11536c49ef1e8ee9ce5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6015d7b43bf6fb1a824942958a1effb2a5ad00e589d11536c49ef1e8ee9ce5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c655e09951daa1359ac15dda553ef360d2b4b0ee9e40f143dbffbf8e60f7f6f"
    sha256 cellar: :any_skip_relocation, ventura:        "8c655e09951daa1359ac15dda553ef360d2b4b0ee9e40f143dbffbf8e60f7f6f"
    sha256 cellar: :any_skip_relocation, monterey:       "8c655e09951daa1359ac15dda553ef360d2b4b0ee9e40f143dbffbf8e60f7f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6015d7b43bf6fb1a824942958a1effb2a5ad00e589d11536c49ef1e8ee9ce5a"
  end

  depends_on "node"

  def install
    # upstream package layout bug report, https://github.com/glideapps/quicktype/issues/2593
    mv Dir["dist/src/*"], "dist"

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
