require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'rails_app'
set :domain, '16.171.19.196'
set :deploy_to, '/home/deploy'
set :repository, 'git@github.com:anshumanpate/vt-backend-pw2.git'
set :branch, 'features/deploy'

# Optional settings:
  set :user, 'deploy'          # Username in the server to SSH to.
  set :port, '22'           # SSH port number.
  set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
#
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'config/puma.rb')
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log', 'pids', 'sockets', 'config/puma.rb']

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-3.0.0@default'
  # invoke :'rvm:use[ruby-3.0.0@default]'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %[mkdir -p "/home/deploy/rails_app/log"]
  command %[chmod g+rx,u+rwx "/home/deploy/rails_app/log"]

  command %[mkdir -p "/home/deploy/rails_app/pids"]
  command %[chmod g+rx,u+rwx "/home/deploy/rails_app/pids"]

  command %[mkdir -p "/home/deploy/rails_app/sockets"]
  command %[chmod g+rx,u+rwx "/home/deploy/rails_app/sockets"]

  command %[mkdir -p "/home/deploy/rails_app/scripts"]
  command %[chmod g+rx,u+rwx "/home/deploy/rails_app/scripts"]

  command %[mkdir -p "/home/deploy/rails_app/config"]
  command %[chmod g+rx,u+rwx "/home/deploy/rails_app/config"]

  command %[touch "/home/deploy/rails_app/config/database.yml"]
  command %[touch "/home/deploy/rails_app/config/secrets.yml"]
  # queue %[echo "-----> Be sure to edit '/home/deploy/rails_app/config/database.yml' and 'secrets.yml'."]

  command %{rvm install 3.0.0}
  command %{rvm use 3.0.0 --default}
  command %{gem install bundler}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
