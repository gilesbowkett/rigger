# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rigger}
  s.version = "0.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Golick"]
  s.date = %q{2011-06-21}
  s.default_executable = %q{rig}
  s.description = %q{}
  s.email = %q{jamesgolick@gmail.com}
  s.executables = ["rig"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "TODO",
    "VERSION",
    "bin/rig",
    "config/rig.rb",
    "lib/rigger.rb",
    "lib/rigger/cli.rb",
    "lib/rigger/connection_set.rb",
    "lib/rigger/dsl.rb",
    "lib/rigger/execution_strategy.rb",
    "lib/rigger/recipes/chef.rb",
    "lib/rigger/recipes/deploy.rb",
    "lib/rigger/recipes/sbt.rb",
    "lib/rigger/recipes/service.rb",
    "lib/rigger/server.rb",
    "lib/rigger/server_resolver.rb",
    "lib/rigger/task.rb",
    "lib/rigger/task_execution_service.rb",
    "lib/rigger/task_executor.rb",
    "spec/server_resolver_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/jamesgolick/rigger}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.9.2}
  s.summary = %q{}
  s.test_files = [
    "spec/server_resolver_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-ssh-multi>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<net-sftp>, ["= 2.0.5"])
      s.add_runtime_dependency(%q<popen4>, ["= 0.1.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_development_dependency(%q<bourne>, [">= 1.0"])
      s.add_runtime_dependency(%q<net-ssh-multi>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<popen4>, ["= 0.1.2"])
    else
      s.add_dependency(%q<net-ssh-multi>, ["= 1.0.1"])
      s.add_dependency(%q<net-sftp>, ["= 2.0.5"])
      s.add_dependency(%q<popen4>, ["= 0.1.2"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<bourne>, [">= 1.0"])
      s.add_dependency(%q<net-ssh-multi>, ["= 1.0.1"])
      s.add_dependency(%q<popen4>, ["= 0.1.2"])
    end
  else
    s.add_dependency(%q<net-ssh-multi>, ["= 1.0.1"])
    s.add_dependency(%q<net-sftp>, ["= 2.0.5"])
    s.add_dependency(%q<popen4>, ["= 0.1.2"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<bourne>, [">= 1.0"])
    s.add_dependency(%q<net-ssh-multi>, ["= 1.0.1"])
    s.add_dependency(%q<popen4>, ["= 0.1.2"])
  end
end

