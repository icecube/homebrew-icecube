require 'formula'

class Cppzmq < Formula
  homepage 'https://github.com/zeromq/cppzmq'
  url 'https://github.com/zeromq/cppzmq.git'
  version '0.0.0-brew'

  depends_on 'zeromq'

  def install
      system "mkdir -p #{include}"
      system "cp zmq.hpp #{include}/zmq.hpp"
  end
end
