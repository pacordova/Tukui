with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "st";
    version = "1";
    src = fetchurl {
        url = "https://gitlab.com/pacmeister/st/-/archive/master/st-master.tar.gz";
        sha256 = null;
    };
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ xorg.libX11 ncurses xorg.libXext xorg.libXft fontconfig ];
    installPhase = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out
        '';
}
