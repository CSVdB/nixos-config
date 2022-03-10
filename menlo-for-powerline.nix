{ stdenv, fetchFromGitHub, ... }:


stdenv.mkDerivation rec {
  version = "0";

  pname = "menlo-for-powerline";

  menlo-for-powerline = fetchFromGitHub {
    owner = "abertsch";
    repo = "Menlo-for-Powerline";
    rev = "07e91f66786b3755d99dcfe52b436cf1c2355f38";
    sha256 = "sha256:0883rddlxrv6aka7dzhdglhz3xn17wkafybxiv1rdxz2p4r62967";
  };

  nativeBuildInputs = [ ];

  sourceRoot = ".";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp ${menlo-for-powerline}/*.ttf $out/share/fonts/truetype
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256:0h05fghyfwj40xirpn9zxl21vmh81g63bv3yj29b3595spylmpcx";

  meta = {
    description = "Menlo for Powerline font";
    homepage = https://github.com/abertsch/Menlo-for-Powerline;
  };
}
