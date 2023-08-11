class Pal < Formula
  desc "Positional Astronomy Library"
  homepage "https://github.com/Starlink/pal"
  url "https://github.com/Starlink/pal/releases/download/v0.9.8/pal-0.9.8.tar.gz"
  sha256 "191fde8c4f45d6807d4b011511344014966bb46e44029a4481d070cd5e7cc697"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/pal-0.9.8"
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "ce4e14764976bf501554bdc8a5bcc59b7341b00c26c057f856b02fb6cb9af462"
    sha256 cellar: :any, arm64_monterey: "905666d01a2497e54505bd1bf638b9a473973ce9392f84f85f7b8112d38ae8b9"
    sha256 cellar: :any, ventura:        "a73efab6aeeb36afaf60d2aec5261d0956482f946932cbb450008a3f2dd17d21"
    sha256 cellar: :any, monterey:       "818ba32128331926f3c58fb94a107f6406a8aed5219f375805ce7d1b35e9661a"
    sha256 cellar: :any, big_sur:        "ee197635c489609411e34968e8abc35263388d70c01c1badf83216816c9192e2"
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
