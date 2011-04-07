require "stringio"

set :current_path, "/var/www/fetlife"
server :app, "james@jamesgolick.com"
server :db, "fetlife@app1.dal.fetlife"

namespace :fuck do
  task :test, :depends => [] do
    run_task "fuck:you"
    run_locally "ls -abgjh"
    d = run "ls"
    puts d.inspect
  end

  task :you, :single => true do
    put "config/rig.rb", "/asdf.txt"
    run "ls -la"
  end
end
