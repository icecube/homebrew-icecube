class CubicInterpolation < Formula
  desc "Lightweight interpolation library based on boost and eigen"
  homepage "https://github.com/tudo-astroparticlephysics/cubic_interpolation"
  url "https://github.com/tudo-astroparticlephysics/cubic_interpolation/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "fc34de15c9dd9e651728c9e0eee5528ee9636e41a3d8aa6f41735018810afd59"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "true"
  end
end
