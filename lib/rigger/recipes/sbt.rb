namespace :sbt do
  task :assembly do
    run_locally("~/bin/sbt assembly")
  end

  task :read_properties do
    file  = File.read(File.dirname(__FILE__) + "/../project/build.properties")
    props = Hash[*file.split("\n").map { |p| p.split("=") }.flatten]

    set :sbt_name, props["project.name"]
    set :sbt_version, props["project.version"]
    set :sbt_build_version, props["build.scala.versions"]
    set :sbt_assembly_path, File.dirname(__FILE__) + "/../target/scala_#{get(:sbt_build_version)}/#{get(:sbt_name)}-assembly-#{get(:sbt_version)}.jar"
  end

  task :update_code do
    run "mkdir #{get(:release_path)}"

    @current_servers.map do |server|
      assembly_path = get(:sbt_assembly_path)
      cmd = "rsync --progress -az --delete --rsh='ssh -p 22' #{assembly_path} #{server.connection_string}:#{get(:release_path)}/"
      Thread.new { system(cmd) }
    end.each { |t| t.join }
  end
end
