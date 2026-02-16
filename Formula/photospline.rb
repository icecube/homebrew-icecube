class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "b3873fa475434b6ff3e1013a638d5a04970d21ced5ef32af5dd6a6f4fbb79b0c"
  head "https://github.com/icecube/photospline.git", branch: "master"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.4.2"
    sha256 cellar: :any, arm64_sequoia: "7dc29ce6f297acd43706c39674b54f06cf5c1a7ee07be8c263ea3878406885cd"
    sha256 cellar: :any, arm64_sonoma:  "3ccbe489f4a05a0c2f0dbd5ea45c882ab6ee18bbc080a7be06af1fa4bf6f4145"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python@3.14"
  depends_on "suite-sparse"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system Formula["python@3.14"].opt_bin/"python3", "-c", "import photospline"
  end
end
