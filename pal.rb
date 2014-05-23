require "formula"

class Pal < Formula
  homepage "https://github.com/IceCube-SPNO/pal"
  url "https://github.com/IceCube-SPNO/pal/archive/alpha.tar.gz"
  version "alpha"
  sha1 "0d0e2ec6bbf24e862f39ebe05f822d27b043f0aa"

  depends_on "erfa"
  # batteries not included
  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool => :build

  def install
    system "autoreconf", "--install", "--symlink", buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
