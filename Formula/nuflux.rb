class Nuflux < Formula
  desc "Library for calculating atmospheric neutrino fluxes"
  homepage "https://docs.icecube.aq/nuflux/main"
  url "https://github.com/icecube/nuflux/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "65cb0c284cc46e1006f1eb1fba296b84e30a148d4386887de152961ba711d6b8"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/nuflux-2.0.4"
    sha256 arm64_ventura:  "28c738c6ce67d1db87a10cf82dcf1c8e493024b7d64a3b5b9dfcecbda7aa3f19"
    sha256 arm64_monterey: "c854abff56dae79e91a75e54506e9e7505eb0787f76b6a1f31f4485b40eb9804"
    sha256 ventura:        "5ba8c21b0d93a281602a12d2636dbd112bc1dd951e292ffe9f9b1fc129e268a5"
    sha256 monterey:       "91592a23872968fcc9abace224facf529b5e59ba84d678b5097800fb4c1fbd67"
    sha256 big_sur:        "d85ea4e6caaa664388136503628ee81e50f5503a4c3ca0607d706744e412fe72"
  end

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
