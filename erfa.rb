require "formula"

class Erfa < Formula
  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    sha256 "775917084ad3c9306e3b194ba58833563d169937da7f3e7e277b04fd02a3df83" => :sierra
  end

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
