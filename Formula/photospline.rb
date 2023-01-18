class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/v2.1.0.tar.gz"
  sha256 "bd6c58df8893917909b79ef2510a2043f909fbb7020bdace328d4d36e0222b60"

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "suite-sparse"

  stable do
    # update SuiteSparse version detection through photospline v2.1.1
    patch :DATA
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system "python3", "-c", "import photospline"
  end
end

__END__
diff --git a/cmake/Packages/SuiteSparse.cmake b/cmake/Packages/SuiteSparse.cmake
index 8d9e7a2..35e14b9 100644
--- a/cmake/Packages/SuiteSparse.cmake
+++ b/cmake/Packages/SuiteSparse.cmake
@@ -47,7 +47,7 @@ IF (NOT SUITESPARSE_FOUND)
     IF (EXISTS "${SUITESPARSE_INCLUDE_DIR}/UFconfig.h")
       FILE (READ "${SUITESPARSE_INCLUDE_DIR}/UFconfig.h" _SUITESPARSE_VERSION)
     ENDIF (EXISTS "${SUITESPARSE_INCLUDE_DIR}/UFconfig.h")
-    STRING (REGEX REPLACE ".*define SUITESPARSE_MAIN_VERSION ([0-9]+).*" "\\1"
+    STRING (REGEX REPLACE ".*define SUITESPARSE_MAIN_VERSION +([0-9]+).*" "\\1"
       SUITESPARSE_VERSION "${_SUITESPARSE_VERSION}")
   ENDIF (SUITESPARSE_INCLUDE_DIR)
