require 'formula'

class Cppzmq < Formula
  homepage 'https://github.com/zeromq/cppzmq'
  url 'https://github.com/zeromq/cppzmq/archive/v4.7.1.tar.gz'
  sha256 '9853e0437d834cbed5d3c223bf1d755cadee70e7c964c6e42c4c6783dee5d02c'
  version '4.7.1'

  depends_on 'zeromq'
  depends_on 'cmake' => :build

  def install
    system "cmake", ".", "-DCPPZMQ_BUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

end
