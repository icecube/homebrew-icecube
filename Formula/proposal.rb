class Proposal < Formula
  desc "Monte Carlo Simulation propagating charged Leptons through Media as C++ Library"
  homepage "https://github.com/tudo-astroparticlephysics/PROPOSAL"
  url "https://github.com/tudo-astroparticlephysics/PROPOSAL/archive/refs/tags/7.4.2.tar.gz"
  sha256 "f0db44c96a80a6ce3dda02c598574f5f0209376bd2c6c176797710da8eb3e108"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "googletest" => :test
  depends_on "cubic_interpolation"
  depends_on "nlohmann-json"
  depends_on "spdlog"
  depends_on "pybind11" => :recommended

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]
    (build.with? "pybind11") && args += %w[-DBUILD_PYTHON=ON]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_TESTING=ON
    ]
    (build.with? "pybind11") && args += %w[-DBUILD_PYTHON=ON]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "-j#{ENV.make_jobs}", "--test-dir", "build"
  end
end
