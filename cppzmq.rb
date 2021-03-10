require 'formula'

class Cppzmq < Formula
  homepage 'https://github.com/zeromq/cppzmq'
  url 'https://github.com/zeromq/cppzmq/archive/v4.3.0.tar.gz'
  sha256 '27d1f56406ba94ee779e639203218820975cf68174f92fbeae0f645df0fcada4'
  version '4.3.0'

  depends_on 'zeromq'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end
