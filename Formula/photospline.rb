class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "c8bfd2a087300f3f217cecfe3e4354be4e2a485dfc503420c8ebbffeec5adf03"
  revision 1

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.4.1_1"
    sha256 cellar: :any, arm64_sequoia: "428f9a2f2211efa5d9c1122df8b7d51fdfe0c21eb263cd21668c29da369d47e3"
    sha256 cellar: :any, arm64_sonoma:  "0a7e9f36338c32bd4bbedd40125d999441ac5fbb45330dcc2dc925cdafbd17e9"
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
    system Formula["python@3.13"].opt_bin/"python3", "-c", "import photospline"
  end
end
