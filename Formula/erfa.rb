class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/releases/download/v1.7.2/erfa-1.7.2.tar.gz"
  sha256 "b85ee6f723c8c01a7da85982a5f53838e8133f65ebf98ddf70a454e95cbaf96e"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/erfa-1.7.2"
    rebuild 1
    sha256 cellar: :any, ventura:  "e296a7f13df263f19c14fc199931e55047042a8d4bd225c1ddcb7f52dbf31d9a"
    sha256 cellar: :any, monterey: "3def37f60fd252279f9577b21069d41d050f50c3299ee861e96e9218c03f2818"
    sha256 cellar: :any, big_sur:  "94e9f9e8176c82177ac9729536067e4d395ba765396084c144491c2565a35098"
  end

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
    (testpath/"test.cpp").write <<~EOF
      #include <erfaextra.h>

      int main (int argc, char *argv[]) {
        eraVersion();
        return 0;
      }
    EOF

    flags = %W[
      -I#{include}
      -L#{lib}
      -lerfa
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
