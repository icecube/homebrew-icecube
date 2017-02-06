class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/cnweaver/photospline"
  version "2.0.0-alpha.1"
  url "https://github.com/cnweaver/photospline/archive/v2.0.0-alpha.1.tar.gz"
  sha256 "f4c8329f05299a7128d7936bb9abd2bea9d857566b56c58621efaff68976a4d7"
  head "https://github.com/cnweaver/photospline.git"

  depends_on "cmake" => :build
  depends_on "homebrew/science/suite-sparse"
  depends_on "cfitsio"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system "python", "-c", "import photospline"
  end
end
