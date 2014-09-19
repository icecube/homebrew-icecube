require "formula"

class Boostnumpy < Formula
  homepage "https://github.com/martwo/BoostNumpy"
  url "https://github.com/martwo/BoostNumpy/archive/V0.2.1.tar.gz"
  version "0.2.1"
  sha1 "8488404e5a75731ca5561838705604a11a3ec1c5"

  depends_on "cmake" => :build
  depends_on "numpy" => :python
  depends_on "boost" => "with-python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
