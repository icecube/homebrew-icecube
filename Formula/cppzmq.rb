require 'formula'

class Cppzmq < Formula
  homepage 'https://github.com/zeromq/cppzmq'
  url 'https://github.com/zeromq/cppzmq/archive/v4.8.1.tar.gz'
  sha256 '7a23639a45f3a0049e11a188e29aaedd10b2f4845f0000cf3e22d6774ebde0af'
  version '4.7.1'

  depends_on 'zeromq'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DCPPZMQ_BUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

end
