require "formula"

class Erfa < Formula
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/releases/download/v1.2.0/erfa-1.2.0.tar.gz"
  sha256 "361bc9c5f783140aa337eba8379476ec45ec13627a8c839ccc1aaec104ad3316"

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
