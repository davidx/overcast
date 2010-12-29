$:.unshift(File.dirname(__FILE__) + '/lib')

require 'overcast/data_provider'
require 'overcast/configuration'


groups.each { |group|
  next unless role_servers(group.to_sym).compact.length > 0
  role(group.to_sym) { role_servers(group.to_sym).compact }
}

require 'yaml'

default_run_options[:pty]   = true
ssh_options[:user]          = 'root'
ssh_options[:forward_agent] = true
ssh_options[:identify_file] = File.dirname(__FILE__) + '/keys'

set :dataroot, "/data/ops"
set :chefroot, "/data/ops/current/chef"
set :repository, "git@github.com:davidx/overcast.git"
set :timestamp, Time.now.strftime("%s")
set :release_path, "#{dataroot}/releases/#{timestamp}"


def emerge(packages=[])
  run "emerge #{packages.join(" ")}"
end

def gem_install(gems=[])
  run "gem install #{gems.join(' ')} --no-ri --no-rdoc"
end


def run_commands(commands)
  commands.each { |c| "echo [command:][#{c}] && echo [result:][#{`#{c}`}]" }.join(" && ")
end

namespace :overcast do
  task :bootstrap do
    run_commands bootstrap_commands
    emerge bootstrap_packages
    gem_install bootstrap_gems
    strict_host_key_prehack
  end
  task :strict_host_key_prehack do
    # initial alter to allow git repo pull after which ssh_config is rendered from recipe
    run "su - -c \"echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config\" "
  end

  task :deploy do
    cmd = ["mkdir -p #{dataroot}/releases"]
    cmd << "cd #{dataroot} && git clone #{repository} #{release_path}"
    cmd << "rm -f #{dataroot}/current"
    cmd << "ln -sf #{release_path} #{dataroot}/current"
    run cmd.join(" && ")
  end
  task :runsolo do
    update
    solo
  end


  task :solo do
    profile  = ENV.key?('PROFILE') ? ENV['PROFILE'] : 'default'

    commands = ["cd #{chefroot}"]
    commands << "gem install bundler --no-ri --no-rdoc && bundle install"
    commands << "rake chef:runsolo PROFILE=#{profile}"
    run_commands commands
  end
  task :update do
    git_command = ENV['branch'] ? "git checkout #{ENV['branch']} && git pull" : "git pull"
    run "cd #{chefroot} && #{git_command}"
  end
  task :grow do
    profile = ENV.key?('PROFILE') ? ENV['PROFILE'] : 'default'
    system "ruby bin/grow.rb --profile=#{profile}"
  end
end
