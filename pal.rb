require "formula"

class Pal < Formula
  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    sha256 "ce0e56c0554480817510f655aa4ffdea97c6fa03e74b7124c33f22275ecc461a" => :el_capitan
  end

  homepage "https://github.com/IceCube-SPNO/pal"
  url "https://github.com/IceCube-SPNO/pal/archive/master.tar.gz"
  version "0.9.1"
  sha1 "cad2c47efb4a0eea418fee2d1ba1a5efb75ac40e"
  sha256 "c60e8f6cf338a47978a6c1deffaff2f8e2bd7b8493c102020a1040e5495b1df6"

  depends_on "erfa"
  # batteries not included
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "--install", "--symlink", buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
