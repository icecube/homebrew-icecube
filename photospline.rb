class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/cnweaver/photospline"
  version "2.0.0-alpha.2"
  url "https://github.com/cnweaver/photospline/archive/v2.0.0-alpha.2.tar.gz"
  sha256 "6240f32caaae7c2a83b80669665cb84b5c0bb308b3908fa2c835aeb9e893cc76"
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
