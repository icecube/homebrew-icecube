require "formula"

class Erfa < Formula
  bottle do
    root_url "http://code.icecube.wisc.edu/tools/bottles/"
    cellar :any
    sha256 "775917084ad3c9306e3b194ba58833563d169937da7f3e7e277b04fd02a3df83" => :sierra
    sha256 "d5959442ced505d9cf4cb73265c486f12e09c59e9228e18198cfcec50acf456c" => :high_sierra
  end

  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/releases/download/v1.4.0/erfa-1.4.0.tar.gz"
  sha256 "035b7f0ad05c1191b8588191ba4b19ba0f31afa57ad561d33bd5417d9f23e460"

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
