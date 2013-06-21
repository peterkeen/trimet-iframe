require 'rubygems'
require 'capistrano-buildpack'

set :application, "trimet-iframe"
set :repository, "git@git.bugsplat.info:peter/trimet-iframe.git"
set :scm, :git
set :additional_domains, ['trimet-iframe.petekeen.com']

role :web, "empoknor.bugsplat.info"
set :buildpack_url, "git@git.bugsplat.info:peter/bugsplat-buildpack-ruby-simple"

set :user, "peter"
set :base_port, 7700
set :concurrency, "web=1"

read_env 'prod'

load 'deploy'

