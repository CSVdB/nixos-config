let
  nPkgsv = import (<nixpkgs> + "/nixos/default.nix");
  configuration = { 
    imports = [
      ./configuration.nix
      ./hardware.nix
    ];
  };
  mySystem = ( nPkgsv { inherit configuration; } ).system;
in
  mySystem
