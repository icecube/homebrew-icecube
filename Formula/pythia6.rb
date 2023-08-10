class Pythia6 < Formula
  desc "CERN's Pythia6 patched for IceCube"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/pythia6.tar.gz"
  version "6.4.16"
  sha256 "d613dcb27c905710e2f13a934913cc5545e3e5d0e477e580107385d9ef260056"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/pythia6-6.4.16"
    rebuild 1
    sha256 cellar: :any, ventura:  "aceccac09fe62dbc81b35dd3fd7d406d8b47574689259b4ea2a24a3be1f05080"
    sha256 cellar: :any, monterey: "9a6635075fb0a00f1125faeff69d0f0120a92a16ea8e8bb8ba7733a7cf2f08ae"
    sha256 cellar: :any, big_sur:  "66141db7c62d51a3c6adabbba1f9ca3ed53af53fe24c42965d5836bf2606b569"
  end

  depends_on "gcc" # for gfortran

  patch :p0 do
    # create Makefile
    url "https://gist.githubusercontent.com/nega0/7553410/raw/6ae12fa4ee43e819d15bb2ced00968c6a57ec1cf/Makefile.generic.patch"
    sha256 "adec0036abe325cdfa3818df84792f2b5ba17fe7355edd7cc747a7b96cb1dfe6"
  end
  patch :p0 do
    # create main.c
    url "https://gist.github.com/nega0/7553457/raw/20fa5efe12d336003873ccf0cfb51f0d3e3a5e81/main.c.patch"
    sha256 "0ae9f5a25f5230df4523f5214ce2c4152276cd657f525373a85fc42da3f842dd"
  end
  patch :p0 do
    # create pythia6_rng_callback.c
    url "https://gist.github.com/nega0/7553483/raw/c119108fbe86c6bd8372507713a4077d1ceff3a9/pythia6_rng_callback.c.patch"
    sha256 "662f4bc331d73d00b60d1c27658d9b02f28a2b1f4d4ee5971bf8c2b9787c5558"
  end
  patch :p0 do
    # redefine PYR
    url "https://gist.githubusercontent.com/nega0/7553491/raw/2baf9186eeae3bf9fa03bf6aebc3ec71901767b5/pythia6416.f.patch"
    sha256 "b1e0f5e6fb6045cc613232012b2d85bfc31367c29e5b1d4571c59309a0b0bec5"
  end

  def install
    inreplace "Makefile", /^CFLAGS/, "#CFLAGS"
    ENV["CFLAGS"] = "-m64 -fPIC -O3"
    ENV["FFLAGS"] = "-m64 -fPIC -O3 -std=legacy"
    ENV["PREFIX"] = prefix.to_s
    ENV["FC"] = "gfortran"
    system "make", "install"
  end

  test do
    system "true"
  end
end
