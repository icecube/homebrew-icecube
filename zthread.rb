require "formula"

class Zthread < Formula
  homepage "http://zthread.sourceforge.io"
  url "https://downloads.sourceforge.net/project/zthread/ZThread/2.3.2/ZThread-2.3.2.tar.gz"
  sha256 "950908b7473ac10abb046bd1d75acb5934344e302db38c2225b7a90bd1eda854"

  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    sha256 "80627b5ad4279019792e196a40a71681ede19512076f3d6e3372308fc4026d42" => :sierra
    sha256 "ab69f18ac3b06df63373d1f269bad6ed34e947cff781a5512cf1ff3ab9a05bfd" => :high_sierra

  end
               
  patch :DATA

  def install
    system "./configure", "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
__END__
diff -ur ZThread-2.3.2.orig/configure ZThread-2.3.2.new/configure
--- ZThread-2.3.2.orig/configure	2005-03-13 02:49:00.000000000 -0700
+++ ZThread-2.3.2.new/configure	2015-03-23 15:36:30.000000000 -0600
@@ -8703,7 +8703,7 @@
   exit 1
 fi
 gentoo_lt_version="1.5.10"
-gentoo_ltmain_version=`grep '^[:space:]*VERSION=' $ltmain | sed -e 's|^[:space:]*VERSION=||'`
+gentoo_ltmain_version=`grep '^[[:space:]]*VERSION=' $ltmain | sed -e 's|^[[:space:]]*VERSION=||'`
 if test "$gentoo_lt_version" != "$gentoo_ltmain_version"; then
   echo "$as_me:$LINENO: result: no" >&5
 echo "${ECHO_T}no" >&6
diff -ur ZThread-2.3.2.orig/include/zthread/Guard.h ZThread-2.3.2.new/include/zthread/Guard.h
--- ZThread-2.3.2.orig/include/zthread/Guard.h	2005-03-12 19:10:09.000000000 -0700
+++ ZThread-2.3.2.new/include/zthread/Guard.h	2015-03-23 15:48:25.000000000 -0600
@@ -114,11 +114,11 @@
       if(!Scope2::createScope(l, ms)) {
 
         Scope1::destroyScope(l);
-        return false;
+        return;
 
       }
        
-    return true;
+    return;
 
   }
 
@@ -230,13 +230,14 @@
    * A new protection scope is being created.
    *
    * @param lock LockType& is a type of LockHolder.
+   */
   template <class LockType>
   static void createScope(LockHolder<LockType>& l) {
 
     l.getLock().release();
 
   }
-   */
+
 
   /**
    * A protection scope is being destroyed.
@@ -428,7 +429,7 @@
   template <class U, class V>
   Guard(Guard<U, V>& g) : LockHolder<LockType>(g) {
 
-    LockingPolicy::shareScope(*this, extract(g));
+    LockingPolicy::shareScope(*this, this->extract(g));
     
   }
 
@@ -458,7 +459,7 @@
   template <class U, class V>
   Guard(Guard<U, V>& g, LockType& lock) : LockHolder<LockType>(lock) {
 
-    LockingPolicy::transferScope(*this, extract(g));
+    LockingPolicy::transferScope(*this, this->extract(g));
 
   }
 
@@ -491,7 +492,7 @@
     
   try {
     
-    if(!isDisabled())
+    if(!LockHolder<LockType>::isDisabled())
       LockingPolicy::destroyScope(*this);
     
   } catch (...) { /* ignore */ }  
Only in ZThread-2.3.2.new/include/zthread: Guard.h.orig
diff -ur ZThread-2.3.2.orig/src/MutexImpl.h ZThread-2.3.2.new/src/MutexImpl.h
--- ZThread-2.3.2.orig/src/MutexImpl.h	2005-03-12 20:59:15.000000000 -0700
+++ ZThread-2.3.2.new/src/MutexImpl.h	2015-03-23 15:54:34.000000000 -0600
@@ -153,7 +153,7 @@
 
       _owner = self;
 
-      ownerAcquired(self);
+      Behavior::ownerAcquired(self);
       
     }
 
@@ -164,7 +164,7 @@
       _waiters.insert(self);
       m.acquire();
 
-      waiterArrived(self);
+      Behavior::waiterArrived(self);
 
       {        
       
@@ -173,7 +173,7 @@
       
       }
 
-      waiterDeparted(self);
+      Behavior::waiterDeparted(self);
 
       m.release();
         
@@ -192,7 +192,7 @@
           assert(_owner == 0);
           _owner = self;    
 
-          ownerAcquired(self);
+          Behavior::ownerAcquired(self);
 
           break;
         
@@ -236,7 +236,7 @@
 
       _owner = self;
 
-      ownerAcquired(self);
+      Behavior::ownerAcquired(self);
       
     }
 
@@ -253,7 +253,7 @@
       
         m.acquire();
 
-        waiterArrived(self);
+        Behavior::waiterArrived(self);
       
         {
         
@@ -262,7 +262,7 @@
         
         }
 
-        waiterDeparted(self);
+        Behavior::waiterDeparted(self);
       
         m.release();
         
@@ -284,7 +284,7 @@
           assert(0 == _owner);
           _owner = self;
 
-          ownerAcquired(self);
+          Behavior::ownerAcquired(self);
         
           break;
         
@@ -326,7 +326,7 @@
 
     _owner = 0;
 
-    ownerReleased(impl);
+    Behavior::ownerReleased(impl);
   
     // Try to find a waiter with a backoff & retry scheme
     for(;;) {
