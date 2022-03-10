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
            # ".zshenv".source = ./dotfiles/zshenv;
            # ".functions/functions".source = ./dotfiles/functions;
            # ".variables/variables".source = ./dotfiles/variables;
          };
        };

        programs = {
          bash.enable = true;
          zsh = {
            enable = true;
            oh-my-zsh = {
              enable = true;
              theme = "agnoster";
            };
            initExtra = ''
              CASE_SENSITIVE="false"
              # export CC=$(which cc)
              # # No autocorrection
              # unsetopt correct_all


              ####### Aliases
              alias c='clear'
              alias x='exit'
              alias v='vim'
              alias s='~/.local/bin/smos'
              alias proj='cd ~/workflow/projects && clear'
              alias sq='clear && smos-query --workflow-dir ~/workflow/projects'
              alias work='proj && sq work'
              alias open='xdg-open'
              alias rmnotex='latexmk -c && l'

              # Git
              alias ga='git add'
              alias gc='git commit'
              alias g='git add --all . && gc'
              alias gp='git push'
              alias gpf='git push --force-with-lease'
              alias gd='git diff'
              alias gpl='git pull --ff-only'
              alias gcp='g -m "update" && gp'
              alias go='git checkout'
              alias gb='git branch'
              alias gf='git fetch'
              alias gl='git log --graph --decorate --abbrev-commit --all --pretty=oneline'

              function branch_delete() {
                  git push origin :$1
                  git branch -D $1
              } 
              alias gbd='branch_delete'

              # ls
              alias l='clear ; ls  -l -X --color=auto --group-directories-first --human-readable --time-style="+%d/%m/%y - %R"';
              alias la='l -a'

              cdls () { # Perform 'ls' after 'cd' if successful.
                builtin cd "$*"
                RESULT=$?
                if [ "$RESULT" -eq 0 ]; then
                  l
                  echo $PWD > ~/.last_dir
                fi
              }
              alias cd='cdls'
              alias ..='cd ..'
              alias ...='cd ../..'
              alias ....='cd ../../..'
              alias .....='cd ../../../..'
              alias ~='cd ~'


              # Navigation
              alias down='cd ~/Downloads'
              alias pic='cd ~/Pictures'
              alias book="cd ~/ref/books"
              alias books="cd ~/ref/personal-growth/books"
              alias pers="cd ~/ref/personal-growth/personal"
              alias journal="v ~/ref/personal-growth/journal.md"
              alias social="v ~/ref/personal-growth/social.md"
              alias csvdb="cd ~/ref/administration/consultancy/cs-vdb"
              alias salsa="cd ~/ref/code/salsa"
              alias ther="cd ~/ref/personal-growth/psychology/therapy"
              alias net="cd ~/ref/network/"
              alias plan="cd ~/ref/personal-growth/books/essays/business-plan/"

              alias code="cd ~/ref/pact/code"
              alias serv="cd ~/ref/pact/code/pact-web-server/src/Pact/Web/Server/Handler"
              alias plat="cd ~/ref/platonic"
              alias ppers="cd ~/ref/platonic/personal"
              alias stats="cd ~/ref/platonic/DanaSwapStats"
              alias dana="cd ~/ref/platonic/DanaSwap"
              alias pool="cd ~/ref/platonic/apps-team/pool-selection"
              alias apps="cd ~/ref/platonic/apps-team"
              alias floor="cd ~/ref/platonic/floorboard"
              alias dusd="cd ~/ref/platonic/dusd"


              # Workflow
              alias in='intray add'
              alias ir='intray review'
              alias someday='v ~/workflow/someday-maybe.md'
              alias life="v ~/workflow/reviews/life-goals.md"
              alias sche='v ~/ref/personal-growth/personal/schedule.md'
              alias habits='v ~/ref/personal-growth/personal/habits.md'


              # Stack
              alias stack='nice -n 15 stack'
              alias stackn='stack --no-nix --system-ghci' # Use this within nix shells.
              alias sb='stack build --file-watch --ghc-options="-freverse-errors -Wall -Werror -j4 +RTS -A128M -n2m -RTS"'
              alias st='stack test --file-watch --ghc-options="-freverse-errors -Wall -Werror -j4 +RTS -A128M -n2m -RTS"'


              # Keyboards
              alias ckin='xmodmap ~/.keyboards/kinesis'
              alias clen='xmodmap ~/.keyboards/lenovo'


              ####### End "Aliases"


              l
              # [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
            '';
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
