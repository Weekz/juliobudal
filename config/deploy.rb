require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p194@juliobudal'

load 'deploy/assets'

server 'juliobudal.com', :web, :db, :app, primary: true
set :user, "server"

set :application, "juliobudal"
set :deploy_to, "/home/#{user}/public/#{application}"
set :scm, :git
set :repository,  "git@github.com:Weekz/juliobudal.git"
set :branch, "master"

default_run_options[:pty] = true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

after 'deploy:update_code', 'deploy:symlink_db'
after "deploy:finalize_update", "deploy:precompile"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  task :precompile, :role => :app do  
    run "cd #{release_path}/ &&  bundle exec rake assets:precompile"  
  end  
end
