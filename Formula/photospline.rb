class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "b3873fa475434b6ff3e1013a638d5a04970d21ced5ef32af5dd6a6f4fbb79b0c"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.4.1_1"
    sha256 cellar: :any, arm64_sequoia: "428f9a2f2211efa5d9c1122df8b7d51fdfe0c21eb263cd21668c29da369d47e3"
    sha256 cellar: :any, arm64_sonoma:  "0a7e9f36338c32bd4bbedd40125d999441ac5fbb45330dcc2dc925cdafbd17e9"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "suite-sparse"
  depends_on "openblas"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system Formula["python@3.14"].opt_bin/"python3", "-c", "import photospline"
  end
end
