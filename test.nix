let
  pkgs = import <nixpkgs> {};
in
  pkgs.nixosTest {
    name = "vm-version-of-my-configuration";
    machine = import ./configuration.nix;
    testScript = ''
      # thinkpad.start()
      # thinkpad.wait_for_unit("multi-user.target")
    '';
  }

