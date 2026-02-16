class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "b3873fa475434b6ff3e1013a638d5a04970d21ced5ef32af5dd6a6f4fbb79b0c"
  revision 1
  head "https://github.com/icecube/photospline.git", branch: "master"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.4.2_1"
    sha256 cellar: :any, arm64_sequoia: "cb39e2a29d78aa531c335ded2ce7c8bc1a2a5faf6f3ca59fdd386b847ae23c70"
    sha256 cellar: :any, arm64_sonoma:  "d421dfcf8546660516cc7dd4174f2787845e1d465fb448059a4f936f308a34c7"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  depends_on "suite-sparse"

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system Formula["python@3.14"].opt_bin/"python3", "-c", "import photospline"
  end
end
