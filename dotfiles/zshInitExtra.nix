''
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
''
