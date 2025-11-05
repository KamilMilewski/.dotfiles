export EDITOR=nvim
export VISUAL=nvim

# General aliases
alias ls='ls --color=auto'
# It scrolls down the terminal window to the point there is nothing shown. So it works like clear but without actually
# deleting terminal history.
alias cls='printf "\033c"'
alias grep='grep --color'
alias wifi='nmtui'
alias notes='vim -c "cd %:p:h" -- ~/Misc/notes/other_notes.md'
alias notes-status="(cd ~/Misc/notes && git status && git diff)"
alias notes-save="(cd ~/Misc/notes && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias scratchpad-status="(cd ~/Misc/global-scratchpad && git status && git diff)"
alias scratchpad-save="(cd ~/Misc/global-scratchpad && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias dotfiles='vim -c "cd %:p:h" -- /home/kamil/Misc/dotfiles/.zshrc'
alias dotfiles-status="(cd ~/Misc/dotfiles && git status && git diff)"
alias dotfiles-reset="(cd ~/Misc/dotfiles && git reset --hard)"
alias dotfiles-save="(cd ~/Misc/dotfiles && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias g="git"
alias vim='nvim'
alias vi='nvim'
alias run='rofi -combi-modi window,drun,browser_bookmarks -theme solarized -font "hack 10" -show combi -icon-theme "Papirus" -show-icons -modes window,drun,combi,"browser_bookmarks:~/Misc/dotfiles/rofi_browser_bookmarks.sh"'
alias chrome="google-chrome-stable &> /dev/null &"
alias pacman-installed-explictly='pacman -Qqe | fzf'
alias pacman-installed-all='pacman -Qq | fzf'
alias top-cpu="watch -n 1 \"echo '---TOP CPU---' && ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | head -n 6 && echo '---TOP MEMORY---' && ps -Ao user,uid,comm,pid,%mem,tty --sort=-%mem | head -n 6\""
alias hpr="dbus-run-session Hyprland"

# ruby/rails
alias be="bundle exec"
alias ber="bundle exec rspec"
alias bec="bundle exec rails console"
alias bes="bundle exec rails server"
alias beg="bundle exec rails generate"
alias bek="bundle exec rake"

# Allows to fuzzy search rails routes and copies selected one to system clipboard
# awk '{print $1}' - get first string from selected line
# tr -d '[:space:]' - get rid of surrounding whitespaces
# tee >(xclip -selection clipboard) - copy to system clipboard & display copied result in terminal
# echo - added at the end so terminal won't add 'no new line indicator'
rails-routes-selector() {
  be rails routes | fzf --header-lines=1 | awk '{print $1}' | tr -d '[:space:]' | tee >(xclip -selection clipboard); echo
}

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
