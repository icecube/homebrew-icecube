require 'formula'

class Sprng2 < Formula
  homepage 'http://www.sprng.org/Version2.0/'
  url 'http://sprng.cs.fsu.edu/Version2.0/sprng2.0a.tgz'
  sha1 '139ea3f9ab623131907ba86cb4c7cbe491a23f71'
  sha256 'bcfa9e0501c4aba8f3e7bd7a728ae8d1e9ae771fc9d985d677f76f87b937454e'
  version "2.0a"

  if (RUBY_PLATFORM =~ /darwin/)
    depends_on 'gmp'
  end

  def patches
    # fixes the makefiles and inline assembly
    DATA
  end

  def install
    ENV.deparallelize
    rm("SRC/pmlcg/gmp.h")
    system "make", "src", "tests"

    # fix permissions
    chmod 0644, Dir["include/*.h"]

    sprnginclude = include+'sprng'
    sprnginclude.install Dir["include/*.h"]
    lib.install 'lib/libsprng.a'
  end
end

__END__
diff -ur sprng2.0.orig/make.CHOICES sprng2.0/make.CHOICES
--- sprng2.0.orig/make.CHOICES	1999-06-29 11:42:11.000000000 -0500
+++ sprng2.0/make.CHOICES	2013-10-29 19:13:35.000000000 -0500
@@ -62,8 +62,8 @@
 # comment out if you want to exclude generator pmlcg which needs libgmp 
 #---------------------------------------------------------------------------
 
-PMLCGDEF = -DUSE_PMLCG
-GMPLIB = -lgmp
+#PMLCGDEF = -DUSE_PMLCG
+#GMPLIB = -lgmp
 
 ############################################################################
 
diff -ur sprng2.0.orig/Makefile sprng2.0/Makefile
--- sprng2.0.orig/Makefile	1999-06-29 11:42:10.000000000 -0500
+++ sprng2.0/Makefile	2013-10-29 19:20:49.000000000 -0500
@@ -26,6 +26,8 @@
 
 all : src examples tests
 
+.PHONY: src examples tests
+
 src :
 	(cd SRC; $(MAKE) ; cd ..)
 
diff -ur sprng2.0.orig/SRC/make.GENERIC sprng2.0/SRC/make.GENERIC
--- sprng2.0.orig/SRC/make.GENERIC	1999-06-29 11:42:11.000000000 -0500
+++ sprng2.0/SRC/make.GENERIC	2013-10-29 19:19:46.000000000 -0500
@@ -26,7 +26,7 @@
 # Try adding: -DGENERIC to CFLAGS. This can improve speed, but may give
 # incorrect values. Check with 'checksprng' to see if it works.
 
-CFLAGS = -O $(PMLCGDEF) $(MPIDEF)
+CFLAGS = -O $(PMLCGDEF) $(MPIDEF) -fPIC
 CLDFLAGS = -O
 FFLAGS = -O $(PMLCGDEF) $(MPIDEF)
 F77LDFLAGS = -O
diff -ur sprng2.0.orig/SRC/make.INTEL sprng2.0/SRC/make.INTEL
--- sprng2.0.orig/SRC/make.INTEL	1999-06-29 11:42:11.000000000 -0500
+++ sprng2.0/SRC/make.INTEL	2013-10-29 19:19:25.000000000 -0500
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
diff -ur sprng2.0.orig/SRC/pmlcg/Makefile sprng2.0/SRC/pmlcg/Makefile
--- sprng2.0.orig/SRC/pmlcg/Makefile	1999-06-29 11:42:11.000000000 -0500
+++ sprng2.0/SRC/pmlcg/Makefile	2013-10-29 19:17:09.000000000 -0500
@@ -23,7 +23,7 @@
 all : pmlcg.o
 
 
-pmlcg.o : $(SRCDIR)/interface.h pmlcg.c  pmlcg.h $(SRCDIR)/memory.h  basic.h info.h gmp.h longlong.h $(SRCDIR)/store.h $(SRCDIR)/fwrap_.h
+pmlcg.o : $(SRCDIR)/interface.h pmlcg.c  pmlcg.h $(SRCDIR)/memory.h  basic.h info.h longlong.h $(SRCDIR)/store.h $(SRCDIR)/fwrap_.h
 	$(CC) -c $(CFLAGS)  $(FFXN) $(INLINEOPT) pmlcg.c -I$(SRCDIR)
 
 clean :
diff -ur sprng2.0.orig/SRC/pmlcg/longlong.h sprng2.0/SRC/pmlcg/longlong.h
--- sprng2.0.orig/SRC/pmlcg/longlong.h	1999-06-29 11:42:11.000000000 -0500
+++ sprng2.0/SRC/pmlcg/longlong.h	2013-10-29 19:21:47.000000000 -0500
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
