require "formula"

class Pal < Formula
  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    sha256 "dc8d557cb13acdcfbf5d8db0f121b962e4b9b02aca6802c857c6fe11a47a3a82" => :sierra
    sha256 "ce0e56c0554480817510f655aa4ffdea97c6fa03e74b7124c33f22275ecc461a" => :el_capitan
    sha256 "588d8843a34f04a6d8b20757084f7282c49c34b41ad038ac073c64827cf0da2d" => :high_sierra
  end

  homepage "https://github.com/IceCube-SPNO/pal"
  version "0.9.7"
  url "https://github.com/IceCube-SPNO/pal/archive/master.tar.gz"
  sha256 "001c4225d90a6887e8a7da45d1db2147bfa3c8ca3545492b20594042f9fcdabe"

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
