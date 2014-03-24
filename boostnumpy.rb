require "formula"

class Boostnumpy < Formula
  homepage "https://github.com/martwo/BoostNumpy"
  url "http://icecube.wisc.edu/~mwolf/tools/BoostNumpy-0.1.0.tar.gz"
  version "0.1.0"
  sha1 "632e5f6c60e1a8c8c0ceeca0a1e4003d5d084984"

  depends_on "cmake" => :build
  depends_on "numpy" => :python
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
