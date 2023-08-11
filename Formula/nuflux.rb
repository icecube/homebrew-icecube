class Nuflux < Formula
  desc "Library for calculating atmospheric neutrino fluxes"
  homepage "https://docs.icecube.aq/nuflux/main"
  url "https://github.com/icecube/nuflux/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "e7c95901ffc2d1a5c8cbe3f0a24c0277156762d131ef0facaad28b2b931bcfa7"
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

  def python3
    "python3.11"
  end

  def install
    mkdir "build" do
      system "meson", "setup", *std_meson_args, "--python.platlibdir", "#{lib}/python3.11/site-packages/",
        "--python.purelibdir", "#{lib}/python3.11/site-packages/", ".."
      # system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    system "python3", "-c", "assert __import__('nuflux').makeFlux('H3a_SIBYLL21').getFlux(14,1e5,0)>0"
  end
end
