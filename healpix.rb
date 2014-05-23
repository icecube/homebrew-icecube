require 'formula'

class Healpix < Formula
  homepage 'http://healpix.jpl.nasa.gov/'
  url 'http://downloads.sourceforge.net/project/healpix/Healpix_3.11/Healpix_3.11_2013Apr24.tar.gz'
  sha1 'f7d6a18ca6aad9fe85a66eca36d7a1f0ef783e95'
  version '3.11'

  depends_on 'cfitsio'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  patch :DATA

  def install
    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end

    cd "src/cxx/autotools" do
      system "autoreconf", "--install"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end
end

__END__
diff --git a/src/cxx/autotools/Makefile.am b/src/cxx/autotools/Makefile.am
index b0ddfd2..fc854be 100644
--- a/src/cxx/autotools/Makefile.am
+++ b/src/cxx/autotools/Makefile.am
@@ -1,4 +1,5 @@
 ACLOCAL_AMFLAGS = -I m4
+AUTOMAKE_OPTIONS = subdir-objects
 
 lib_LTLIBRARIES = libhealpix_cxx.la
 
