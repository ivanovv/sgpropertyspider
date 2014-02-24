set :stage, :production
set :chruby_ruby, '2.1.0'
server '128.199.236.86', user: 'deploy', roles: %w{web app db}