class Erfa < Formula
  # bottle do
  #   root_url "http://code.icecube.wisc.edu/tools/bottles"
  #   cellar :any
  #   sha256 "775917084ad3c9306e3b194ba58833563d169937da7f3e7e277b04fd02a3df83" => :sierra
  #   sha256 "d5959442ced505d9cf4cb73265c486f12e09c59e9228e18198cfcec50acf456c" => :high_sierra
  #   rebuild 1
  #   sha256 "24bfd86d7f969554c6112566e2ff4f0450e899719ee61e62f14792ff7a2fbd71" => :mojave
  # end

  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/releases/download/v1.7.2/erfa-1.7.2.tar.gz"
  sha256 "b85ee6f723c8c01a7da85982a5f53838e8133f65ebf98ddf70a454e95cbaf96e"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "make", "check"
  end
end
