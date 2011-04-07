require "stringio"

set :current_path, "/var/www/fetlife"
server :app, "james@jamesgolick.com"
server :db, "fetlife@app1.dal.fetlife"

namespace :fuck do
  task :test, :depends => [] do
    #run_task "fuck:you"
    run "ls -la"
  end

  task :you, :single => true do
    put "config/rig.rb", "/home/james/asdf.txt"
    run "ls -la"
  end

  task :this do
    run "ls -lah"
  end
end
