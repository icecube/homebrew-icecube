require 'formula'


class Geant < Formula
  homepage 'http://geant4.web.cern.ch/geant4/'
  url 'http://geant4.web.cern.ch/geant4/support/source/geant4.9.6.tar.gz'
  sha1 '56580c79d446a67285b3540992555ea191c1c322'

  depends_on 'cmake' => :build

  def install
    Dir.chdir("..")
    system "mv", "geant4.9.6", "geant4.9.6_src"
    system "mkdir", "geant4.9.6"
    Dir.chdir("geant4.9.6")
    system "cmake", "../geant4.9.6_src", "-DGEANT4_INSTALL_DATA=ON", *std_cmake_args
    system "make", "install"
  end

end
