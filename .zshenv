export EDITOR=nvim
export VISUAL=nvim

# General aliases
alias ls='ls --color=auto'
# It scrolls down the terminal window to the point there in nothing shown. So it works like clear but without actually
# deleting terminal history.
alias cls='printf "\033c"'
alias grep='grep --color'
alias pdf='zathura --fork --mode fullscreen'
alias wifi='nmtui'
alias notes='vim -c "cd %:p:h" -- ~/Work/notes/other_notes.md'
alias notes-status="(cd ~/Work/notes && git status && git diff)"
alias notes-save="(cd ~/Work/notes && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias dotfiles='vim -c "cd %:p:h" -- /home/kamil/Misc/dotfiles/.zshrc'
alias dotfiles-status="(cd ~/Misc/dotfiles && git status && git diff)"
alias dotfiles-reset="(cd ~/Misc/dotfiles && git reset --hard)"
alias dotfiles-save="(cd ~/Misc/dotfiles && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias people-dotfiles='vim -c "cd %:p:h" -- ~/Misc/people_dotfiles/stealit'
alias g="git"
alias update-grub="grub-mkconfig -o /boot/grub/grub.cfg"
alias vim-update='asdf uninstall neovim && asdf install neovim ref:master'
alias vim='nvim'
alias run='rofi -combi-modi window,drun,ssh -theme solarized -font "hack 10" -show combi -icon-theme "Papirus" -show-icons'

# ruby/rails
alias be="bundle exec"
alias ber="bundle exec rspec"
alias besr="bundle exec spring rspec"
alias berf="bundle exec rspec --only-failures"
alias besrf="bundle exec spring rspec --only-failures"
alias bec="bundle exec rails console"
alias besc="bundle exec spring rails console"
alias bes="RAISE_API_EXCEPTIONS=true bundle exec rails server"
alias bess="RAISE_API_EXCEPTIONS=true bundle exec spring rails server"
alias beg="bundle exec rails generate"
alias bek="bundle exec rake"
alias rubo="bundle exec rubocop --auto-correct"
dbregen() {
  chmod 777 bin/rails
  bin/rails db:environment:set RAILS_ENV=test
  bundle exec rake db:drop db:create db:migrate RAILS_ENV=test
}
rspec_profiled() {
  touch log/test.log
  echo "truncating test log file"
  truncate -s 0 log/test.log

  if [ $# -eq 0 ] # if argument passed
  then
    echo "running against whole test suite"
    bundle exec rspec
  else
    echo "running against test: "
    echo $1
    bundle exec rspec $1
  fi
  NUMBER_OF_DB_INSERTIONS=$(<./log/test.log | egrep -o "INSERT INTO \`(\w+)\`" | wc -l)
  NUMBER_OF_DB_UPDATES=$(<./log/test.log | egrep -o "UPDATE \`(\w+)\` SET" | wc -l)
  NUMBER_OF_DB_SELECTS=$(<./log/test.log | egrep -o "SELECT\s+\`\w+\`\.\*\s+FROM" | wc -l)
  echo "===========PERFORMANCE REPORT========================="
  echo "total number of db insertions: $NUMBER_OF_DB_INSERTIONS"
  echo "total number of db updates: $NUMBER_OF_DB_UPDATES"
  echo "total number of db selects: $NUMBER_OF_DB_SELECTS"
  echo "INSERTIONS BY TABLE:"
  <./log/test.log | egrep -o "INSERT INTO \`(\w+)\`" | sort | uniq -c | sort -nr
  echo "UPDATES BY TABLE:"
  <./log/test.log | egrep -o "UPDATE \`(\w+)\` SET" | sort | uniq -c | sort -nr
}
audio-mic-set-gain() {
  while sleep 0.1; do pacmd set-source-volume alsa_input.pci-0000_00_1b.0.analog-stereo 16000; done
}
audio-mic-set-ext() {
  pacmd set-source-port 1 analog-input-headset-mic
  pacmd list-sources | grep 'active port'
}
audio-mic-set-int() {
  pacmd set-source-port 1 analog-input-internal-mic
  pacmd list-sources | grep 'active port'
}
libre() {
  libreoffice "$@" &> /dev/null &
}
system-update() {
  echo "\n======Updating system packages======\n"
  sudo pacman -Syu --noconfirm
  echo "\n======Updating asdf plugins=======\n"
  asdf plugin update --all
  # Removed form system update for now since it now compiles from source and its taking way to long
  # echo "\n======Updating asdf neovim======\n"
  # vim-update
  echo "\n======Update neovim plugins======\n"
  vim +PlugUpdate +PlugClean! +qall
}
system-clean() {
  echo "\n======Cleaning up pacman cache: keep only last 2 recent versions of cached packages======\n"
  sudo paccache -rk 2
  echo "\n======Cleaning up pacman cache: remove all cache of uninstalled packages======\n"
  sudo paccache -ruk0
  echo "\n======Pacman: remove orphaned packages======\n"
  sudo pacman -Qtdq | sudo pacman -Rns -
  echo "NOTE: If no orphans were found, the output is error: argument '-' specified with empty stdin.\n" \
       " This is expected as no arguments were passed to pacman -Rns."
  echo "\n=======Finished cleaning up system======\n"
}


# tap specific aliases
alias tap_workspace="sh ~/Misc/dotfiles/system_workspaces/tap.sh"
alias tap-qa="bundle exec cap qa rails:console"
alias tap-qa2="bundle exec cap qa-f2 rails:console"
alias tap-replica="bundle exec cap replica rails:console"
alias tap-prototype="bundle exec cap prototype rails:console"
alias tap-locales-regen="bundle exec rake translation:setup && bundle exec rake i18n:js:export"
tap-current-specs() {
  rm -f log/test.log
  rm -f log/development.log
  rm -f log/bullet.log
  rm -f log/aws.log
  rm -f spec/examples.txt
   DEVELOPMENT= ber \
    specs here
}
mysql-start() {
  sudo systemctl start docker && \
  docker rm -f mysql && \
  docker run \
    --name=mysql \
    --publish 3306:3306 \
    --volume=/home/kamil/Misc/docker_volumes/mysql_data:/var/lib/mysql \
    --env MYSQL_ROOT_HOST='%' \
    --env MYSQL_ROOT_PASSWORD='supersecret' \
    -d mysql/mysql-server:latest
}
tap-my-prs() {
  chromium "https://gitlab.mddxtap.com/tap/tap/-/merge_requests?scope=all&utf8=%E2%9C%93&state=opened&author_username=kamil.milewski" &> /dev/null &
}
tap-new-pr() {
  chrome "https://gitlab.mddxtap.com/tap/tap/-/merge_requests/new" &> /dev/null &
}
