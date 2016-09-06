require 'formula'

class Rdmc < Formula
  homepage 'http://code.icecube.wisc.edu/'
  url 'http://code.icecube.wisc.edu/tools/distfiles/rdmc/rdmc-2.9.5.tar.bz2'
  sha256 '90aeb5cc5dd00a5f3182c3966bbcb8d20d2f6494b6bfda59f2231b89c37416d1'

  def install
    inreplace 'Makefile.in', '$(libdir)/@PACKAGE@', '$(libdir)'

    system "./configure", "--prefix=#{prefix}",
                          "--includedir=${prefix}/include/#{name}-#{version}",
                          "--libdir=${prefix}/lib/#{name}-#{version}"

    system "make", "install"
  end

  test do
    system "true"
  end
end
