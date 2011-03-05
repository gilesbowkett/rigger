namespace :deploy do
  task :bootstrap do
    set :shared_path,   "#{get(:deploy_to)}/shared"
    set :releases_path, "#{get(:deploy_to)}/releases"
    set :release_path,  "#{get(:deploy_to)}/releases/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    set :current_path,  "#{get(:deploy_to)}/current"
  end

  task :setup do
    run_task("deploy:bootstrap")

    run "mkdir -p #{get(:deploy_to)}"
    run "mkdir -p #{get(:shared_path)}"
    run "mkdir -p #{get(:releases_path)}"
  end

  # ripped off mostly from capistrano
  task :keep_releases do
    keep          = fetch(:keep_releases, 5)
    releases_path = get(:releases_path)
    releases      = capture("cd #{releases_path} && ls -x").strip.split.sort

    if keep >= releases.length
      puts "no old releases to clean up"
    else
      puts "keeping #{keep} of #{releases.length} deployed releases"

      directories = (releases - releases.last(keep)).map do |release|
        File.join(releases_path, release)
      end.join(" ")

      run "rm -rf #{directories}"
    end
  end

  task :rollback do
    releases = capture("cd #{releases_path} && ls -x").strip.split.sort
    run "rm -rf #{get(:release_path)}; true"

    if releases.length > 1
      run "ln -nfs #{File.join(get(:releases_path), releases[-2])} #{get(:current_path)}"
    else
      puts "    no releases to rollback to. skipping rollback of symlink..."
    end

    run_task "deploy:restart"
  end

  task :symlink do
    run "ln -nfs #{get(:release_path)} #{get(:current_path)}"
  end

  task :restart, :role => :app, :serial => true do
    run "sudo god restart #{get(:application)}"
  end
end
