require "formula"

class Erfa < Formula
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/releases/download/v1.0.1/erfa-1.0.1.tar.gz"
  sha1 "6f1bd52691f9368d7237bb63490ea5e6402cb117"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
