export EDITOR=nvim
export VISUAL=nvim

# General aliases
alias ls='ls --color=auto'
alias grep='grep --color'
alias notes='vim -c "cd %:p:h" -- ~/Work/notes/other_notes.md'
alias notes-status="(cd ~/Work/notes && git status && git diff)"
alias notes-save="(cd ~/Work/notes && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias dotfiles='vim -c "cd %:p:h" -- /home/kamil/Misc/dotfiles/.zshrc'
alias dotfiles-status="(cd ~/Misc/dotfiles && git status && git diff)"
alias dotfiles-save="(cd ~/Misc/dotfiles && git pull --no-rebase && git add . && git commit -m 'save point' && git push)"
alias people-dotfiles='vim -c "cd %:p:h" -- ~/Misc/people_dotfiles/stealit'
alias g="git"
alias update-grub="grub-mkconfig -o /boot/grub/grub.cfg"
alias vim='nvim'
# ruby/rails
alias be="bundle exec"
alias ber="bundle exec rspec"
alias besr="bundle exec spring rspec"
alias berf="bundle exec rspec --only-failures"
alias besrf="bundle exec spring rspec --only-failures"
alias bec="bundle exec rails console"
alias bes="bundle exec rails server"
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
# tap speciffic aliases
alias tap_workspace="sh ~/Misc/dotfiles/system_workspaces/tap.sh"
alias tap_qa="bundle exec cap qa rails:console"
alias tap_qa2="bundle exec cap qa-f2 rails:console"
alias tap_replica="bundle exec cap replica rails:console"
alias tap_prototype="bundle exec cap prototype rails:console"
alias tap_locales_regen="bundle exec rake translation:setup && bundle exec rake i18n:js:export"
tap_current_specs() {
  rm -f log/test.log
  rm -f log/development.log
  rm -f log/bullet.log
  rm -f log/aws.log
  rm -f spec/examples.txt
   ber \
    spec/concepts/form/**/* \
    spec/concepts/form_group/**/* \
    spec/concepts/form_module_value/**/* \
    spec/concepts/form_formula_template/**/* \
    spec/concepts/form_element/**/* \
    spec/concepts/form_run/**/* \
    spec/concepts/element_group_item/**/* \
    spec/concepts/element_group/**/* \
    spec/concepts/element/**/* \
    spec/concepts/element_data/**/* \
    spec/requests/api/v1/element_datas/**/* \
    spec/requests/api/v2/forms/**/* \
    spec/requests/api/v2/form_runs/**/* \
    spec/requests/api/v2/element_groups/**/* \
    spec/requests/api/v2/element_group_items/**/* \
    spec/requests/api/v2/elements/**/* \
    spec/models/form_*_spec.rb \
    spec/models/form_spec.rb \
    spec/models/element_spec.rb \
    spec/models/element_group_item_spec.rb \
    spec/models/element_group_spec.rb \
    spec/models/element_data_spec.rb \
    spec/db/deployment/v5.16/**/* \
    spec/services/export/form_pdf_service_spec.rb
}
tap_current_rubocop() {
  be rubocop -A app/concepts/form/**/* \
    app/concepts/form_group/**/* \
    app/concepts/form_module_value/**/* \
    app/concepts/form_formula_template/**/* \
    app/concepts/form_element/**/* \
    app/concepts/element_group_item/**/* \
    app/concepts/element_group/**/* \
    app/concepts/element/**/* \
    app/api/v2/forms.rb \
    app/api/v2/form_runs.rb \
    app/api/v2/elements.rb \
    app/api/v2/element_groups.rb \
    app/api/v2/element_group_items.rb \
    app/api/v2/workflow_runs.rb \
    app/services/export/form_pdf_service.rb \
    spec/models/form_*_spec.rb \
    spec/models/form_spec.rb \
    spec/models/element_group_item_spec.rb \
    spec/models/element_group_spec.rb \
    spec/db/deployment/v5.16/**/* \
    spec/services/export/form_pdf_service_spec.rb
}
mysql_start() {
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
