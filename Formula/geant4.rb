class Geant4 < Formula
  desc "Toolkit for the simulation of the passage of particles through matter"
  homepage "https://geant4.web.cern.ch/"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.3.2/geant4-v11.3.2.tar.bz2"
  sha256 "2272ff8d67ac01419ea2dc3a0877c68c6027e936a1c391072cc569902db360a9"
  license ""

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/geant4-11.3.2"
    sha256 arm64_sequoia: "b9ab9034ae332fe2bd8309fd8ef52d458ac5f251b6725e7232b736300a27736f"
    sha256 arm64_sonoma:  "d2d2dafb2a4214bc4dd461cb52fefe2ad6fd5925e59c2440b674c0f47dcd4893"
  end

  depends_on "cmake" => :build

  # Additional dependency
  # resource "" do
  #   url ""
  #   sha256 ""
  # end

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
      "-DGEANT4_INSTALL_EXAMPLES=OFF",
      "-DGEANT4_USE_SYSTEM_ZLIB=ON",
      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    "
    This formula does not install the Geant4 datasets.

    You can install them yourself in to their default location by running:

      geant4-config --install-datasets

    You can also install them by hand anywhere you like, but you must set
    the environment variable GEANT4_DATA_DIR to that location.
    "
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test geant4`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "true"
  end
end
