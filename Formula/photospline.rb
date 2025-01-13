class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "5d8cc8b54880092721122f4498b16ab63fdfbcf84b87df1c6a7992ece7baf9fe"
  revision 1

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.3.1_1"
    sha256 cellar: :any, arm64_sonoma: "65883e71d1ea9905616c4033d3d8cf2ce67ea7e62652466d11a2bef1741aa85b"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system Formula["python@3.13"].opt_bin/"python@3.13", "-c", "import photospline"
  end
end
