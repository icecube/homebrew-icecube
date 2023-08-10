class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/v2.1.1.tar.gz"
  sha256 "0a0dae8e1b994a35be23896982bd572fa97c617ad55a99b3da34782ad9435de8"
  revision 1

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.1.1_1"
    sha256 cellar: :any, ventura:  "479b603949e7c7560c835b82a0ee381e3f962d498ec78b8cea0d217397cca20e"
    sha256 cellar: :any, monterey: "f41c47c4759e4494c3e0ac296de8133fe9311dff0865a323742ddf3ff84de540"
    sha256 cellar: :any, big_sur:  "aee90bfe70cf2f8b237bddbae83cb2c4f6404c064b7c858c733d8b739e18854e"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system "python3", "-c", "import photospline"
  end
end
