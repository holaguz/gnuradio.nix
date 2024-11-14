{ lib, stdenv, boost, cmake, fetchFromGitHub, fftwFloat, gmp, gnuradio
, pkg-config, python3 ? gnuradio.unwrapped.python, spdlog, swig, volk }:

stdenv.mkDerivation {
  pname = "gr-tempest";
  version = "unstable-3.10";

  src = fetchFromGitHub {
    owner = "git-artes";
    repo = "gr-tempest";
    rev = "master";
    sha256 = "sha256-NhH3JvxcS4FRN+5iyqJNqp2haKXlzVwbYGm/2nxfzq4=";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [ spdlog gmp boost volk fftwFloat ]
    ++ (with python3.pkgs; [ numpy thrift ]);

  nativeBuildInputs = [ cmake pkg-config swig ]
    ++ (with python3.pkgs; [ cheetah3 mako pybind11 ]);

  cmakeFlags = [ "-DCMAKE_PREFIX_PATH=${gnuradio}" "-DENABLE_PYTHON=ON" ];

  preConfigure = ''
    modnames=$(find include/gnuradio -regex ".*\.h$" | sed "s#.*/\(.*\)\.h#\1#" | grep -v api)
    for mod in $modnames; do
        ${gnuradio}/bin/gr_modtool bind -u $mod
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for gr-tempest";
    homepage = "https://github.com/git-artes/gr-tempest";
    platforms = platforms.unix;
  };
}

# vim:sw=2 ts=2
