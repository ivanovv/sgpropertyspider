set :rbenv_type, :system
set :rbenv_ruby, '2.0.0-p247'

fetch(:default_env).merge!(rails_env: :production)

set :application, 'sgpropertyspider'

set :scm, :git
set :repo_url, 'https://github.com/ivanovv/sgpropertyspider.git'
set :branch, 'master'

set :deploy_to, '/home/deploy/apps/sgpropertyspider/'

set :log_level, :debug

set :linked_files, %w{config/database.yml config/spider.yml config/initializers/secret_token.rb config/email.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}


set :unicorn_conf,  "#{release_path}/config/unicorn.rb"
set :unicorn_pid,  "#{release_path}/tmp/pids/unicorn.pid"
set :unicorn_start_cmd, "(cd #{release_path}; bundle exec unicorn_rails -Dc #{fetch(:unicorn_conf)} -E production)"

namespace :deploy do
  desc "Symlink Nginx config (requires sudo)"
  task :symlink_nginx_config do
    on roles: :app do
      within release_path do
        execute :ln, "-nfs config/nginx /etc/nginx/sites-enabled/#{application}"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Get the cron log'
  task :get_cron_log do
    on roles(:app), in: :sequence, wait: 5 do
      execute :tail, "-n200 #{release_path.join('log/cron.log')}"
    end
  end
  desc 'Get the app log'
  task :get_app_log do
    on roles(:app), in: :sequence, wait: 5 do
      execute :tail, "-n100 #{release_path.join('log/production.log')}"
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
