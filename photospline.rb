class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/cnweaver/photospline"
  url "https://github.com/cnweaver/photospline/archive/v2.0.0.tar.gz"
  sha256 "d031c5f520cd49fff07b507765c13b0b7c61c06eaffa5249e99c1222b4c29774"
  head "https://github.com/cnweaver/photospline.git"

  depends_on "cmake" => :build
  depends_on "suite-sparse"
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
