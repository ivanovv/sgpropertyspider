set :rbenv_type, :system
set :rbenv_ruby, '2.0.0-p247'

fetch(:default_env).merge!(rails_env: :production)

set :application, 'sgpropertyspider'

set :scm, :git
set :repo_url, 'https://github.com/ivanovv/sgpropertyspider.git'
set :branch, 'master'

set :deploy_to, '/home/deploy/apps/sgpropertyspider/'

set :log_level, :debug

set :linked_files, %w{config/database.yml config/spider.yml config/initializers/secret_token.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
