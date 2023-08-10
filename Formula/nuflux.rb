class Nuflux < Formula
  desc "Library for calculating atmospheric neutrino fluxes"
  homepage "https://docs.icecube.aq/nuflux/main"
  url "https://github.com/icecube/nuflux/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "b7a3c88107c73b81bf021acd5e6e69f9646811cc041b1dc14fffbdffcd736981"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost-python3"
  depends_on "cfitsio"
  depends_on "icecube/icecube/photospline"
  depends_on "numpy"
  depends_on "python@3.11"

  patch :DATA

  def python3
    "python3.11"
  end

  def install
    inreplace "meson_options.txt", "value : 'True'", "value : true"
    inreplace "meson.build", "c++11", "c++14" # numpy wants 14 now
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system "python3", "-c", "assert __import__('nuflux').makeFlux('H3a_SIBYLL21').getFlux(14,1e5,0)>0"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 10a384a..38de592 100644
--- a/meson.build
+++ b/meson.build
@@ -57,6 +57,7 @@ cppcomp = meson.get_compiler('cpp')
 pymod = import('python')
 python = pymod.find_installation(get_option('python'),required: false)
 
+if false
 if not python.found()
   warning('Can\'t find python: "'+get_option('python')+'", skipping python build')
 else
@@ -100,5 +101,7 @@ else
   endif
 
 endif
+endif
 
+test('test_fluxes',find_program('tests/test_fluxes.py'))
 subdir('docs')

