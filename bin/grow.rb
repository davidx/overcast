#!/usr/bin/env ruby
#
require 'rubygems'
require 'yaml'
require 'fog'
require 'choice'
require 'net/ssh'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'data_provider'

main_config_file = File.dirname(__FILE__) + '/../config/cloud.yml'
credential_config_file = ENV['HOME'] + '/.fog'

[main_config_file, credential_config_file].each do |config_file|
  unless File.exists?(config_file)
    p "please create the config file #{config_file} "
    exit 1
  end
end
config = YAML.load(IO.read(main_config_file))

Choice.options do
  header ''
  header 'Specific options:'

  option :profile, :required => true do
    short '-p'
    long '--profile=PROFILE'
    desc "The profile name, determines ami and post install configuration. (required)
  #{IO.read(main_config_file)}"
    default 'tester'
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
    default config[:defaults][:key_name]
  end
end

choices = Choice.choices


profile = choices[:profile]
key_name = choices[:key_name]

unless config[:profiles].key?(profile.to_sym)
  p "no such profile defined in config, please define a profile"
  exit 1
end

defaults = config[:defaults]
profile_server_config = config[:profiles][profile.to_sym]
profile_server_config = defaults.merge(profile_server_config)
profile_server_config[:key_name] = key_name

print profile_server_config.inspect if ENV.key?('DEBUG')


print "launching instance of profile #{profile} #{profile_server_config.to_yaml}"
roles = profile_server_config.delete(:roles)

server = EC2.servers.create(profile_server_config)
print "Please wait while your #{profile} instance is allocated\n"
server.wait_for { print "."; ready? }

print "\n"
puts "Public IP Address: #{server.ip_address}"
puts "Private IP Address: #{server.private_ip_address}"

puts "key is #{key_name}"

p 'sleeping 60 to let it bootup properly'
sleep 60

command = ['eval `ssh-agent`']
command << "ssh-add ~/.ec2/#{key_name}"
command << "cap overcast:deploy HOSTS=#{server.ip_address}"
command << "cap overcast:runsolo HOSTS=#{server.ip_address} PROFILE=#{profile}"

fullcommand = command.join(" && ")
p fullcommand

system(fullcommand)
