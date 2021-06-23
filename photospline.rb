class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/cnweaver/photospline"
  url "https://github.com/cnweaver/photospline/archive/v2.0.7.tar.gz"
  sha256 "59a3607c4aa036c55bcd233e8a0ec11575bd74173f3b4095cc6a77aa50baebcd"
  head "https://github.com/cnweaver/photospline.git"

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system "python", "-c", "import photospline"
  end
end
