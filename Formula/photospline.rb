class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "c8bfd2a087300f3f217cecfe3e4354be4e2a485dfc503420c8ebbffeec5adf03"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.4.1"
    sha256 cellar: :any, sonoma:  "33e36eafc6b5f8288c4c5920d1b9a6df2df07bb7ca0e5fef339e5eb2665fae9c"
    sha256 cellar: :any, sequoia: "504a5da0876defcedad0e8d3f6f588584e82609a930e89ecef9a549b1dd2ba21"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "metis"
  depends_on "numpy"
  depends_on "openblas"
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
