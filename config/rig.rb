require "stringio"

set :current_path, "/var/www/yr_app_home"
server :app, "app@server"
server :db, "db@server"

namespace :fuck do
  task :test, :depends => [] do
    #run_task "fuck:you"
    run "ls -la"
  end

  task :you, :single => true do
    run "mkdir -p /home/james/fuckit"
    put "config/rig.rb", "/home/james/asdf.txt"
    run "ls -la"
  end

  task :this do
    run "ls -lah"
  end
end
