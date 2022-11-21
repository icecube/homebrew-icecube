class Nuflux < Formula
  desc "A library for calculating atmospheric neutrino fluxes."
  homepage "https://docs.icecube.aq/nuflux/main"
  url "https://github.com/icecube/nuflux/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "b7a3c88107c73b81bf021acd5e6e69f9646811cc041b1dc14fffbdffcd736981"
  license "LGPL-3.0"

  depends_on "boost-python3"
  depends_on "numpy"
  depends_on "cfitsio"
  depends_on "icecube/icecube/photospline"
  depends_on "pkg-config" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      ENV["PATH"] +=":/usr/local/bin"
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "python3", "-c", "assert __import__('nuflux').makeFlux('H3a_SIBYLL21').getFlux(14,1e5,0)>0"
  end
end
