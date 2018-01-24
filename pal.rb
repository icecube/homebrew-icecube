require "formula"

class Pal < Formula
  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    rebuild 1
    sha256 "dc8d557cb13acdcfbf5d8db0f121b962e4b9b02aca6802c857c6fe11a47a3a82" => :sierra
    sha256 "ce0e56c0554480817510f655aa4ffdea97c6fa03e74b7124c33f22275ecc461a" => :el_capitan
  end

  homepage "https://github.com/IceCube-SPNO/pal"
  url "https://github.com/IceCube-SPNO/pal/archive/v0.9.1.tar.gz"
  sha256 "c60e8f6cf338a47978a6c1deffaff2f8e2bd7b8493c102020a1040e5495b1df6"

  depends_on "erfa"
  # batteries not included
  if (RUBY_PLATFORM =~ /darwin/)
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  def install
    system "autoreconf", "--install", "--symlink", buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

end
