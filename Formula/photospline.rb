class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "2b455daf8736d24bf57cae9eb67d48463a6c4bd6a66c3ffacf52296454bb82ad"
  revision 2

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.2.1_2"
    sha256 cellar: :any, ventura:  "33e36eafc6b5f8288c4c5920d1b9a6df2df07bb7ca0e5fef339e5eb2665fae9c"
    sha256 cellar: :any, monterey: "504a5da0876defcedad0e8d3f6f588584e82609a930e89ecef9a549b1dd2ba21"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system Formula["python@3.12"].opt_bin/"python3.12", "-c", "import photospline"
  end
end
