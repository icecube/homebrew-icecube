require 'formula'

class Rdmc < Formula
  homepage 'http://code.icecube.wisc.edu/'
  url 'http://code.icecube.wisc.edu/tools/distfiles/rdmc/rdmc-2.9.5.tar.bz2'
  sha1 '6fc3699ee3db05d8b7580ffae8e45b710b700bae'

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
