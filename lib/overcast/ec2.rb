
module Overcast
  class Ec2
    def self.launch_instance(profile_server_config)
      server = EC2.connection.servers.create(profile_server_config)
      print "Please wait while your #{profile} instance is allocated\n"
      server.wait_for { print "."; ready? }

      out = ["Instance Launched"]
      out << "Public IP Address: #{server.ip_address}"
      out << "Private IP Address: #{server.private_ip_address}"
      out << "key is #{key_name}"
      out << 'sleeping 60 to let it boot up properly'
      print out.join("\n")
      sleep 60
      #TODO probe tcp in loop until ssh service has completed booting
      print server.to_yaml
      server
    end
  end
end
