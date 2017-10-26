alias reload!='. ~/.zshrc'

# vagrant
alias vagu='vagrant up --no-provision'
alias vagh='vagrant halt'
alias vagd='vagrant destroy'

# rake helpers
alias pr-rspec='RAILS_ENV=test rake db:drop && echo "test db dropped" && \
  RAILS_ENV=test rake db:create && echo "test db created" && \
  RAILS_ENV=test rake db:migrate >> /dev/null && echo "test db migrated" && \
  git checkout db/schema.rb >> /dev/null && \
  rspec spec'

alias http-server='puer'
