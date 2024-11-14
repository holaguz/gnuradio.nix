{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  gr-isdbt = (callPackage ./mods/gr-isdbt.nix {
    gnuradio = gnuradio;
  });

  gr-tempest = (callPackage ./mods/gr-tempest.nix {
    gnuradio = gnuradio;
  });

  gr-satellites = (callPackage ./mods/gr-satellites.nix {
    gnuradio = gnuradio;
  });

  gnuradioWithPkgs = gnuradio.override (prev: {
    extraPackages = prev.extraPackages or [ ] ++ [
      gr-isdbt
      gr-tempest
      gr-satellites
    ];
  });

in
mkShell {

  buildInputs = with pkgs; [
    gnuradioWithPkgs
    # Add your packages here
  ];
}

# vim: sw=2 ts=2
