#!/usr/bin/env ruby
#
require 'rubygems'
require 'yaml'
require 'fog'
require 'choice'
require 'net/ssh'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'overcast/configuration'
require 'overcast/data_provider'

main_config= Overcast::Configuration.read

credentials = Overcast::Configuration.credentials
EC2 = Overcast::DataProvider::Ec2
RDS = Overcast::DataProvider::RDS

Choice.options do
  header ''
  header 'Specific options:'

  option :profile, :required => true do
    short '-p'
    long '--profile=PROFILE'
    desc "The profile name, determines ami and post install configuration. (required)"
    default 'default'
  end
  option :bootstrap do
    short '-b'
    long '--bootstrap'
    desc "Wether to bootstrap"
    default false
  end
  option :key_name do
    short '-k'
    long '--key=KEY'
    desc 'The key name'
    default main_config[:defaults][:key_name]
  end
end

choices = Choice.choices


server = Overcast::Ec2.launch_instance(
                    Overcast::Configuration.get_config_for_profile(choices[:profile])
        )


Overcast.bootstrap_server_instance(server)


Net::SSH.start( server.ip_address, 'root',
                :forward_agent =>true,
                :keys =>["#{ENV['HOME']}/.ec2/#{choices[:key_name]}"] ) do |session|

  shell = session.shell.sync

  out = shell.pwd
  p out.stdout

  out = shell.uptime
  p out.stdout
  p out.status

  p shell.exit

end

#command = ['eval `ssh-agent`']
#command << "ssh-add ~/.ec2/#{key_name}"
#command << "cap overcast:deploy HOSTS=#{server.ip_address}"
#command << "cap overcast:runsolo HOSTS=#{server.ip_address} PROFILE=#{profile}"
#
#fullcommand = command.join(" && ")
#p fullcommand
#
#system(fullcommand)
