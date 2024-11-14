{ lib, stdenv, boost, cmake, feh, fetchFromGitHub, gmp, gnuradio, libsndfile
, pkg-config, python3 ? gnuradio.unwrapped.python, spdlog, swig, volk }:

let version = "5.6.0";

in stdenv.mkDerivation {
  pname = "gr-satellites";
  version = "${version}";

  src = fetchFromGitHub {
    owner = "daniestevez";
    repo = "gr-satellites";
    rev = "v${version}";
    sha256 = "sha256-2M1uBfuhRxdzTO60mxiLG5cCwPxC7B0xZSVwtH/+us4=";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ feh ]
    ++ (with python3.pkgs; [ construct numpy requests websocket-client ]);

  nativeBuildInputs = [ boost cmake gmp libsndfile pkg-config spdlog swig volk ]
    ++ (with python3.pkgs; [ pybind11 ]);

  cmakeFlags = [ "-DCMAKE_PREFIX_PATH=${gnuradio}" "-DENABLE_PYTHON=ON" ];

  preConfigure = ''
    modnames=$(find include/satellites -regex ".*\.h$" | sed "s#.*/\(.*\)\.h#\1#" | grep -v api)
    for mod in $modnames; do
        ${gnuradio}/bin/gr_modtool bind -u $mod
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for gr-satellites";
    homepage = "https://github.com/daniestevez/gr-satellites";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

# vim:sw=2 ts=2
