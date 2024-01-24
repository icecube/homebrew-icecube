class Nuflux < Formula
  desc "Library for calculating atmospheric neutrino fluxes"
  homepage "https://docs.icecube.aq/nuflux/main"
  url "https://github.com/icecube/nuflux/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "65cb0c284cc46e1006f1eb1fba296b84e30a148d4386887de152961ba711d6b8"
  license "LGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "boost-python3"
  depends_on "cfitsio"
  depends_on "icecube/icecube/photospline"
  depends_on "numpy"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    mkdir "build" do
      ENV["BOOST_ROOT"] = HOMEBREW_PREFIX.to_s
      system "meson", "setup", *std_meson_args, "--python.platlibdir",
        "#{prefix}/"+Language::Python.site_packages(python3), ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "python3", "-c", "assert __import__('nuflux').makeFlux('H3a_SIBYLL21').getFlux(14,1e5,0)>0"
  end
end
