require 'formula'

class Pythia6 < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/pythia6.tar.gz'
  version '6.4.16'

  depends_on :fortran

  def patches
    { :p0 => [ "https://gist.github.com/nega0/7553410/raw" ,  # create Makefile
               "https://gist.github.com/nega0/7553457/raw" ,  # create main.c
               "https://gist.github.com/nega0/7553483/raw" ,  # create pythia6_rng_callback.c
               "https://gist.github.com/nega0/7553491/raw" ,] # redefine PYR
    }
  end

  def install
    ENV['FFLAGS'] = "-m64 -fPIC"
    ENV['PREFIX'] = "#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
