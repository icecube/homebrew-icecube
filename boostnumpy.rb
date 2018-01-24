require "formula"

class Boostnumpy < Formula
  homepage "https://github.com/martwo/BoostNumpy"
  url "https://github.com/martwo/BoostNumpy/archive/V0.2.2.tar.gz"
  sha256 '0e4a50f8f314e9027a7140d4c398db9bec31f72515dd6736d60b2e7b6e68384f'
  patch :p1, :DATA

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/bf/2d/005e45738ab07a26e621c9c12dc97381f372e06678adf7dc3356a69b5960/numpy-1.13.3.zip"
    sha256 "36ee86d5adbabc4fa2643a073f93d5504bdfed37a149a3a49f4dde259f35a750"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 57323f3..13f74bd 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -12,6 +12,10 @@
 # http://www.boost.org/LICENSE_1_0.txt).
 #
 cmake_minimum_required(VERSION 2.8.3)
+if(CMAKE_VERSION VERSION_GREATER 2.8.11)
+    set(CMAKE_MACOSX_RPATH 1)
+    cmake_policy(SET CMP0042 NEW)
+endif(CMAKE_VERSION VERSION_GREATER 2.8.11)

 # Choose CMAKE_BUILD_TYPE=Release if the user does not specify it.
 if(DEFINED CMAKE_BUILD_TYPE)
diff --git a/test/dstream_test_module.cpp b/test/dstream_test_module.cpp
index e3b5264..3d949c7 100644
--- a/test/dstream_test_module.cpp
+++ b/test/dstream_test_module.cpp
@@ -18,8 +18,8 @@
  */
 #include <vector>

-#include <boost/shared_ptr.hpp>
 #include <boost/python.hpp>
+#include <boost/shared_ptr.hpp>

 #include <boost/numpy.hpp>
 #include <boost/numpy/dstream.hpp>
