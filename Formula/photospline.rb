class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "c8bfd2a087300f3f217cecfe3e4354be4e2a485dfc503420c8ebbffeec5adf03"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.4.1"
    sha256 cellar: :any, arm64_sequoia: "0e019f738a17ace7997599a189d825bc7e199b69bc4113a0d34a5eb2f7f3f0ce"
    sha256 cellar: :any, arm64_sonoma:  "812b49cbf98d0556ba27b3c952d486d9295e63668bd409a8723a0cad6ede5437"
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

  # test do
  #   # just make sure it's linked correctly
  #   system Formula["python@3.13"].opt_bin/"python@3.13", "-c", "import photospline"
  # end
end
