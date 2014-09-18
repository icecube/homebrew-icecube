require "formula"

class Boostnumpy < Formula
  homepage "https://github.com/martwo/BoostNumpy"
  url "https://github.com/martwo/BoostNumpy/archive/V0.2.0.tar.gz"
  version "0.2.0"
  sha1 "f7a6c2661c502ad67a2e40048b99635deb8d73a8"

  depends_on "cmake" => :build
  depends_on "numpy" => :python
  depends_on "boost" => "with-python"

  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
diff --git a/include/boost/numpy/detail/logging.hpp b/include/boost/numpy/detail/logging.hpp
index 8f25e12..08f463b 100644
--- a/include/boost/numpy/detail/logging.hpp
+++ b/include/boost/numpy/detail/logging.hpp
@@ -45,11 +45,6 @@ log(
         boost::numpy::detail::log(file, line, func, oss.str());                \
     }
 
-#ifdef NDEBUG
-    #define BOOST_NUMPY_LOG(msg)
-#else
-    #define BOOST_NUMPY_LOG(msg) \
-        BOOST_NUMPY_DETAIL_STREAM_LOGGER(__FILE__, __LINE__, __PRETTY_FUNCTION__, msg)
-#endif
+#define BOOST_NUMPY_LOG(msg)
 
 #endif // BOOST_NUMPY_DETAIL_LOGGING_HPP_INCLUDED
diff --git a/include/boost/numpy/dstream/detail/loop_service.hpp b/include/boost/numpy/dstream/detail/loop_service.hpp
index 7ed431a..369376b 100644
--- a/include/boost/numpy/dstream/detail/loop_service.hpp
+++ b/include/boost/numpy/dstream/detail/loop_service.hpp
@@ -64,7 +64,7 @@ struct max_loop_shape_selector
     int const arr_loop_nd_;
 };
 
-bool operator>(max_loop_shape_selector const & lhs, max_loop_shape_selector const & rhs)
+inline bool operator>(max_loop_shape_selector const & lhs, max_loop_shape_selector const & rhs)
 {
     return (lhs.arr_loop_nd_ > rhs.arr_loop_nd_);
 }

