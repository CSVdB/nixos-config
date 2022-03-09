let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
  pkgs.mkShell {
    name = "nixos-shell";
    buildInputs = [
      (import sources.niv {inherit pkgs;}).niv
      (import sources.feedback).feedback
    ];
  }
