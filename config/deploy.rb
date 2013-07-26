require 'bundler/capistrano'
require 'puma/capistrano'

load 'config/recipes/base'
load 'config/recipes/foreman'
load 'config/recipes/nginx'
load 'config/recipes/nodejs'
load 'config/recipes/postgresql'
load 'config/recipes/rbenv'
load 'config/recipes/redis'

server 'egtaonline.eecs.umich.edu', :web, :app, :db, primary: true

set :application, 'egtaonline'
set :user, 'deployment'
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository,  'git@github.com:egtaonline/egtaonline3.git'
set :branch 'master'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup'