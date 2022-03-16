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
  intrayModule = sources.intray + "/nix/home-manager-module.nix";
  menlo-for-powerline = import ./menlo-for-powerline.nix pkgs;
  intrayCli = (import (sources.intray + "/default.nix")).intray-cli;

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

  systemd.user.services.syncServices = {
    enable = true;
    description = "SyncScripts";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    path = [ pkgs.git intrayCli ];
    script = "${pkgs.bash}/bin/bash /home/nick/.scripts/sync-wf.sh";
  };

  systemd.user.timers.syncServices = {
    wantedBy = [ "timers.target" ];
    partOf = [ "syncServices.service" ];
    timerConfig.OnCalendar = [ "*-*-* *:*:00" ];
  };

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
          intrayModule
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
                xmodmap ${./dotfiles/keyboards/kinesis}

                ${pkgs.redshift}/bin/redshift -b 0.9:0.1 -t 4000:4000 &

                # Set urxvt config
                ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources

                # Actually start xmonad
                exec xmonad
            '';
            ".gitconfig".source = ./dotfiles/gitconfig;
            ".gitignore_global".source = ./dotfiles/gitignore_global;
            ".keyboards/kinesis".source = ./dotfiles/keyboards/kinesis;
            ".keyboards/lenovo".source = ./dotfiles/keyboards/lenovo;
            ".scripts/sync-wf.sh".source = ./dotfiles/scripts/sync-wf.sh;
            ".scripts/set-repos.sh".source = ./dotfiles/scripts/set-repos.sh;
          };
        };

        programs = {
          bash = {
            enable = true;
            initExtra = builtins.readFile ./dotfiles/zshInitExtra;
          };
          zsh = {
            enable = true;
            oh-my-zsh = {
              enable = true;
              theme = "agnoster";
            };
            initExtra = builtins.readFile ./dotfiles/zshInitExtra;
          };
          ssh.enable = true;
          git.enable = true;
          vim.enable = true;
          chromium.enable = true;
          smos = import ./dotfiles/smos.nix;
          intray = {
            enable = true;
            config = {
              url = "https://api.intray.eu";
              username = "Nick";
            };
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
