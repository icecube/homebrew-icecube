class Erfa < Formula
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
