class Multinest < Formula
  desc "Bayesian inference tool"
  homepage "https://www.astro.phy.cam.ac.uk/research/ResearchFacilities/software-for-astrophyiscs"
  url "https://github.com/JohannesBuchner/MultiNest/archive/96249c628c1d67ccdcd8d235fd19191fdf011c42.tar.gz"
  version "3.8"
  sha256 "98941dc25670fa4dab15a15d79587799c7be6e1a07103d837ea9102cd11aaca5"
  revision 1
  head "https://github.com/JohannesBuchner/MultiNest.git", branch: "master"

  depends_on "cmake"    => :build
  depends_on "gcc"      => :build
  depends_on "open-mpi" => :optional

  patch :DATA

  def install
    ENV.deparallelize

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"

    # documentation is in the form of a README
    doc.install("README")

    # the license agreement
    doc.install("LICENCE")
    doc.install("license.pdf")
  end

  def caveats
    <<~EOS
      By installing MultiNest, you are agreeing to its licence. After the formula
      has been installed, the README and LICENCE files can be found in #{doc}.
      The examples are installed to #{HOMEBREW_PREFIX}/share/MultiNest.
    EOS
  end

  test do
    system "true"
  end
end

__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 91d892c..600da86 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -179,7 +179,7 @@ INSTALL(FILES ${CMAKE_SOURCE_DIR}/CMakeModules/FindMultiNest.cmake DESTINATION
 # and ensure the chains directory is created too
 INSTALL(DIRECTORY
     ${CMAKE_SOURCE_DIR}/bin/chains
-    DESTINATION bin
+    DESTINATION share/MultiNest/examples
 )
 
 # ============================
diff --git a/src/example_ackley/CMakeLists.txt b/src/example_ackley/CMakeLists.txt
index c435bb9..6f50ba2 100644
--- a/src/example_ackley/CMakeLists.txt
+++ b/src/example_ackley/CMakeLists.txt
@@ -17,4 +17,4 @@ add_executable(ackley ${SOURCE})
 target_link_libraries(ackley ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS ackley DESTINATION bin)
+INSTALL(TARGETS ackley DESTINATION share/MultiNest/examples)
diff --git a/src/example_eggbox_C++/CMakeLists.txt b/src/example_eggbox_C++/CMakeLists.txt
index 6e38d93..9293f0e 100644
--- a/src/example_eggbox_C++/CMakeLists.txt
+++ b/src/example_eggbox_C++/CMakeLists.txt
@@ -9,4 +9,4 @@ add_executable(eggboxC++ ${SOURCE})
 target_link_libraries(eggboxC++ ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS eggboxC++ DESTINATION bin)
+INSTALL(TARGETS eggboxC++ DESTINATION share/MultiNest/examples)
diff --git a/src/example_eggbox_C/CMakeLists.txt b/src/example_eggbox_C/CMakeLists.txt
index 99d4e11..4295eb5 100644
--- a/src/example_eggbox_C/CMakeLists.txt
+++ b/src/example_eggbox_C/CMakeLists.txt
@@ -11,4 +11,4 @@ add_executable(eggboxC ${SOURCE})
 target_link_libraries(eggboxC ${MultiNest_LIBRARIES} m)
 
 # Set install directory
-INSTALL(TARGETS eggboxC DESTINATION bin)
+INSTALL(TARGETS eggboxC DESTINATION share/MultiNest/examples)
diff --git a/src/example_gauss_shell/CMakeLists.txt b/src/example_gauss_shell/CMakeLists.txt
index e2faef0..bdbccf5 100644
--- a/src/example_gauss_shell/CMakeLists.txt
+++ b/src/example_gauss_shell/CMakeLists.txt
@@ -17,4 +17,4 @@ add_executable(gauss_shell ${SOURCE})
 target_link_libraries(gauss_shell ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS gauss_shell DESTINATION bin)
+INSTALL(TARGETS gauss_shell DESTINATION share/MultiNest/examples)
diff --git a/src/example_gaussian/CMakeLists.txt b/src/example_gaussian/CMakeLists.txt
index 7648819..a60d71a 100644
--- a/src/example_gaussian/CMakeLists.txt
+++ b/src/example_gaussian/CMakeLists.txt
@@ -17,4 +17,4 @@ add_executable(gaussian ${SOURCE})
 target_link_libraries(gaussian ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS gaussian DESTINATION bin)
+INSTALL(TARGETS gaussian DESTINATION share/MultiNest/examples)
diff --git a/src/example_himmelblau/CMakeLists.txt b/src/example_himmelblau/CMakeLists.txt
index 0ac0f18..cce939c 100644
--- a/src/example_himmelblau/CMakeLists.txt
+++ b/src/example_himmelblau/CMakeLists.txt
@@ -17,4 +17,4 @@ add_executable(himmelblau ${SOURCE})
 target_link_libraries(himmelblau ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS himmelblau DESTINATION bin)
+INSTALL(TARGETS himmelblau DESTINATION share/MultiNest/examples)
diff --git a/src/example_obj_detect/CMakeLists.txt b/src/example_obj_detect/CMakeLists.txt
index 02acb13..837e08e 100644
--- a/src/example_obj_detect/CMakeLists.txt
+++ b/src/example_obj_detect/CMakeLists.txt
@@ -17,4 +17,4 @@ add_executable(obj_detect ${SOURCE})
 target_link_libraries(obj_detect ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS obj_detect DESTINATION bin)
+INSTALL(TARGETS obj_detect DESTINATION share/MultiNest/examples)
diff --git a/src/example_rosenbrock/CMakeLists.txt b/src/example_rosenbrock/CMakeLists.txt
index fb3d6ef..56e1244 100644
--- a/src/example_rosenbrock/CMakeLists.txt
+++ b/src/example_rosenbrock/CMakeLists.txt
@@ -17,4 +17,4 @@ add_executable(rosenbrock ${SOURCE})
 target_link_libraries(rosenbrock ${MultiNest_LIBRARIES})
 
 # Set install directory
-INSTALL(TARGETS rosenbrock DESTINATION bin)
+INSTALL(TARGETS rosenbrock DESTINATION share/MultiNest/examples)
diff --git a/src/nested.F90 b/src/nested.F90
index 89cefb2..134b15f 100755
--- a/src/nested.F90
+++ b/src/nested.F90
@@ -213,17 +213,19 @@ contains
 		else
 			resumeFlag=.false.
 		endif
-      
-		write(*,*)"*****************************************************"
-		write(*,*)"MultiNest v3.8"
-      		write(*,*)"Copyright Farhan Feroz & Mike Hobson"
-      		write(*,*)"Release Oct 2014"
-		write(*,*)
-      		write(*,'(a,i4)')" no. of live points = ",nest_nlive
-      		write(*,'(a,i4)')" dimensionality = ",nest_ndims
-		if(ceff) write(*,'(a)')" running in constant efficiency mode"
-      		if(resumeFlag) write(*,'(a)')" resuming from previous job"
-      		write(*,*)"*****************************************************"
+
+        if (fback) then
+            write(*,*)"*****************************************************"
+            write(*,*)"MultiNest v3.8"
+            write(*,*)"Copyright Farhan Feroz & Mike Hobson"
+            write(*,*)"Release Oct 2014"
+            write(*,*)
+            write(*,'(a,i4)')" no. of live points = ",nest_nlive
+            write(*,'(a,i4)')" dimensionality = ",nest_ndims
+            if(ceff) write(*,'(a)')" running in constant efficiency mode"
+            if(resumeFlag) write(*,'(a)')" resuming from previous job"
+            write(*,*)"*****************************************************"
+        endif
         
 		if (fback) write (*,*) 'Starting MultiNest'
 	
@@ -364,12 +366,14 @@ contains
 	if( .not.bogus ) call clusteredNest(p,phyP,l,loglike,dumper,context)
 	
 	if( my_rank==0 ) then
-		if( .not.bogus ) then
+		if (fback) then
+		    if( .not.bogus ) then
 			write(*,*)"ln(ev)=",gZ,"+/-",sqrt(ginfo/dble(nlive))
 			write(*,'(a,i12)')' Total Likelihood Evaluations: ', numlike
 			write(*,*)"Sampling finished. Exiting MultiNest"
-		else
+		    else
 			write(*,*)"Exit signal received"
+		    endif
 		endif
 		setBlk=.false.
 	endif
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8f75cf5..9a1cc67 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8)
+cmake_minimum_required(VERSION 3.4)
 project(multinest Fortran C CXX)
 
 # By default CMake will install MultiNest to /usr/local on Linux/Mac
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 600da86..26636e0 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 #=============================================================================
 # Copyright 2012 Brian Kloppenborg
diff --git a/src/example_ackley/CMakeLists.txt b/src/example_ackley/CMakeLists.txt
index 6f50ba2..f389c29 100644
--- a/src/example_ackley/CMakeLists.txt
+++ b/src/example_ackley/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # A typical CMake file for a Fortran program will look like this:
 #
diff --git a/src/example_eggbox_C++/CMakeLists.txt b/src/example_eggbox_C++/CMakeLists.txt
index 9293f0e..d11b91f 100644
--- a/src/example_eggbox_C++/CMakeLists.txt
+++ b/src/example_eggbox_C++/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # In a normal application you would do:
 # FIND_LIBRARY(MultiNest)
diff --git a/src/example_eggbox_C/CMakeLists.txt b/src/example_eggbox_C/CMakeLists.txt
index 4295eb5..ff709c7 100644
--- a/src/example_eggbox_C/CMakeLists.txt
+++ b/src/example_eggbox_C/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # In a normal application you would do:
 # FIND_LIBRARY(MultiNest)
diff --git a/src/example_gauss_shell/CMakeLists.txt b/src/example_gauss_shell/CMakeLists.txt
index bdbccf5..609d276 100644
--- a/src/example_gauss_shell/CMakeLists.txt
+++ b/src/example_gauss_shell/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # A typical CMake file for a Fortran program will look like this:
 #
diff --git a/src/example_gaussian/CMakeLists.txt b/src/example_gaussian/CMakeLists.txt
index a60d71a..15fcc52 100644
--- a/src/example_gaussian/CMakeLists.txt
+++ b/src/example_gaussian/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # A typical CMake file for a Fortran program will look like this:
 #
diff --git a/src/example_himmelblau/CMakeLists.txt b/src/example_himmelblau/CMakeLists.txt
index cce939c..66cebd9 100644
--- a/src/example_himmelblau/CMakeLists.txt
+++ b/src/example_himmelblau/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # A typical CMake file for a Fortran program will look like this:
 #
diff --git a/src/example_obj_detect/CMakeLists.txt b/src/example_obj_detect/CMakeLists.txt
index 837e08e..7bd1c5f 100644
--- a/src/example_obj_detect/CMakeLists.txt
+++ b/src/example_obj_detect/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # A typical CMake file for a Fortran program will look like this:
 #
diff --git a/src/example_rosenbrock/CMakeLists.txt b/src/example_rosenbrock/CMakeLists.txt
index 56e1244..4447fe8 100644
--- a/src/example_rosenbrock/CMakeLists.txt
+++ b/src/example_rosenbrock/CMakeLists.txt
@@ -1,4 +1,4 @@
-cmake_minimum_required(VERSION 2.8) 
+cmake_minimum_required(VERSION 3.4)
 
 # A typical CMake file for a Fortran program will look like this:
 #
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 26636e0..3ee871f 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -116,6 +113,9 @@ else()
     SET(MultiNest_LIBRARIES multinest_mpi_shared)
 endif ()
 
+# Relax gfortran's strict type checking
+set_source_files_properties( nested.F90 PROPERTIES COMPILE_FLAGS -fallow-argument-mismatch )
+
 # ============================
 # After compilation, copy the Fortran modules into the 'modules' directory.
 # ============================
