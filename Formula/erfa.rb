class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/releases/download/v1.7.2/erfa-1.7.2.tar.gz"
  sha256 "b85ee6f723c8c01a7da85982a5f53838e8133f65ebf98ddf70a454e95cbaf96e"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/erfa-1.7.2"
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "c75179c457425c26cdcc4e099ba6dd3d6f84d9a585d5fe9ff3ea6ff76a1bca51"
    sha256 cellar: :any, arm64_monterey: "b0ceb39d3db954bda3c1adc951d1f5455f346e6b8f4d4034a9af76e31bdbb902"
    sha256 cellar: :any, ventura:        "a01a49c8dcd081987d329ebf203d75a86f4533282b32e550b7cb548a5d50a3ed"
    sha256 cellar: :any, monterey:       "c217259c00ca6a4c58c8722bb7b208eb73826bd18c58ebcbd8d4680e3058f881"
    sha256 cellar: :any, big_sur:        "e06c3fffb3fe4ecd1f0b48e65effa89f5b46e5407b658f8592bf6ec350fea83d"
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
