rigger
======

Deployments with a DSL that resembles capistrano/vlad's, but way simpler, and things like rolling restarts are possible. For about 6 months, we've been using rigger to deploy fetlife.com and related services dozens of times per day.

    gem install rigger

config
------

Edit `config/rig.rb`

    set :current_path, "/var/www/yr_app_home"
    server :app, "app@server"
    server :db, "db@server"

dsl
---

see `rigger/recipes` for examples

    role = @current_servers.first.role
    conf = get(:chef_config).merge(:role => role,
                                   :run_list => "role[#{role}]").to_json
    run "mkdir -p #{get(:release_path)}/config"
    chef_config =<<-_END_
      cookbook_path    ["/var/chef/cookbooks",
                        "#{get(:release_path)}/cookbooks"]
      log_level         :info
      file_cache_path  "/var/chef"
      role_path        "#{get(:release_path)}/roles"
      Chef::Log::Formatter.show_time = false
    _END_
    put chef_config, get(:release_path) + "/config/chef-solo.rb"
    put conf, get(:release_path) + "/config/chef.json"

wanted
------

* specs
* docs

Copyright
=========

Copyright (c) 2011 James Golick. See LICENSE.txt for
further details.

