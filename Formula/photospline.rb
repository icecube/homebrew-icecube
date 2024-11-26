class Photospline < Formula
  desc "Fit and evaluate tensor-product B-spline surfaces"
  homepage "https://github.com/icecube/photospline"
  url "https://github.com/icecube/photospline/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "5d8cc8b54880092721122f4498b16ab63fdfbcf84b87df1c6a7992ece7baf9fe"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/photospline-2.2.1_2"
    sha256 cellar: :any, ventura:  "33e36eafc6b5f8288c4c5920d1b9a6df2df07bb7ca0e5fef339e5eb2665fae9c"
    sha256 cellar: :any, monterey: "504a5da0876defcedad0e8d3f6f588584e82609a930e89ecef9a549b1dd2ba21"
  end

  depends_on "cmake" => :build
  depends_on "cfitsio"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "suite-sparse"

  # patch to force python@3.12, remove when boost-python3 depends on python@3.13
  patch :DATA

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    # just make sure it's linked correctly
    system Formula["python@3.12"].opt_bin/"python3.12", "-c", "import photospline"
  end
end

__END__
diff --git a/cmake/Packages/Python.cmake b/cmake/Packages/Python.cmake
index a39b02b..faac349 100644
--- a/cmake/Packages/Python.cmake
+++ b/cmake/Packages/Python.cmake
@@ -9,10 +9,10 @@ ELSE()
     IF(PYTHON_EXECUTABLE)
         MESSAGE(WARNING "PYTHON_EXECUTABLE is set but will be ignored by this version of CMake; set Python_ROOT_DIR instead")
     ENDIF(PYTHON_EXECUTABLE)
-    IF(CMAKE_VERSION VERSION_LESS 3.14.0) 
+    IF(CMAKE_VERSION VERSION_LESS 3.14.0)
       FIND_PACKAGE(Python COMPONENTS Interpreter Development)
     ELSE()
-      FIND_PACKAGE(Python COMPONENTS Interpreter Development NumPy)
+      FIND_PACKAGE(Python 3.12 EXACT COMPONENTS Interpreter Development NumPy)
       SET(NUMPY_FOUND "${Python_NumPy_FOUND}")
       SET(NUMPY_INCLUDE_DIR ${Python_NumPy_INCLUDE_DIRS} CACHE STRING "Numpy directory")
       STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" NUMPY_VERSION_MAJOR "${Python_NumPy_VERSION}")
