require 'formula'

class Cvmfs < Formula
  homepage ''
  url 'https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.1.12/cvmfs-2.1.12.tar.gz'
  sha256 'aa3440ec5ff622733bd7e90610c7754814e6e56fca8fac27e5c3f71907ee80f8'

  depends_on 'cmake' => :build
  depends_on 'sqlite'
  depends_on 'leveldb'
  depends_on 'google-sparsehash'
  depends_on 'fuse4x'
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # Don't try to download external tools
    system "rm", "bootstrap.sh"
    # Give the configuration header the right name
    inreplace 'cvmfs/tracer.cc' do |s|
      s.gsub! /config.h/, 'cvmfs_config.h'
    end
    inreplace 'cvmfs/CMakeLists.txt' do |s|
      s.gsub! /\sfuse\s/, ' ${FUSE_LIBRARIES} '
    end
    # Still not relocatable, but at least in a different location
    ['add-ons/check_cvmfs.sh',
     'cvmfs/CMakeLists.txt',
     'cvmfs/cvmfs.cc',
     'cvmfs/cvmfs_config',
     'cvmfs/cvmfs_server',
     'cvmfs/libcvmfs.cc',
     'cvmfs/options.cc',
     'cvmfs/signature.cc',
     'mount/config.sh',
     'mount/default.conf',
     'mount/domain.d/cern.ch.conf',
     'mount/mount.cvmfs'].each do |path|
      inreplace path do |s|
        s.gsub! '/etc/cvmfs', "#{prefix}/etc/cvmfs"
      end
    end
    inreplace 'mount/mount.cvmfs' do |s|
      s.gsub! '/usr/bin', "#{prefix}/bin"
      s.gsub! '/usr/lib', "#{prefix}/lib"
    end
    inreplace 'mount/CMakeLists.txt' do |s|
      s.gsub! '/sbin', "#{prefix}/sbin"
      s.gsub! '/etc', "#{prefix}/etc"
    end
    
    # write a CMake module for LevelDB, since they didn't bother to ship one
    File.open("cmake/Modules/FindLevelDB.cmake", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<-EOS.undent
      if (LEVELDB_LIBRARY AND LEVELDB_INCLUDE_DIR)
        # in cache already
        set(LEVELDB_FOUND TRUE)
      else (LEVELDB_LIBRARY AND LEVELDB_INCLUDE_DIR)
        # use pkg-config to get the directories and then use these values
        # in the FIND_PATH() and FIND_LIBRARY() calls
        find_path(LEVELDB_INCLUDE_DIR
          NAMES
            leveldb/db.h
          PATHS
            ${_LEVELDB_INCLUDEDIR}
            /usr/include
            /usr/local/include
            /opt/local/include
            /sw/include
        )

        find_library(LEVELDB_LIBRARY
          NAMES
            leveldb
          PATHS
            ${_LEVELDB_LIBDIR}
            /usr/lib
            /usr/local/lib
            /opt/local/lib
            /sw/lib
        )

        if (LEVELDB_LIBRARY)
          set(LEVELDB_FOUND TRUE)
        endif (LEVELDB_LIBRARY)

        set(LEVELDB_INCLUDE_DIRS
          ${LEVELDB_INCLUDE_DIR}
        )

        if (LEVELDB_FOUND)
          set(LEVELDB_LIBRARIES
            ${LEVELDB_LIBRARIES}
            ${LEVELDB_LIBRARY}
            CACHE PATH "LevelDB libraries" FORCE
          )
        endif (LEVELDB_FOUND)

        if (LEVELDB_INCLUDE_DIRS AND LEVELDB_LIBRARIES)
           set(LEVELDB_FOUND TRUE)
        endif (LEVELDB_INCLUDE_DIRS AND LEVELDB_LIBRARIES)

        if (LEVELDB_FOUND)
          if (NOT LevelDB_FIND_QUIETLY)
            message(STATUS "Found LevelDB: ${LEVELDB_LIBRARIES}")
          endif (NOT LevelDB_FIND_QUIETLY)
        else (LEVELDB_FOUND)
          if (LevelDB_FIND_REQUIRED)
            message(FATAL_ERROR "Could not find LevelDB")
          endif (LevelDB_FIND_REQUIRED)
        endif (LEVELDB_FOUND)

        # show the LEVELDB_INCLUDE_DIRS and LEVELDB_LIBRARIES variables only in the advanced view
        mark_as_advanced(LEVELDB_INCLUDE_DIRS LEVELDB_LIBRARIES LEVELDB_INCLUDE_DIR LEVELDB_LIBRARY)

      endif (LEVELDB_LIBRARY AND LEVELDB_INCLUDE_DIR)
      EOS
    end
    system "cmake", ".",
                    "-DBUILD_SERVER=OFF",
                    "-DSQLITE3_BUILTIN=OFF",
                    "-DLIBCURL_BUILTIN=OFF",
                    "-DZLIB_BUILTIN=OFF",
                    "-DSPARSEHASH_BUILTIN=OFF",
                    "-DLEVELDB_BUILTIN=OFF",
                    *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test cvmfs`.
    system "false"
  end
end
