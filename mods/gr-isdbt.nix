{ lib, stdenv, boost, cmake, fetchFromGitHub, fftwFloat, gmp, gnuradio, gsl
, libsndfile, log4cpp, pkg-config, python3 ? gnuradio.unwrapped.python, spdlog
, swig, thrift, uhd, volk }:

stdenv.mkDerivation {
  pname = "gr-isdbt";
  version = "unstable-3.10";

  src = fetchFromGitHub {
    owner = "git-artes";
    repo = "gr-isdbt";
    rev = "master";
    sha256 = "sha256-gZ0rWjDr7KVyn0kyMikZnRUK9g0aZULYE1OhV6XSbBU=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ ] ++ (with python3.pkgs; [ thrift numpy ]);

  nativeBuildInputs = [
    cmake
    gmp
    log4cpp
    boost
    volk
    fftwFloat
    libsndfile
    uhd
    thrift
    pkg-config
    spdlog
    swig
  ] ++ (with python3.pkgs; [ cheetah3 mako pybind11 ]);

  cmakeFlags = [ "-DCMAKE_PREFIX_PATH=${gnuradio}" "-DENABLE_PYTHON=ON" ];

  # See: https://github.com/git-artes/gr-isdbt/pull/60/files
  patchPhase = ''
    sed -i '0,/isdbt_python\.lib/{n};s/isdbt_python\.lib/*.so/' python/isdbt/bindings/CMakeLists.txt
  '';

  preConfigure = ''
    modnames=$(find include/gnuradio/isdbt -regex ".*\.h$" | sed "s#.*/\(.*\)\.h#\1#" | grep -v api)
    for mod in $modnames; do
        ${gnuradio}/bin/gr_modtool bind -u $mod
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for gr-isdbt";
    homepage = "https://github.com/git-artes/gr-isdbt";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

# vim:sw=2 ts=2
