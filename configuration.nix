{ pkgs
, lib
, config
, utils
, ...
}:
let
  sources = import ./nix/sources.nix;
  home-manager = sources.home-manager + "/nixos/default.nix";
  smosModule = sources.smos + "/nix/home-manager-module.nix";
  menlo-for-powerline = import ./menlo-for-powerline.nix pkgs;

in 
{
  imports =
    [ (import home-manager {
      inherit pkgs;
      inherit lib;
      inherit utils;
      inherit config;} )
    ];

  nixpkgs.config.allowUnfree = true;

  fonts.fonts = [ menlo-for-powerline ];

  users = {
    mutableUsers = false;
    users = {
      root = {
        password = "test";
      };
      nick = {
        password = "nick";
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
        ];
      };
    };
  };

  time.timeZone = "Europe/Brussels";

  networking = {
    hostName = "thinkpad";
    wireless = {
      enable = true;
    };
    extraHosts = lib.strings.concatMapStrings (h: "127.0.0.1 " + h + "\n")
      [ "1movies.to"
        "123moviesfree.net"
        "ww3.123movies.domains"
        "facebook.com"
        "netflix.com"
        #"youtube.com"
        "tinder.com"
        #"mail.google.com"
        "rappi.com.co"
        "newyorkpizza.be"
      ];
  };

  nix = {
    trustedUsers = [ "root @wheel" ];
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Sane battery configuration
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Graphics
  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true; # Touchpad mouse
    displayManager = {
      defaultSession = "startx";
      startx.enable = true;
    };
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Never update this line, even if you upgrade your nixos version
  system.stateVersion = "21.11";

  # Users
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      nick = { pkgs, ... }: {
        imports = [
          smosModule
        ];
        home = {
          # Never update this line, even if you upgrade your nixos version
          stateVersion = "21.11";
          packages = with pkgs; [
            # arandr
            # cacert
            fzf
            git
            # gnupg
            # ncdu
            btop
            # tokei
            tree
            stack
            cachix
            rxvt-unicode
            xorg.xmodmap # For changing the keyboard layout
            pavucontrol
            google-chrome
          ];
          file = {
            ".Xresources".source = ./dotfiles/Xresources;
            ".xinitrc".text = ''
                # Set retype speed
                xset r rate 250 30

                # Set keyboard layout
                xmodmap ${./keyboards/kinesis}

                ${pkgs.redshift}/bin/redshift -b 0.9:0.1 -t 4000:4000 &

                # Set urxvt config
                ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources

                # Actually start xmonad
                exec xmonad
            '';
            ".gitconfig".source = ./dotfiles/gitconfig;
            ".gitignore_global".source = ./dotfiles/gitignore_global;
          };
        };

        programs = {
          bash = {
            enable = true;
            initExtra = import ./dotfiles/zshInitExtra.nix;
          };
          zsh = {
            enable = true;
            oh-my-zsh = {
              enable = true;
              theme = "agnoster";
            };
            initExtra = import ./dotfiles/zshInitExtra.nix;
          };
          ssh.enable = true;
          git.enable = true;
          vim.enable = true;
          chromium.enable = true;
          smos = {
            enable = true;
            backup.enable = true;
          };
        };
        xsession.windowManager.xmonad = {
          enable = true;
          config = pkgs.writeText "xmonad.hs" ''
            import XMonad
            main = xmonad defaultConfig {
                terminal = "urxvt"
              , modMask = mod4Mask
              , borderWidth = 10
              }
          '';
        };
      };
    };
  };
}
