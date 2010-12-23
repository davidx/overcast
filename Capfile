$:.unshift(File.dirname(__FILE__) + '/lib')

require 'data_provider'


groups.each { |group|
  next unless role_servers(group.to_sym).compact.length > 0
  role(group.to_sym) { role_servers(group.to_sym).compact }
}

require 'yaml'

default_run_options[:pty]   = true
ssh_options[:user]          = 'root'
ssh_options[:forward_agent] = true

set :dataroot, "/data/ops"
set :chefroot, "/data/ops/current/chef"
set :repository, "git@github.com:davidx/overcast.git"
set :timestamp, Time.now.strftime("%s")
set :release_path, "#{dataroot}/releases/#{timestamp}"
set :bootstrap_packages, %w[
                              dev-vcs/git
                              dev-lang/ruby
                              rubygems
                          ]
set :bootstrap_gems, %w[
                              rake
                              ohai
                              chef
                              choice
                              rvm
                              bundler
                          ]

namespace :overcast do

  task :bootstrap do
    run "emerge --sync"
    run "emerge portage"
    run "emerge #{bootstrap_packages.join(' ')}"
    run "gem install #{bootstrap_gems.join(' ')} --no-ri --no-rdoc"
    run "rvm-install"
    # run "echo '[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm' >> ~/.bashrc"
    #  this is to bypass the git@github.com ssh yes/no question, todo add not_if
    run "su - -c \"echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config\" "
  end


  task :deploy, :role => :app do
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
    commands << "bundle install"
    commands << "rake chef:runsolo PROFILE=#{profile}"
    run commands.join(" && ")
  end
  task :update do
    git_command = ENV['branch'] ? "git checkout #{ENV['branch']} && git pull" : "git pull"
    run "cd #{chefroot} && #{git_command}"
  end
  task :grow do
    profile  = ENV.key?('PROFILE') ? ENV['PROFILE'] : 'default'
    system "ruby bin/grow.rb --profile=#{profile}"
  end
end
