require "formula"

class Boostnumpy < Formula
  homepage "https://github.com/martwo/BoostNumpy"
  url "https://github.com/martwo/BoostNumpy/archive/V0.2.2.tar.gz"
  version "0.2.2"
  sha1 "1c93ee6352cd295bbf52269eb7d13f60e3643d8e"
  patch :p1, :DATA

  depends_on "cmake" => :build
  depends_on "numpy" => :python
  depends_on "boost"
  depends_on "boost-python"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
diff --git a/test/dstream_test_module.cpp b/test/dstream_test_module.cpp
index e3b5264..0f15594 100644
--- a/test/dstream_test_module.cpp
+++ b/test/dstream_test_module.cpp
@@ -16,6 +16,7 @@
  *        Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
  *        http://www.boost.org/LICENSE_1_0.txt).
  */
+#include <Python.h>
 #include <vector>

 #include <boost/shared_ptr.hpp>

