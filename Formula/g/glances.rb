class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/02/0c/7fb4ae18c063d3555496964e645350e7f6daf2b24d0414527ae1dff2834e/glances-4.0.1.tar.gz"
  sha256 "ceb407256191859c7e8da3503f24723f7d2fa2538e083be69a27583e0d046aca"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb0171b9330e64101f124a84c6f9ae6ba2673ebc8b4b4d7ec593d5ee67aeebfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d311a5456063ca3321978458d4e1dee26c48b227594bc0efec0bdf32cf43d45c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1526d01c2cd68a41efb1f9638727f62921baeb8db02cd2f6267ba3879e56c98"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aad74ca872e153376265e88605bdcc46c0d6107ef03269c6dc8cf36618e208c"
    sha256 cellar: :any_skip_relocation, ventura:        "44f9428eb2ff986ef51c52664503b50ac70b72869e24947ef1c36cf12c25b485"
    sha256 cellar: :any_skip_relocation, monterey:       "e653240ae3b6e1111760da11b1954af2a3ee227e87393175890c31537385f6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592fd120e04f6830f4ee0792d563c4163413770e5f84601e21885333866eb7e0"
  end

  depends_on "rust" => :build # for pydantic
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/1f/74/0d009e056c2bd309cdc053b932d819fcb5ad3301fc3e690c097e1de3e714/pydantic-2.7.1.tar.gz"
    sha256 "e9dbb5eada8abe4d9ae5f46b9939aead650cd2b68f249bb3a8139dbe125803cc"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e9/23/a609c50e53959eb96393e42ae4891901f699aaad682998371348650a6651/pydantic_core-2.18.2.tar.gz"
    sha256 "2e29d20810dfc3043ee13ac7d9e25105799817683348823f305ab3f349b9386e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/54/6f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619e/ujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
  end

  def install
    virtualenv_install_with_resources

    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
