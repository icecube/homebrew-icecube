class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "5d8cc8b54880092721122f4498b16ab63fdfbcf84b87df1c6a7992ece7baf9fe"
  revision 1

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.3.1"
    sha256 cellar: :any, arm64_sequoia: "04934e5757d0cb9db0b8f73a5f051390cd8f625bc9173fa2717ff40e36509a8b"
    sha256 cellar: :any, arm64_sonoma:  "ead2d4b5ff345c4abb73da73ab155c7337066fe998eadaf0acfd12243239a014"
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
