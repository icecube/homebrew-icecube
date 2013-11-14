require 'formula'

class SlalibC < Formula
  homepage 'http://www.starlink.rl.ac.uk/star/docs/sun67.htx/sun67.html'
  url 'http://code/tools/distfiles/slalib-c/slalib-c-0.0.tar.bz2'
  sha1 '63ba09b9297f3263d3c0240df9efda64b4bd01bb'

  def install
    inreplace 'makefile' do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", "-c"
    end
    system "make"
    lib.install 'libsla.a'
    include.install 'slalib.h', 'slamac.h'
  end

  test do
    system "true"
  end

  def patches
    DATA
  end
end

__END__
diff --git a/makefile b/makefile
index aecc44a..7ec2619 100644
--- a/makefile
+++ b/makefile
@@ -3,7 +3,7 @@
 # Description:  make file for the ANSI-C version of SLALIB.  This
 # makefile creates a Unix .a library.  Designed for Linux/gcc but
 # can be adapted for other platforms or run in an appropriate way -
-# for example on Sun/Solaris type "make CCOMPC=cc CFLAGC=-c". 
+# for example on Sun/Solaris type "make CC=cc CFLAGS=-c". 
 #
 # Acknowledgements:
 #    Martin Shepherd, Caltech
@@ -34,43 +34,17 @@ ARCH=$(shell uname -m | sed -e 's/Power Macintosh/ppc/ ; s/i686/i386/')
 PLATFORM=$(OS)-$(ARCH)
 ####### End added by IceCube collaboration ##########
 
-# Specify the installation home directory.
-
-INSTALL_DIR = ../
-
-# Specify the installation directory for the library.
-
-SLA_LIB_DIR = $(INSTALL_DIR)/$(PLATFORM)/lib/
-
-# Specify the installation directory for the include files.
-
-SLA_INC_DIR = $(INSTALL_DIR)/include/
-
-# This suite of functions is only compilable by ANSI C compilers -
-# give the name of your preferred C compiler and compilation flags
-# here.
-
-CCOMPC = gcc
-CFLAGC = -c -pedantic -Wall
+INCLUDE_DIR = @INCLUDE_DIR@
+LIB_DIR = @LIB_DIR@../lib
+CC = gcc
+CFLAGS = -c
 
 #----YOU SHOULDN'T HAVE TO MODIFY ANYTHING BELOW THIS LINE---------
 
-# The list of installation directories.
-
-INSTALL_DIRS = $(SLA_LIB_DIR) $(SLA_INC_DIR)
-
 # Name the slalib library in its source location.
 
 SLA_LIB_NAME = libsla.a
 
-# Name the slalib library in its target location.
-
-SLA_LIB = $(SLA_LIB_DIR)$(SLA_LIB_NAME)
-
-# Name the slalib includes in their target location.
-
-SLA_INC = $(SLA_INC_DIR)slalib.h $(SLA_INC_DIR)slamac.h
-
 # The list of slalib library object files.
 
 SLA_OBS = slaAddet.o slaAfin.o slaAirmas.o slaAltaz.o slaAmp.o \
@@ -107,24 +81,16 @@ slaVn.o slaVxv.o slaXy2xy.o slaZd.o
 
 #-----------------------------------------------------------------------
 
-default: $(INSTALL_DIRS) $(SLA_INC) $(SLA_LIB)
-
-# Make the installation directories if necessary.
+default: $(SLA_LIB_NAME) slalib.h slamac.h
 
-$(INSTALL_DIRS):
-	mkdir -p $@
+install: $(SLA_LIB_NAME) slalib.h slamac.h
+	install slalib.h slamac.h $(INCLUDE_DIR)
+	install $(SLA_LIB_NAME) $(LIB_DIR)
 
 # Make and install the library.
 
-$(SLA_LIB): $(SLA_OBS)
+$(SLA_LIB_NAME): $(SLA_OBS)
 	ar ru $(SLA_LIB_NAME) $?
-	cp $(SLA_LIB_NAME) $@
-
-# Keep the installed include files up to date.
-
-$(SLA_INC): slalib.h slamac.h
-	cp slalib.h $(SLA_INC_DIR).
-	cp slamac.h $(SLA_INC_DIR).
 
 clean:
 	rm -f $(SLA_OBS) $(SLA_LIB_NAME)
@@ -133,374 +99,374 @@ clean:
 # The list of object file dependencies
 
 slaAddet.o  : addet.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ addet.c
+	$(CC) $(CFLAGS) -o $@ addet.c
 slaAfin.o   : afin.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ afin.c
+	$(CC) $(CFLAGS) -o $@ afin.c
 slaAirmas.o : airmas.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ airmas.c
+	$(CC) $(CFLAGS) -o $@ airmas.c
 slaAltaz.o  : altaz.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ altaz.c
+	$(CC) $(CFLAGS) -o $@ altaz.c
 slaAmp.o    : amp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ amp.c
+	$(CC) $(CFLAGS) -o $@ amp.c
 slaAmpqk.o  : ampqk.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ampqk.c
+	$(CC) $(CFLAGS) -o $@ ampqk.c
 slaAop.o    : aop.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ aop.c
+	$(CC) $(CFLAGS) -o $@ aop.c
 slaAoppa.o  : aoppa.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ aoppa.c
+	$(CC) $(CFLAGS) -o $@ aoppa.c
 slaAoppat.o : aoppat.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ aoppat.c
+	$(CC) $(CFLAGS) -o $@ aoppat.c
 slaAopqk.o  : aopqk.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ aopqk.c
+	$(CC) $(CFLAGS) -o $@ aopqk.c
 slaAtmdsp.o : atmdsp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ atmdsp.c
+	$(CC) $(CFLAGS) -o $@ atmdsp.c
 slaAv2m.o   : av2m.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ av2m.c
+	$(CC) $(CFLAGS) -o $@ av2m.c
 slaBear.o   : bear.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ bear.c
+	$(CC) $(CFLAGS) -o $@ bear.c
 slaCaf2r.o  : caf2r.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ caf2r.c
+	$(CC) $(CFLAGS) -o $@ caf2r.c
 slaCaldj.o  : caldj.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ caldj.c
+	$(CC) $(CFLAGS) -o $@ caldj.c
 slaCalyd.o  : calyd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ calyd.c
+	$(CC) $(CFLAGS) -o $@ calyd.c
 slaCc2s.o   : cc2s.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cc2s.c
+	$(CC) $(CFLAGS) -o $@ cc2s.c
 slaCc62s.o  : cc62s.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cc62s.c
+	$(CC) $(CFLAGS) -o $@ cc62s.c
 slaCd2tf.o  : cd2tf.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cd2tf.c
+	$(CC) $(CFLAGS) -o $@ cd2tf.c
 slaCldj.o   : cldj.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cldj.c
+	$(CC) $(CFLAGS) -o $@ cldj.c
 slaClyd.o   : clyd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ clyd.c
+	$(CC) $(CFLAGS) -o $@ clyd.c
 slaCombn.o  : combn.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ combn.c
+	$(CC) $(CFLAGS) -o $@ combn.c
 slaCr2af.o  : cr2af.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cr2af.c
+	$(CC) $(CFLAGS) -o $@ cr2af.c
 slaCr2tf.o  : cr2tf.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cr2tf.c
+	$(CC) $(CFLAGS) -o $@ cr2tf.c
 slaCs2c.o   : cs2c.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cs2c.c
+	$(CC) $(CFLAGS) -o $@ cs2c.c
 slaCs2c6.o  : cs2c6.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ cs2c6.c
+	$(CC) $(CFLAGS) -o $@ cs2c6.c
 slaCtf2d.o  : ctf2d.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ctf2d.c
+	$(CC) $(CFLAGS) -o $@ ctf2d.c
 slaCtf2r.o  : ctf2r.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ctf2r.c
+	$(CC) $(CFLAGS) -o $@ ctf2r.c
 slaDaf2r.o  : daf2r.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ daf2r.c
+	$(CC) $(CFLAGS) -o $@ daf2r.c
 slaDafin.o  : dafin.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dafin.c
+	$(CC) $(CFLAGS) -o $@ dafin.c
 slaDat.o    : dat.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dat.c
+	$(CC) $(CFLAGS) -o $@ dat.c
 slaDav2m.o  : dav2m.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dav2m.c
+	$(CC) $(CFLAGS) -o $@ dav2m.c
 slaDbear.o  : dbear.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dbear.c
+	$(CC) $(CFLAGS) -o $@ dbear.c
 slaDbjin.o  : dbjin.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dbjin.c
+	$(CC) $(CFLAGS) -o $@ dbjin.c
 slaDc62s.o  : dc62s.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dc62s.c
+	$(CC) $(CFLAGS) -o $@ dc62s.c
 slaDcc2s.o  : dcc2s.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dcc2s.c
+	$(CC) $(CFLAGS) -o $@ dcc2s.c
 slaDcmpf.o  : dcmpf.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dcmpf.c
+	$(CC) $(CFLAGS) -o $@ dcmpf.c
 slaDcs2c.o  : dcs2c.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dcs2c.c
+	$(CC) $(CFLAGS) -o $@ dcs2c.c
 slaDd2tf.o  : dd2tf.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dd2tf.c
+	$(CC) $(CFLAGS) -o $@ dd2tf.c
 slaDe2h.o   : de2h.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ de2h.c
+	$(CC) $(CFLAGS) -o $@ de2h.c
 slaDeuler.o : deuler.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ deuler.c
+	$(CC) $(CFLAGS) -o $@ deuler.c
 slaDfltin.o : dfltin.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dfltin.c
+	$(CC) $(CFLAGS) -o $@ dfltin.c
 slaDh2e.o   : dh2e.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dh2e.c
+	$(CC) $(CFLAGS) -o $@ dh2e.c
 slaDimxv.o  : dimxv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dimxv.c
+	$(CC) $(CFLAGS) -o $@ dimxv.c
 slaDjcal.o  : djcal.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ djcal.c
+	$(CC) $(CFLAGS) -o $@ djcal.c
 slaDjcl.o   : djcl.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ djcl.c
+	$(CC) $(CFLAGS) -o $@ djcl.c
 slaDm2av.o  : dm2av.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dm2av.c
+	$(CC) $(CFLAGS) -o $@ dm2av.c
 slaDmat.o   : dmat.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dmat.c
+	$(CC) $(CFLAGS) -o $@ dmat.c
 slaDmoon.o  : dmoon.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dmoon.c
+	$(CC) $(CFLAGS) -o $@ dmoon.c
 slaDmxm.o   : dmxm.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dmxm.c
+	$(CC) $(CFLAGS) -o $@ dmxm.c
 slaDmxv.o   : dmxv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dmxv.c
+	$(CC) $(CFLAGS) -o $@ dmxv.c
 slaDpav.o   : dpav.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dpav.c
+	$(CC) $(CFLAGS) -o $@ dpav.c
 slaDr2af.o  : dr2af.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dr2af.c
+	$(CC) $(CFLAGS) -o $@ dr2af.c
 slaDr2tf.o  : dr2tf.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dr2tf.c
+	$(CC) $(CFLAGS) -o $@ dr2tf.c
 slaDrange.o : drange.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ drange.c
+	$(CC) $(CFLAGS) -o $@ drange.c
 slaDranrm.o : dranrm.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dranrm.c
+	$(CC) $(CFLAGS) -o $@ dranrm.c
 slaDs2c6.o  : ds2c6.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ds2c6.c
+	$(CC) $(CFLAGS) -o $@ ds2c6.c
 slaDs2tp.o  : ds2tp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ds2tp.c
+	$(CC) $(CFLAGS) -o $@ ds2tp.c
 slaDsep.o   : dsep.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dsep.c
+	$(CC) $(CFLAGS) -o $@ dsep.c
 slaDsepv.o   : dsepv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dsepv.c
+	$(CC) $(CFLAGS) -o $@ dsepv.c
 slaDt.o     : dt.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dt.c
+	$(CC) $(CFLAGS) -o $@ dt.c
 slaDtf2d.o  : dtf2d.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtf2d.c
+	$(CC) $(CFLAGS) -o $@ dtf2d.c
 slaDtf2r.o  : dtf2r.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtf2r.c
+	$(CC) $(CFLAGS) -o $@ dtf2r.c
 slaDtp2s.o  : dtp2s.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtp2s.c
+	$(CC) $(CFLAGS) -o $@ dtp2s.c
 slaDtp2v.o  : dtp2v.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtp2v.c
+	$(CC) $(CFLAGS) -o $@ dtp2v.c
 slaDtps2c.o : dtps2c.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtps2c.c
+	$(CC) $(CFLAGS) -o $@ dtps2c.c
 slaDtpv2c.o : dtpv2c.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtpv2c.c
+	$(CC) $(CFLAGS) -o $@ dtpv2c.c
 slaDtt.o    : dtt.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dtt.c
+	$(CC) $(CFLAGS) -o $@ dtt.c
 slaDv2tp.o  : dv2tp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dv2tp.c
+	$(CC) $(CFLAGS) -o $@ dv2tp.c
 slaDvdv.o   : dvdv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dvdv.c
+	$(CC) $(CFLAGS) -o $@ dvdv.c
 slaDvn.o    : dvn.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dvn.c
+	$(CC) $(CFLAGS) -o $@ dvn.c
 slaDvxv.o   : dvxv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ dvxv.c
+	$(CC) $(CFLAGS) -o $@ dvxv.c
 slaE2h.o    : e2h.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ e2h.c
+	$(CC) $(CFLAGS) -o $@ e2h.c
 slaEarth.o  : earth.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ earth.c
+	$(CC) $(CFLAGS) -o $@ earth.c
 slaEcleq.o  : ecleq.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ecleq.c
+	$(CC) $(CFLAGS) -o $@ ecleq.c
 slaEcmat.o  : ecmat.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ecmat.c
+	$(CC) $(CFLAGS) -o $@ ecmat.c
 slaEcor.o   : ecor.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ecor.c
+	$(CC) $(CFLAGS) -o $@ ecor.c
 slaEg50.o   : eg50.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ eg50.c
+	$(CC) $(CFLAGS) -o $@ eg50.c
 slaEl2ue.o  : el2ue.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ el2ue.c
+	$(CC) $(CFLAGS) -o $@ el2ue.c
 slaEpb.o    : epb.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ epb.c
+	$(CC) $(CFLAGS) -o $@ epb.c
 slaEpb2d.o  : epb2d.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ epb2d.c
+	$(CC) $(CFLAGS) -o $@ epb2d.c
 slaEpco.o   : epco.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ epco.c
+	$(CC) $(CFLAGS) -o $@ epco.c
 slaEpj.o    : epj.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ epj.c
+	$(CC) $(CFLAGS) -o $@ epj.c
 slaEpj2d.o  : epj2d.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ epj2d.c
+	$(CC) $(CFLAGS) -o $@ epj2d.c
 slaEpv.o    : epv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ epv.c
+	$(CC) $(CFLAGS) -o $@ epv.c
 slaEqecl.o  : eqecl.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ eqecl.c
+	$(CC) $(CFLAGS) -o $@ eqecl.c
 slaEqeqx.o  : eqeqx.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ eqeqx.c
+	$(CC) $(CFLAGS) -o $@ eqeqx.c
 slaEqgal.o  : eqgal.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ eqgal.c
+	$(CC) $(CFLAGS) -o $@ eqgal.c
 slaEtrms.o  : etrms.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ etrms.c
+	$(CC) $(CFLAGS) -o $@ etrms.c
 slaEuler.o  : euler.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ euler.c
+	$(CC) $(CFLAGS) -o $@ euler.c
 slaEvp.o    : evp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ evp.c
+	$(CC) $(CFLAGS) -o $@ evp.c
 slaFitxy.o  : fitxy.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fitxy.c
+	$(CC) $(CFLAGS) -o $@ fitxy.c
 slaFk425.o  : fk425.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fk425.c
+	$(CC) $(CFLAGS) -o $@ fk425.c
 slaFk45z.o  : fk45z.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fk45z.c
+	$(CC) $(CFLAGS) -o $@ fk45z.c
 slaFk524.o  : fk524.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fk524.c
+	$(CC) $(CFLAGS) -o $@ fk524.c
 slaFk52h.o  : fk52h.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fk52h.c
+	$(CC) $(CFLAGS) -o $@ fk52h.c
 slaFk54z.o  : fk54z.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fk54z.c
+	$(CC) $(CFLAGS) -o $@ fk54z.c
 slaFk5hz.o  : fk5hz.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ fk5hz.c
+	$(CC) $(CFLAGS) -o $@ fk5hz.c
 slaFlotin.o : flotin.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ flotin.c
+	$(CC) $(CFLAGS) -o $@ flotin.c
 slaGaleq.o  : galeq.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ galeq.c
+	$(CC) $(CFLAGS) -o $@ galeq.c
 slaGalsup.o : galsup.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ galsup.c
+	$(CC) $(CFLAGS) -o $@ galsup.c
 slaGe50.o   : ge50.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ge50.c
+	$(CC) $(CFLAGS) -o $@ ge50.c
 slaGeoc.o   : geoc.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ geoc.c
+	$(CC) $(CFLAGS) -o $@ geoc.c
 slaGmst.o   : gmst.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ gmst.c
+	$(CC) $(CFLAGS) -o $@ gmst.c
 slaGmsta.o  : gmsta.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ gmsta.c
+	$(CC) $(CFLAGS) -o $@ gmsta.c
 slaH2e.o    : h2e.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ h2e.c
+	$(CC) $(CFLAGS) -o $@ h2e.c
 slaH2fk5.o  : h2fk5.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ h2fk5.c
+	$(CC) $(CFLAGS) -o $@ h2fk5.c
 slaHfk5z.o  : hfk5z.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ hfk5z.c
+	$(CC) $(CFLAGS) -o $@ hfk5z.c
 slaImxv.o   : imxv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ imxv.c
+	$(CC) $(CFLAGS) -o $@ imxv.c
 slaInt2in.o  : int2in.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ int2in.c
+	$(CC) $(CFLAGS) -o $@ int2in.c
 slaIntin.o  : intin.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ intin.c
+	$(CC) $(CFLAGS) -o $@ intin.c
 slaInvf.o   : invf.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ invf.c
+	$(CC) $(CFLAGS) -o $@ invf.c
 slaKbj.o    : kbj.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ kbj.c
+	$(CC) $(CFLAGS) -o $@ kbj.c
 slaM2av.o   : m2av.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ m2av.c
+	$(CC) $(CFLAGS) -o $@ m2av.c
 slaMap.o    : map.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ map.c
+	$(CC) $(CFLAGS) -o $@ map.c
 slaMappa.o  : mappa.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ mappa.c
+	$(CC) $(CFLAGS) -o $@ mappa.c
 slaMapqk.o  : mapqk.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ mapqk.c
+	$(CC) $(CFLAGS) -o $@ mapqk.c
 slaMapqkz.o : mapqkz.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ mapqkz.c
+	$(CC) $(CFLAGS) -o $@ mapqkz.c
 slaMoon.o   : moon.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ moon.c
+	$(CC) $(CFLAGS) -o $@ moon.c
 slaMxm.o    : mxm.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ mxm.c
+	$(CC) $(CFLAGS) -o $@ mxm.c
 slaMxv.o    : mxv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ mxv.c
+	$(CC) $(CFLAGS) -o $@ mxv.c
 slaNut.o    : nut.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ nut.c
+	$(CC) $(CFLAGS) -o $@ nut.c
 slaNutc.o   : nutc.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ nutc.c
+	$(CC) $(CFLAGS) -o $@ nutc.c
 slaNutc80.o   : nutc80.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ nutc80.c
+	$(CC) $(CFLAGS) -o $@ nutc80.c
 slaOap.o    : oap.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ oap.c
+	$(CC) $(CFLAGS) -o $@ oap.c
 slaOapqk.o  : oapqk.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ oapqk.c
+	$(CC) $(CFLAGS) -o $@ oapqk.c
 slaObs.o    : obs.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ obs.c
+	$(CC) $(CFLAGS) -o $@ obs.c
 slaPa.o     : pa.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pa.c
+	$(CC) $(CFLAGS) -o $@ pa.c
 slaPav.o    : pav.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pav.c
+	$(CC) $(CFLAGS) -o $@ pav.c
 slaPcd.o    : pcd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pcd.c
+	$(CC) $(CFLAGS) -o $@ pcd.c
 slaPm.o     : pm.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pm.c
+	$(CC) $(CFLAGS) -o $@ pm.c
 slaPda2h.o  : pda2h.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pda2h.c
+	$(CC) $(CFLAGS) -o $@ pda2h.c
 slaPdq2h.o  : pdq2h.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pdq2h.c
+	$(CC) $(CFLAGS) -o $@ pdq2h.c
 slaPermut.o : permut.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ permut.c
+	$(CC) $(CFLAGS) -o $@ permut.c
 slaPertel.o : pertel.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pertel.c
+	$(CC) $(CFLAGS) -o $@ pertel.c
 slaPertue.o : pertue.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pertue.c
+	$(CC) $(CFLAGS) -o $@ pertue.c
 slaPlanel.o : planel.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ planel.c
+	$(CC) $(CFLAGS) -o $@ planel.c
 slaPlanet.o : planet.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ planet.c
+	$(CC) $(CFLAGS) -o $@ planet.c
 slaPlante.o : plante.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ plante.c
+	$(CC) $(CFLAGS) -o $@ plante.c
 slaPlantu.o : plantu.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ plantu.c
+	$(CC) $(CFLAGS) -o $@ plantu.c
 slaPolmo.o  : polmo.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ polmo.c
+	$(CC) $(CFLAGS) -o $@ polmo.c
 slaPrebn.o  : prebn.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ prebn.c
+	$(CC) $(CFLAGS) -o $@ prebn.c
 slaPrec.o   : prec.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ prec.c
+	$(CC) $(CFLAGS) -o $@ prec.c
 slaPrecl.o  : precl.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ precl.c
+	$(CC) $(CFLAGS) -o $@ precl.c
 slaPreces.o : preces.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ preces.c
+	$(CC) $(CFLAGS) -o $@ preces.c
 slaPrenut.o : prenut.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ prenut.c
+	$(CC) $(CFLAGS) -o $@ prenut.c
 slaPvobs.o  : pvobs.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pvobs.c
+	$(CC) $(CFLAGS) -o $@ pvobs.c
 slaPv2el.o  : pv2el.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pv2el.c
+	$(CC) $(CFLAGS) -o $@ pv2el.c
 slaPv2ue.o  : pv2ue.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pv2ue.c
+	$(CC) $(CFLAGS) -o $@ pv2ue.c
 slaPxy.o    : pxy.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ pxy.c
+	$(CC) $(CFLAGS) -o $@ pxy.c
 slaRange.o  : range.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ range.c
+	$(CC) $(CFLAGS) -o $@ range.c
 slaRanorm.o : ranorm.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ranorm.c
+	$(CC) $(CFLAGS) -o $@ ranorm.c
 slaRcc.o    : rcc.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rcc.c
+	$(CC) $(CFLAGS) -o $@ rcc.c
 slaRdplan.o : rdplan.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rdplan.c
+	$(CC) $(CFLAGS) -o $@ rdplan.c
 slaRefco.o  : refco.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ refco.c
+	$(CC) $(CFLAGS) -o $@ refco.c
 slaRefcoq.o : refcoq.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ refcoq.c
+	$(CC) $(CFLAGS) -o $@ refcoq.c
 slaRefro.o  : refro.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ refro.c
+	$(CC) $(CFLAGS) -o $@ refro.c
 slaRefv.o   : refv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ refv.c
+	$(CC) $(CFLAGS) -o $@ refv.c
 slaRefz.o   : refz.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ refz.c
+	$(CC) $(CFLAGS) -o $@ refz.c
 slaRverot.o : rverot.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rverot.c
+	$(CC) $(CFLAGS) -o $@ rverot.c
 slaRvgalc.o : rvgalc.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rvgalc.c
+	$(CC) $(CFLAGS) -o $@ rvgalc.c
 slaRvlg.o   : rvlg.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rvlg.c
+	$(CC) $(CFLAGS) -o $@ rvlg.c
 slaRvlsrd.o : rvlsrd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rvlsrd.c
+	$(CC) $(CFLAGS) -o $@ rvlsrd.c
 slaRvlsrk.o : rvlsrk.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ rvlsrk.c
+	$(CC) $(CFLAGS) -o $@ rvlsrk.c
 slaS2tp.o   : s2tp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ s2tp.c
+	$(CC) $(CFLAGS) -o $@ s2tp.c
 slaSep.o    : sep.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ sep.c
+	$(CC) $(CFLAGS) -o $@ sep.c
 slaSepv.o    : sepv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ sepv.c
+	$(CC) $(CFLAGS) -o $@ sepv.c
 slaSmat.o   : smat.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ smat.c
+	$(CC) $(CFLAGS) -o $@ smat.c
 slaSubet.o  : subet.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ subet.c
+	$(CC) $(CFLAGS) -o $@ subet.c
 slaSupgal.o : supgal.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ supgal.c
+	$(CC) $(CFLAGS) -o $@ supgal.c
 slaSvd.o    : svd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ svd.c
+	$(CC) $(CFLAGS) -o $@ svd.c
 slaSvdcov.o : svdcov.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ svdcov.c
+	$(CC) $(CFLAGS) -o $@ svdcov.c
 slaSvdsol.o : svdsol.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ svdsol.c
+	$(CC) $(CFLAGS) -o $@ svdsol.c
 slaTp2s.o   : tp2s.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ tp2s.c
+	$(CC) $(CFLAGS) -o $@ tp2s.c
 slaTp2v.o   : tp2v.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ tp2v.c
+	$(CC) $(CFLAGS) -o $@ tp2v.c
 slaTps2c.o  : tps2c.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ tps2c.c
+	$(CC) $(CFLAGS) -o $@ tps2c.c
 slaTpv2c.o  : tpv2c.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ tpv2c.c
+	$(CC) $(CFLAGS) -o $@ tpv2c.c
 slaUe2el.o  : ue2el.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ue2el.c
+	$(CC) $(CFLAGS) -o $@ ue2el.c
 slaUe2pv.o  : ue2pv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ ue2pv.c
+	$(CC) $(CFLAGS) -o $@ ue2pv.c
 slaUnpcd.o  : unpcd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ unpcd.c
+	$(CC) $(CFLAGS) -o $@ unpcd.c
 slaV2tp.o   : v2tp.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ v2tp.c
+	$(CC) $(CFLAGS) -o $@ v2tp.c
 slaVdv.o    : vdv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ vdv.c
+	$(CC) $(CFLAGS) -o $@ vdv.c
 slaVn.o     : vn.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ vn.c
+	$(CC) $(CFLAGS) -o $@ vn.c
 slaVxv.o    : vxv.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ vxv.c
+	$(CC) $(CFLAGS) -o $@ vxv.c
 slaXy2xy.o  : xy2xy.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ xy2xy.c
+	$(CC) $(CFLAGS) -o $@ xy2xy.c
 slaZd.o     : zd.c slalib.h slamac.h
-	$(CCOMPC) $(CFLAGC) -o $@ zd.c
+	$(CC) $(CFLAGS) -o $@ zd.c
