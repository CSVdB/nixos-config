# Needed commands

Feedback loop: find . | entr nix-build
Start up VM: $(nix-build test.nix -A driverInteractive)/bin/nixos-test-driver -I



