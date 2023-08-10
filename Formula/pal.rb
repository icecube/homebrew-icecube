class Pal < Formula
  desc "Positional Astronomy Library"
  homepage "https://github.com/Starlink/pal"
  url "https://github.com/Starlink/pal/releases/download/v0.9.8/pal-0.9.8.tar.gz"
  sha256 "191fde8c4f45d6807d4b011511344014966bb46e44029a4481d070cd5e7cc697"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/pal-0.9.8"
    rebuild 1
    sha256 cellar: :any, ventura:  "c6ce026563abafd4f225b4bc3b32fa34986441c20c94af279d95ff03b600c08b"
    sha256 cellar: :any, monterey: "a42983cbded9505ff382fc58fab3ed62fc72c20d0a1c32a63686a1bfcd3bce2e"
    sha256 cellar: :any, big_sur:  "7c2016815139a09a6bbc0b9e18c9e9830887252b3c83fc48c7c5c508c276b5e6"
  end

  depends_on "erfa"
  # batteries not included
  if RUBY_PLATFORM.include?("darwin")
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  patch :DATA
  def install
    # Fix -flat_namespace usage on macOS.
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress",
      "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-debug", "--without-starlink",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
      #include <star/pal.h>

      int main () {
        char verstring[32];
        int ver = palVers( verstring, sizeof(verstring));
        return 0;
      }
    EOF

    flags = %W[
      -I#{include}
      -L#{lib}
      -lpal
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
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
