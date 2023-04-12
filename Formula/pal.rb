require "formula"

class Pal < Formula
  #bottle do
  #  root_url "http://code.icecube.wisc.edu/tools/bottles/"
  #  cellar :any
  #  sha256 "dc8d557cb13acdcfbf5d8db0f121b962e4b9b02aca6802c857c6fe11a47a3a82" => :sierra
  #  sha256 "ce0e56c0554480817510f655aa4ffdea97c6fa03e74b7124c33f22275ecc461a" => :el_capitan
  #  sha256 "588d8843a34f04a6d8b20757084f7282c49c34b41ad038ac073c64827cf0da2d" => :high_sierra
  #  rebuild 1
  #  sha256 "fc270082b3e2af5f6923bac32f42b10bb8af2eee8829af22b149cf584aa6bd00" => :mojave
  #end

  homepage "https://github.com/Starlink/pal"
  version "0.9.8"
  url "https://github.com/Starlink/pal/releases/download/v0.9.8/pal-0.9.8.tar.gz"
  sha256 "191fde8c4f45d6807d4b011511344014966bb46e44029a4481d070cd5e7cc697"

  depends_on "erfa"
  # batteries not included
  if (RUBY_PLATFORM =~ /darwin/)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  patch :DATA
  def install
    system "./configure", "--disable-debug", "--without-starlink",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
__END__
diff -ur pal-0.9.8.old/palDfltin.c pal-0.9.8/palDfltin.c
--- pal-0.9.8.old/palDfltin.c	2018-06-28 18:52:17.000000000 -0400
+++ pal-0.9.8/palDfltin.c	2023-04-12 17:34:31.000000000 -0400
@@ -105,6 +105,12 @@
 #endif
 #endif
 
+/* System include files */
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <ctype.h>
+
 /* isblank() is a C99 feature so we just reimplement it if it is missing */
 #if HAVE_ISBLANK
 #define _POSIX_C_SOURCE 200112L
@@ -123,12 +129,6 @@
 #include <bsd/string.h>
 #endif
 
-/* System include files */
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-#include <ctype.h>
-
 #include "pal.h"
 
 #if HAVE_COPYSIGN
