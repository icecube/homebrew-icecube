class Cppzmq < Formula
  desc "Header-only C++ binding for libzmq"
  homepage "https://github.com/zeromq/cppzmq"
  url "https://github.com/zeromq/cppzmq/archive/v4.8.1.tar.gz"
  version "4.7.1"
  sha256 "7a23639a45f3a0049e11a188e29aaedd10b2f4845f0000cf3e22d6774ebde0af"

  depends_on "cmake" => :build
  depends_on "zeromq"

  def install
    system "cmake", ".", "-DCPPZMQ_BUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
