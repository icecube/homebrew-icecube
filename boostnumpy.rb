require "formula"

class Boostnumpy < Formula
  homepage ""
  url "http://code.icecube.wisc.edu/svn/sandbox/mwolf/tools/BoostNumpy/trunk", :using => :svn
  version "1.0.0"
  sha1 "9246890d5533444d556732426ea05632cce73a1f"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
