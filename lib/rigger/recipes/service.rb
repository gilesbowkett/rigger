namespace :service do
  task :package do
    set :bundle_name, "#{get(:application)}-#{get(:sbt_version)}.tar.gz"
    set :bundle_path, "target/#{get(:bundle_name)}"
    run_locally "tar -czv --file=#{get(:bundle_path)} config cookbooks roles -C target/scala_#{get(:sbt_build_version)} #{get(:sbt_assembly_filename)}"
  end

  task :update_code do
    run "mkdir #{get(:release_path)}"
    put File.read(get(:bundle_path)), get(:release_path) + "/" + get(:bundle_name)
    run "cd #{get(:release_path)} && tar zxvf #{get(:bundle_name)}"
  end
end
