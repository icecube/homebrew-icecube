class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "2b455daf8736d24bf57cae9eb67d48463a6c4bd6a66c3ffacf52296454bb82ad"
  revision 2

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
    system Formula["python@3.12"].opt_bin/"python3.12", "--version"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "site"
    # system "ls", "-l", "/usr/local/lib/python*/site-packages"
    # system "find", "/usr/local/Cellar/photospline"
    system Formula["python@3.12"].opt_bin/"python3.12", "-c", "import photospline"
  end
end
