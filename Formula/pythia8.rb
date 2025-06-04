class Pythia8 < Formula
  desc "Program for the generation of high-energy physics collision events"
  homepage "https://www.pythia.org/"
  url "https://www.pythia.org/download/pythia83/pythia8315.tgz"
  version "8.315"
  sha256 "4b2fe7341e33e90b7226fdcaa2a7bf9327987b3354e84c04f1fd9256863690ae"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/icecube/homebrew-icecube/releases/download/pythia-bottle-8351"
    sha256 cellar: :any, arm64_sequoia: "428f9a2f2211efa5d9c1122df8b7d51fdfe0c21eb263cd21668c29da369d47e3"
    sha256 cellar: :any, arm64_sonoma:  "0a7e9f36338c32bd4bbedd40125d999441ac5fbb45330dcc2dc925cdafbd17e9"
  end

  depends_on "hdf5"
  depends_on "python@3.13"
  uses_from_macos "gzip"

  def python3
    "python3.13"
  end

  def install
    ENV.cxx11

    pyver = Language::Python.major_minor_version python3
    py_prefix = if OS.mac?
      Formula["python@#{pyver}"].opt_frameworks/"Python.framework/Versions"/pyver
    else
      Formula["python@#{pyver}"].opt_prefix
    end

    # Remove unrecognized options if they cause configure to fail
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    system "./configure", "--prefix=#{prefix}",
      "--with-python=#{py_prefix}",
      "--with-python-include=#{py_prefix}/include/#{python3}",
      "--with-hdf5=#{Formula["hdf5"].opt_prefix}",
      "--with-gzip"
    system "make", "-j", ENV.make_jobs.to_s, "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOF
      // main101.cc is a part of the PYTHIA event generator.
      // Copyright (C) 2025 Torbjorn Sjostrand.
      // PYTHIA is licenced under the GNU GPL v2 or later, see COPYING for details.
      // Please respect the MCnet Guidelines, see GUIDELINES for details.

      // Keywords: basic usage; charged multiplicity

      // This is a simple test program. It fits on one slide in a talk.
      // It studies the charged multiplicity distribution at the LHC.

      #include "Pythia8/Pythia.h"
      using namespace Pythia8;
      int main() {
        // Generator. Process selection. LHC initialization. Histogram.
        Pythia pythia;
        pythia.readString("Beams:eCM = 8000.");
        pythia.readString("HardQCD:all = on");
        pythia.readString("PhaseSpace:pTHatMin = 20.");
        // If Pythia fails to initialize, exit with error.
        if (!pythia.init()) return 1;
        Hist mult("charged multiplicity", 100, -0.5, 799.5);
        // Begin event loop. Generate event. Skip if error. List first one.
        for (int iEvent = 0; iEvent < 100; ++iEvent) {
          if (!pythia.next()) continue;
          // Find number of all final charged particles and fill histogram.
          int nCharged = 0;
          for (int i = 0; i < pythia.event.size(); ++i)
            if (pythia.event[i].isFinal() && pythia.event[i].isCharged())
              ++nCharged;
          mult.fill( nCharged );
        // End of event loop. Statistics. Histogram. Done.
        }
        pythia.stat();
        cout << mult;
        return 0;
      }
    EOF
    flags = shell_output("#{bin}/pythia8-config --cflags --libs").chomp.strip.split
    # opoo "#{flags}"
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test >&/dev/null"
  end
end
