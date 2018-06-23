with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "st";
    src = fetchurl {
        url = "https://gitlab.com/pacmeister/st/-/archive/master/st-master.tar.gz";
        sha256 = "88688d013711219dd1df1affb96ac47e6ac8077652768b19f6025dd7cdd2233d";
    };
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ xorg.libX11 ncurses xorg.libXext xorg.libXft fontconfig ];
    installPhase = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out
        '';
}
