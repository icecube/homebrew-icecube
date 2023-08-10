class Nuflux < Formula
  desc "Library for calculating atmospheric neutrino fluxes"
  homepage "https://docs.icecube.aq/nuflux/main"
  url "https://github.com/icecube/nuflux/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "e7c95901ffc2d1a5c8cbe3f0a24c0277156762d131ef0facaad28b2b931bcfa7"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/nuflux-2.0.3"
    rebuild 1
    sha256 ventura:  "3556bb54755cdc04b3a6654f18efb41d6752b0f1a68952527ee0aef261237e29"
    sha256 monterey: "dd735b25bfdbbc35bf7bb0bc31016132b114c2ab63e1ec82be635a2e3797cf91"
    sha256 big_sur:  "cb2dd3bb0b95ba219413176493136344f591818e753f72d50ad481c73ece75b5"
  end

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
    mkdir "build" do
      system "meson", "setup", *std_meson_args, ".."
      system "meson", "compile"
      system "meson", "install"
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

