class Sprng2 < Formula
  desc "Scalable/portable PRNG libraries, focused on parallel Monte Carlo simulation"
  homepage "http://www.sprng.org/Version2.0/"
  url "http://code.icecube.wisc.edu/tools/distfiles/sprng/sprng2.0a.tgz"
  version "2.0a"
  sha256 "bcfa9e0501c4aba8f3e7bd7a728ae8d1e9ae771fc9d985d677f76f87b937454e"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/sprng2-2.0a"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6416f3c78e332bcf994c086b4586ed4bc03722dfc1d9ad4d0d187ec52230133d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493bd93cd580690873fd72d6a36ad4c277027c85ba6061c319a7b82941f3b0b4"
  end

  depends_on "gmp" if RUBY_PLATFORM.include? "darwin"

  # fixes the makefiles and inline assembly
  patch :DATA

  def install
    ENV.deparallelize
    rm("SRC/pmlcg/gmp.h")
    system "make", "src", "tests"

    # fix permissions
    chmod 0644, Dir["include/*.h"]

    sprnginclude = include/"sprng"
    sprnginclude.install Dir["include/*.h"]
    lib.install "lib/libsprng.a"
  end

  test do
    (testpath/"test.cxx").write <<-EOS
    #define SIMPLE_SPRNG
    #include "sprng/sprng.h"
    int main()
    {
      init_sprng(DEFAULT_RNG_TYPE,1,SPRNG_DEFAULT);
      sprng();
      isprng();
    }
    EOS

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lsprng"
    system "./test"
  end
end

__END__
diff -ur sprng2.0.old/Makefile sprng2.0/Makefile
--- sprng2.0.old/Makefile	1999-06-29 12:42:10
+++ sprng2.0/Makefile	2023-04-12 21:29:39
@@ -26,6 +26,8 @@
 
 all : src examples tests
 
+.PHONY: src examples tests
+
 src :
 	(cd SRC; $(MAKE) ; cd ..)
 
diff -ur sprng2.0.old/SRC/make.GENERIC sprng2.0/SRC/make.GENERIC
--- sprng2.0.old/SRC/make.GENERIC	1999-06-29 12:42:11
+++ sprng2.0/SRC/make.GENERIC	2023-04-12 21:29:39
@@ -26,7 +26,7 @@
 # Try adding: -DGENERIC to CFLAGS. This can improve speed, but may give
 # incorrect values. Check with 'checksprng' to see if it works.
 
-CFLAGS = -O $(PMLCGDEF) $(MPIDEF)
+CFLAGS = -O $(PMLCGDEF) $(MPIDEF) -fPIC
 CLDFLAGS = -O
 FFLAGS = -O $(PMLCGDEF) $(MPIDEF)
 F77LDFLAGS = -O
diff -ur sprng2.0.old/SRC/make.INTEL sprng2.0/SRC/make.INTEL
--- sprng2.0.old/SRC/make.INTEL	1999-06-29 12:42:11
+++ sprng2.0/SRC/make.INTEL	2023-04-12 21:29:39
@@ -6,8 +6,8 @@
 CC = gcc
 CLD = $(CC)
 # Set f77 to echo if you do not have a FORTRAN compiler
-F77 = g77
-#F77 = echo
+#F77 = g77
+F77 = echo
 F77LD = $(F77)
 FFXN = -DAdd__
 FSUFFIX = F
@@ -20,14 +20,14 @@
 # Also, if the previous compilation was without MPI, type: make realclean
 # before compiling for mpi.
 #
-MPIDIR = -L/usr/local/mpi/build/LINUX/ch_p4/lib
-MPILIB = -lmpich
+#MPIDIR = -L/usr/local/mpi/build/LINUX/ch_p4/lib
+#MPILIB = -lmpich
 
 # Please include mpi header file path, if needed
 
-CFLAGS = -O3 -DLittleEndian $(PMLCGDEF) $(MPIDEF) -D$(PLAT)  -I/usr/local/mpi/include -I/usr/local/mpi/build/LINUX/ch_p4/include
+CFLAGS = -O3 -DLittleEndian -D$(PLAT) -fPIC -IHOMEBREW_PREFIX/include
 CLDFLAGS =  -O3 
-FFLAGS = -O3 $(PMLCGDEF) $(MPIDEF) -D$(PLAT)  -I/usr/local/mpi/include -I/usr/local/mpi/build/LINUX/ch_p4/include -I.
+FFLAGS = -O3 -D$(PLAT) -I.
 F77LDFLAGS =  -O3 
 
 CPP = cpp -P
diff -ur sprng2.0.old/SRC/pmlcg/Makefile sprng2.0/SRC/pmlcg/Makefile
--- sprng2.0.old/SRC/pmlcg/Makefile	1999-06-29 12:42:11
+++ sprng2.0/SRC/pmlcg/Makefile	2023-04-12 21:29:39
@@ -23,7 +23,7 @@
 all : pmlcg.o
 
 
-pmlcg.o : $(SRCDIR)/interface.h pmlcg.c  pmlcg.h $(SRCDIR)/memory.h  basic.h info.h gmp.h longlong.h $(SRCDIR)/store.h $(SRCDIR)/fwrap_.h
+pmlcg.o : $(SRCDIR)/interface.h pmlcg.c  pmlcg.h $(SRCDIR)/memory.h  basic.h info.h longlong.h $(SRCDIR)/store.h $(SRCDIR)/fwrap_.h
 	$(CC) -c $(CFLAGS)  $(FFXN) $(INLINEOPT) pmlcg.c -I$(SRCDIR)
 
 clean :
diff -ur sprng2.0.old/SRC/pmlcg/longlong.h sprng2.0/SRC/pmlcg/longlong.h
--- sprng2.0.old/SRC/pmlcg/longlong.h	1999-06-29 12:42:11
+++ sprng2.0/SRC/pmlcg/longlong.h	2023-04-12 21:29:39
@@ -439,8 +439,7 @@
 
 #if (defined (__i386__) || defined (__i486__)) && W_TYPE_SIZE == 32
 #define add_ssaaaa(sh, sl, ah, al, bh, bl) \
-  __asm__ ("addl %5,%1
-	adcl %3,%0"							\
+  __asm__ ("addl %5,%1 \n adcl %3,%0"		         		\
 	   : "=r" ((USItype)(sh)),					\
 	     "=&r" ((USItype)(sl))					\
 	   : "%0" ((USItype)(ah)),					\
@@ -448,8 +447,7 @@
 	     "%1" ((USItype)(al)),					\
 	     "g" ((USItype)(bl)))
 #define sub_ddmmss(sh, sl, ah, al, bh, bl) \
-  __asm__ ("subl %5,%1
-	sbbl %3,%0"							\
+  __asm__ ("subl %5,%1 \n sbbl %3,%0"           			\
 	   : "=r" ((USItype)(sh)),					\
 	     "=&r" ((USItype)(sl))					\
 	   : "0" ((USItype)(ah)),					\
diff -ur sprng2.0.old/SRC/pmlcg/pmlcg.c sprng2.0/SRC/pmlcg/pmlcg.c
--- sprng2.0.old/SRC/pmlcg/pmlcg.c	1999-06-29 12:42:11
+++ sprng2.0/SRC/pmlcg/pmlcg.c	2023-04-12 21:29:39
@@ -32,6 +32,7 @@
 #include "pmlcg.h"
 #include "gmp.h"
 #include "basic.h"
+#include "store.h"
 #include <math.h>
 
 #define init_rng pmlcg_init_rng
diff -ur sprng2.0.old/SRC/primes_32.c sprng2.0/SRC/primes_32.c
--- sprng2.0.old/SRC/primes_32.c	1999-06-29 12:42:11
+++ sprng2.0/SRC/primes_32.c	2023-04-12 21:29:39
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include "primes_32.h"
 #include "primelist_32.h"
 
diff -ur sprng2.0.old/SRC/primes_64.c sprng2.0/SRC/primes_64.c
--- sprng2.0.old/SRC/primes_64.c	1999-06-29 12:42:11
+++ sprng2.0/SRC/primes_64.c	2023-04-12 21:29:39
@@ -1,5 +1,6 @@
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include "primes_64.h"
 #include "primelist_64.h"
 
diff -ur sprng2.0.old/SRC/sprng/sprng.c sprng2.0/SRC/sprng/sprng.c
--- sprng2.0.old/SRC/sprng/sprng.c	1999-06-29 12:42:10
+++ sprng2.0/SRC/sprng/sprng.c	2023-04-12 21:29:39
@@ -24,6 +24,7 @@
 #include "memory.h"
 #include "sprng.h"
 #include "interface.h"
+#include "store.h"
 
 #include "lfg/lfg.h"
 #include "lcg/lcg.h"
diff -ur sprng2.0.old/TESTS/chisquare.c sprng2.0/TESTS/chisquare.c
--- sprng2.0.old/TESTS/chisquare.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/chisquare.c	2023-04-12 21:38:37
@@ -3,6 +3,8 @@
 **********************************************************/
 
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 #include <math.h>
 #include "util.h"
 
Only in sprng2.0/TESTS: chisquare.c~
diff -ur sprng2.0.old/TESTS/collisions.c sprng2.0/TESTS/collisions.c
--- sprng2.0.old/TESTS/collisions.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/collisions.c	2023-04-12 21:29:39
@@ -1,4 +1,6 @@
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 #include "tests.h"
 #include <math.h>
 
diff -ur sprng2.0.old/TESTS/coupon.c sprng2.0/TESTS/coupon.c
--- sprng2.0.old/TESTS/coupon.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/coupon.c	2023-04-12 21:29:39
@@ -1,4 +1,6 @@
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 #include "tests.h"
 
 #ifndef ANSI_ARGS
@@ -19,7 +21,7 @@
 
 
 #ifdef __STDC__
-main(int argc, char *argv[])
+int main(int argc, char *argv[])
 #else
 main(argc, argv)
 int argc;
diff -ur sprng2.0.old/TESTS/init_tests.c sprng2.0/TESTS/init_tests.c
--- sprng2.0.old/TESTS/init_tests.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/init_tests.c	2023-04-12 21:29:39
@@ -2,6 +2,7 @@
 #include <mpi.h>
 #endif
 #include <stdio.h>
+#include <stdlib.h>
 /*#define READ_FROM_STDIN*/   /* read random numbers from stdin */
 #ifndef READ_FROM_STDIN
 #include "sprng.h"
diff -ur sprng2.0.old/TESTS/maxt.c sprng2.0/TESTS/maxt.c
--- sprng2.0.old/TESTS/maxt.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/maxt.c	2023-04-12 21:29:39
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <stdlib.h>
 #include "tests.h"
 #include <math.h>
 
@@ -19,7 +20,7 @@
 
 
 #ifdef __STDC__
-main(int argc, char *argv[])
+int main(int argc, char *argv[])
 #else
 main(argc, argv)
 int argc;
diff -ur sprng2.0.old/TESTS/metropolis.c sprng2.0/TESTS/metropolis.c
--- sprng2.0.old/TESTS/metropolis.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/metropolis.c	2023-04-12 21:32:42
@@ -336,7 +336,7 @@
 /* block_size*use_blocks sweeps through a lattice of size 
 lattice_size*lattice_size using the Metropolis algorithm for the Ising model */
 
-void main(int argc, char **argv)
+int main(int argc, char **argv)
 {
   /*--- Add rng_time as the 1st argument ---*/
   int rng_type;
diff -ur sprng2.0.old/TESTS/poker.c sprng2.0/TESTS/poker.c
--- sprng2.0.old/TESTS/poker.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/poker.c	2023-04-12 21:30:28
@@ -1,4 +1,6 @@
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
 #include "tests.h"
 #include <math.h>
 
@@ -14,13 +16,13 @@
 double poker ANSI_ARGS((long n, int k, int d));
 double stirling ANSI_ARGS((int n, int m));
 
-static int ncatagories = 0, *bins, *index, Bins_used=0;
+static int ncatagories = 0, *bins, *idx, Bins_used=0;
 long *actual;
 double *probability;
 
 
 #ifdef __STDC__
-main(int argc, char *argv[])
+int main(int argc, char *argv[])
 #else
 main(argc, argv)
 int argc;
@@ -71,7 +73,7 @@
   free(bins);
   free(actual);
   free(probability);
-  free(index);
+  free(idx);
 
 #if defined(SPRNG_MPI)
      MPI_Finalize();
@@ -93,7 +95,7 @@
   long sum;
   
   bins = (int *) mymalloc(d*sizeof(int));
-  index = (int *) mymalloc((k+1)*sizeof(int));
+  idx = (int *) mymalloc((k+1)*sizeof(int));
   pr = (double *) mymalloc((k+1)*sizeof(double));
   temp = pow((double) d, - (double) k);
   
@@ -107,7 +109,7 @@
   sum = 0;
   for(i=1; i<=k; i++)
   {
-    index[i] = ncatagories;
+    idx[i] = ncatagories;
     sum += n*pr[i];
     
     if(sum > 5 && i < k)
@@ -125,7 +127,7 @@
     probability[i] = 0.0;
   
   for(i=1; i<=k; i++)
-    probability[index[i]] += pr[i];
+    probability[idx[i]] += pr[i];
   
   free(pr);
 }
@@ -157,7 +159,7 @@
     for(j=0; j<d; j++)
       sum += bins[j];
     
-    actual[index[sum]]++;
+    actual[idx[sum]]++;
   }
   
   temp = chisquare(actual,probability,n, ncatagories, &Bins_used);
diff -ur sprng2.0.old/TESTS/random_walk.c sprng2.0/TESTS/random_walk.c
--- sprng2.0.old/TESTS/random_walk.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/random_walk.c	2023-04-12 21:37:31
@@ -2,6 +2,7 @@
    et al  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include "tests.h"
 #include <math.h>
 
@@ -19,7 +20,7 @@
 
 
 #ifdef __STDC__
-main(int argc, char *argv[])
+int main(int argc, char *argv[])
 #else
 main(argc, argv)
 int argc;
Only in sprng2.0/TESTS: random_walk.c~
diff -ur sprng2.0.old/TESTS/stirling.c sprng2.0/TESTS/stirling.c
--- sprng2.0.old/TESTS/stirling.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/stirling.c	2023-04-12 21:29:39
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <stdlib.h>
 #include "util.h"
 
 
diff -ur sprng2.0.old/TESTS/sum.c sprng2.0/TESTS/sum.c
--- sprng2.0.old/TESTS/sum.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/sum.c	2023-04-12 21:31:36
@@ -2,6 +2,7 @@
 
 
 #include <stdio.h>
+#include <stdlib.h>
 #if defined(SPRNG_MPI)
 #include "mpi.h"
 #endif
@@ -18,7 +19,7 @@
 
 int group_size;
 
-main(int argc, char *argv[])
+int main(int argc, char *argv[])
 {
   int ntests, n, *stream, i, j, k;
   double result, rn, *temparray, *sumarray;
diff -ur sprng2.0.old/TESTS/wolff.c sprng2.0/TESTS/wolff.c
--- sprng2.0.old/TESTS/wolff.c	1999-06-29 12:42:11
+++ sprng2.0/TESTS/wolff.c	2023-04-12 21:32:30
@@ -309,7 +309,7 @@
 /* block_size*use_blocks sweeps through a lattice of size 
    lattice_size*lattice_size using the Wolff algorithm for the Ising model */
 
-void main(int argc, char **argv)
+int main(int argc, char **argv)
 {
   /*--- Add rng_type as the argument to the new interface ---*/
   int rng_type;
diff -ur sprng2.0.old/make.CHOICES sprng2.0/make.CHOICES
--- sprng2.0.old/make.CHOICES	1999-06-29 12:42:11
+++ sprng2.0/make.CHOICES	2023-04-12 21:29:39
@@ -62,8 +62,8 @@
 # comment out if you want to exclude generator pmlcg which needs libgmp 
 #---------------------------------------------------------------------------
 
-PMLCGDEF = -DUSE_PMLCG
-GMPLIB = -lgmp
+#PMLCGDEF = -DUSE_PMLCG
+#GMPLIB = -lgmp
 
 ############################################################################
 
