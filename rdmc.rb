require 'formula'

class Rdmc < Formula
  homepage 'http://code.icecube.wisc.edu/'
  url 'http://code.icecube.wisc.edu/tools/distfiles/rdmc/rdmc-2.9.5.tar.bz2'
  sha256 '90aeb5cc5dd00a5f3182c3966bbcb8d20d2f6494b6bfda59f2231b89c37416d1'

  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    sha256 "5a6ab27f17d6fa6dc2248b998ca08f807c52dbe1056e03ff51fc44529bb647f5" => :sierra
  end
               
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
