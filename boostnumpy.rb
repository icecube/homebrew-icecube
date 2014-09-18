require "formula"

class Boostnumpy < Formula
  homepage "https://github.com/martwo/BoostNumpy"
  url "https://github.com/martwo/BoostNumpy/archive/V0.2.0.tar.gz"
  version "0.2.0"
  sha1 "f7a6c2661c502ad67a2e40048b99635deb8d73a8"

  depends_on "cmake" => :build
  depends_on "numpy" => :python
  depends_on "boost" => "with-python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
