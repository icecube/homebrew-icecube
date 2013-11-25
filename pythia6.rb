require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Pythia6 < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/pythia6.tar.gz'
  sha1 '95d9d4af4584416680390f5b3812be743f36bd64'
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
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test pythia`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "--version"`.
    system "false"
  end
end
