class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "2b455daf8736d24bf57cae9eb67d48463a6c4bd6a66c3ffacf52296454bb82ad"
  revision 1

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.2.1_1"
    sha256 cellar: :any, ventura: "294b7258e2dbf626fcbb7f5f935a65aa33ed58e49e0ba5e8d6c79cd0b6538348"
  end

  # bottle do
  #   root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.1.1_1"
  #   sha256 cellar: :any, arm64_ventura:  "4183c720d486d8a29e77006c8a85049513ab96ebb7b2955e0636a4694303d5d9"
  #   sha256 cellar: :any, arm64_monterey: "16d50cde84e0b33eb790e3682c43b577963439feae1dca3cb7a771a74f4d94da"
  #   sha256 cellar: :any, ventura:        "8082c0a51d43dede4563599340dba960813bda7237619e36d390c54a589ab4da"
  #   sha256 cellar: :any, monterey:       "08e1586ed1a2331cd71497050fb3addbcf1a04b447c1da52cd254763d6817ffd"
  #   sha256 cellar: :any, big_sur:        "a6689193e73e25df4a332f3742c57e924d026f89ad915b808f46eeee02fcbac2"
  # end
  #
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
    system "python3", "-c", "import photospline"
  end
end
