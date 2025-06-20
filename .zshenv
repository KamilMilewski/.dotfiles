export EDITOR=nvim
export VISUAL=nvim

# General aliases
alias ls='ls --color=auto'
# It scrolls down the terminal window to the point there is nothing shown. So it works like clear but without actually
# deleting terminal history.
alias cls='printf "\033c"'
alias grep='grep --color'
alias wifi='nmtui'
alias notes='vim -c "cd %:p:h" -- ~/Work/notes/other_notes.md'
alias notes-status="(cd ~/Misc/notes && git status && git diff)"
alias notes-save="(cd ~/Misc/notes && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias scratchpad-status="(cd ~/Misc/global-scratchpad && git status && git diff)"
alias scratchpad-save="(cd ~/Misc/global-scratchpad && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias dotfiles='vim -c "cd %:p:h" -- /home/kamil/Misc/dotfiles/.zshrc'
alias dotfiles-status="(cd ~/Misc/dotfiles && git status && git diff)"
alias dotfiles-reset="(cd ~/Misc/dotfiles && git reset --hard)"
alias dotfiles-save="(cd ~/Misc/dotfiles && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias g="git"
alias update-grub="grub-mkconfig -o /boot/grub/grub.cfg"
alias vim='nvim'
alias vi='nvim'
alias run='rofi -combi-modi window,drun,browser_bookmarks -theme solarized -font "hack 10" -show combi -icon-theme "Papirus" -show-icons -modes window,drun,combi,"browser_bookmarks:~/Misc/dotfiles/rofi_browser_bookmarks.sh"'
alias chrome="google-chrome-stable &> /dev/null &"
alias pacman-installed-explictly='pacman -Qqe | fzf'
alias pacman-installed-all='pacman -Qq | fzf'
alias top-cpu="watch -n 1 \"echo '---TOP CPU---' && ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | head -n 6 && echo '---TOP MEMORY---' && ps -Ao user,uid,comm,pid,%mem,tty --sort=-%mem | head -n 6\""

# ruby/rails
alias be="bundle exec"
alias ber="bundle exec rspec"
alias berf="bundle exec rspec --only-failures"
alias bec="bundle exec rails console"
alias bes="bundle exec rails server"
alias beg="bundle exec rails generate"
alias bek="bundle exec rake"

system-update() {
  echo "################################################################################
############################ Starting system update ############################
################################################################################"
  # store last system update date so it could be accessed later on with command system-last-update
  echo "$(date)" >> ~/Temp/last_system_update_dates

  echo "\n======Updating mirrors list======\n"
  sudo reflector --latest 5 --country 'Poland,Germany,' --sort rate --protocol https --save /etc/pacman.d/mirrorlist
  echo "\n======Updating system packages (Pacman)======\n"
  sudo pacman -Syyu --noconfirm
  echo "\n======Updating AUR packages (yay)======\n"
  yay -Syu --aur --noconfirm
  echo "\n======Updating asdf plugins=======\n"
  asdf plugin update --all
  echo "\n======Update neovim plugins======\n"
  # Run install, clean and update vim plugins
  vim --headless "+Lazy! sync" +qa
  echo "\n======Clean up system packages======\n"
  system-clean
  echo "\n\n======Finished system update======\n"
}
system-clean() {
  echo "\n======Cleaning up pacman cache: keep only last 2 recent versions of cached packages======\n"
  sudo paccache -rk 2
  echo "\n======Cleaning up pacman cache: remove all cache of uninstalled packages======\n"
  sudo paccache -ruk0
  echo "\n======Cleaning up yay cache======\n"
  sudo rm -rf ~/.cache/yay
  echo "\n======Pacman: remove orphaned packages======\n"
  sudo pacman -Qtdq | sudo pacman -Rns -
  echo "NOTE: If no orphans were found, the output is error: argument '-' specified with empty stdin.\n" \
       " This is expected as no arguments were passed to pacman -Rns."
  echo "\n=======Finished cleaning up system======\n"
}
system-last-update() {
  tail -n 1 ~/Temp/last_system_update_dates
}
mysql-console() {
  echo "==================================================="
  echo "type 'USE <database name>;' to select database"
  echo "type 'SHOW databases;' to list available databases"
  echo "type 'DROP DATABASE \`<database name>\`;' to remove database"
  echo "==================================================="
  mysql -h localhost -P 3306 --protocol=tcp -u root -psupersecret
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

