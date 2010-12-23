require 'rubygems'
require 'yaml'
require 'AWS'
require 'fog'

credential_config_file = ENV['HOME'] + '/.fog'


module Overcast
  module DataProvider
    module AWS
      Credentials = YAML.load(IO.read(credential_config_file))
      class Fog
        def connection
          Fog::AWS::Compute.new(Credentials[:default])
        end
      end

      class RDS
        def connection
          AWS::RDS::Base.new(Credentials[:default])
        end

        def db_instances(db_name)
          hash_path = ['DescribeDBInstancesResult']['DBInstances']['DBInstance']
          instances = connection.describe_db_instances.send(hash_path).collect do |instance|
            instance if instance['DBName'] == db_name
          end
          instances
        end
        def masters(db_name)
          db_instances(db_name).collect do|instance| 
            instance['Endpoint']['Address'] if instance['DBInstanceIdentifier'] == 'master'
          end.compact
        end
        def readslaves(db_name)
          db_instances(db_name).collect do|instance|
            instance['Endpoint']['Address'] if instance['DBInstanceIdentifier'] == 'readslave'
          end.compact
        end
      end
    end
  end
end


db_instances = Overcast::DataProvider::RDS.db_instances
RDS          = prepare_rds_data(db_instances)
print RDS.inspect if ENV.key?('DEBUG')


def rds_masters(db_name)
  db = RDS[db_name.to_s]
  (db[:masters].kind_of?(Array) ? db[:masters] : [db[:masters]]).compact
end

def rds_slaves(db_name)
  db = RDS[db_name.to_s]
  (db[:slaves].kind_of?(Array) ? db[:slaves] : [db[:slaves]]).compact
end

def role_servers(role_name)
  instances = EC2.servers.collect { |s|
    s.dns_name if s.groups.include?(role_name.to_s) and s.state == 'running' }.compact
  instances.kind_of?(Array) ? instances : []
end

def ec2_servers(role_name)
  instances = EC2.servers.collect { |s|
    {:name => s.dns_name, :ip => s.private_ip_address} if s.groups.include?(role_name.to_s) and s.state == 'running'
  }
  instances.kind_of?(Array) ? instances.compact : []
end

def groups
  EC2.describe_security_groups.body['securityGroupInfo'].collect { |g| g['groupName'] }
end
