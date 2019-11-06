with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "st";
    version = "0.9";
    src = fetchurl {
        url = "https://github.com/pacordova/st/archive/master/st-master.tar.gz";
        sha256 = null;
    };
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ xorg.libX11 ncurses xorg.libXext xorg.libXft fontconfig ];
    installPhase = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out
        '';
}
