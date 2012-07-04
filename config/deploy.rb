require 'rvm/capistrano'

set :rvm_ruby_string, 'ruby-1.9.3-p194@juliobudal'

load 'deploy/assets'

server 'juliobudal.com', :web, :db, :app, primary: true
set :user, "server"

set :keep_releases, 2
set :application, "juliobudal"
set :deploy_to, "/home/#{user}/public/#{application}"
set :scm, :git
set :repository, "git@github.com:Weekz/juliobudal.git"
set :branch, "master"
set :use_sudo, false

default_run_options[:pty] = true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

after 'deploy:update_code', 'deploy:symlink_db'
after "deploy:update_code", 'deploy:precompile'
after "deploy:update_code" do
  run "chmod 755 #{release_path}/public -R" 
end

set :rails_env, :production

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

  desc "Precompile the assets"
  task :precompile, :roles => :app do
    run "cd #{release_path} RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

  desc "Push local changes to Git repository"
  task :push do

    # Check for any local changes that haven't been committed
    status = %x(git status --porcelain).chomp
    if status != "" and status !~ %r{^[M ][M ] config/deploy.rb$}
      raise Capistrano::Error, "Local git repository has uncommitted changes"
    end

    # Check we are on the master branch, so we can't forget to merge before deploying
    branch = %x(git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \\(.*\\)/\\1/').chomp
    if branch != "master" && !ENV["IGNORE_BRANCH"]
      raise Capistrano::Error, "Not on master branch (set IGNORE_BRANCH=1 to ignore)"
    end

    # Push the changes
    if !system "git push #{fetch(:repository)} master"
      raise Capistrano::Error, "Failed to push changes to #{fetch(:repository)}"
    end
  end
  
  before "deploy", "deploy:push"
  before "deploy:migrations", "deploy:push"
end
