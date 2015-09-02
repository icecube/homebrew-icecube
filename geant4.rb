class Geant4 < Formula
  desc "Detector simulation toolkit"
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.9.5.p02.tar.gz"
  version "9.5.2"
  sha256 "adb04fce9472228bb10d78cbc7f40493bfb37454beee22e7c80d630646cd3777"

  conflicts_with "geant", :because => "Differing versions of the same formula"

  depends_on "cmake" => :build
  depends_on :x11
  depends_on "qt" => :optional

  def install
    mkdir "geant-build" do
      args = %W[  ../
                  -DGEANT4_INSTALL_DATA=ON
                  -DGEANT4_USE_OPENGL_X11=ON
                  -DGEANT4_USE_RAYTRACER_X11=ON
                  -DGEANT4_INSTALL_EXAMPLES=ON  ]

      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"

      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    ENV["G4ABLADATA"] = "#{share}/Geant4-9.5.2/data/G4ABLA3.0"
    ENV["G4LEDATA"] = "#{share}/Geant4-9.5.2/data/G4EMLOW6.23"
    ENV["G4LEVELGAMMADATA"] = "#{share}/Geant4-9.5.2/data/PhotonEvaporation2.2"
    ENV["G4NEUTRONHPDATA"] = "#{share}/Geant4-9.5.2/data/G4NDL4.0"
    ENV["G4NEUTRONXSDATA"] = "#{share}/Geant4-9.5.2/data/G4NEUTRONXS1.1"
    ENV["G4PIIDATA"] = "#{share}/Geant4-9.5.2/data/G4PII1.3"
    ENV["G4RADIOACTIVEDATA"] = "#{share}/Geant4-9.5.2/data/RadioactiveDecay3.4"
    ENV["G4REALSURFACEDATA"] = "#{share}/Geant4-9.5.2/data/RealSurface1.0"
    system "cmake", "#{share}/Geant4-9.5.2/examples/basic/B1"
    assert_equal 0, $?.exitstatus
    system "make"
    assert_equal 0, $?.exitstatus
    system "./exampleB1", "run2.mac"
    assert_equal 0, $?.exitstatus
  end
end
