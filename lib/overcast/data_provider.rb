require 'rubygems'
require 'yaml'
require 'AWS'
require 'fog'

$:.unshift(__FILE__)
require 'overcast/configuration'
Credentials = Overcast::Configuration.credentials

module Overcast
  module DataProvider
    class Ec2
      attr_reader :connection

      def connection
        Fog::AWS::Compute.new(Credentials["default"])
      end
    end

    class RDS
      attr_reader :connection

      def connection
        AWS::RDS::Base.new(Overcast::Configuration.credentials["default"])
      end

      def db_instances(db_name)
        hash_path = ['DescribeDBInstancesResult']['DBInstances']['DBInstance']
        instances = connection.describe_db_instances.send(hash_path).collect do |instance|
          instance if instance['DBName'] == db_name
        end
        instances
      end
      def masters(db_name)
        servers_for_replication_role(db_nme,:master)
      end
      def read_slaves(db_name)
        servers_for_replication_role(db_nme,:master)
      end
      def servers_for_replication_role(db_name, replication_role)
        db_instances(db_name.to_s).collect do |instance|
          instance['Endpoint']['Address'] if instance['DBInstanceIdentifier'] == replication_role.to_s
        end.compact
      end
    end
  end
end


FOG = Fog::AWS::Compute.new(Credentials[:default])
RDS = {} || AWS::RDS::Base.new(
    :access_key_id     => Credentials[:default][:aws_access_key_id],
    :secret_access_key => Credentials[:default][:aws_secret_access_key]
)

def rds_masters(db_name)
  db = RDS[db_name.to_s]
  (db[:masters].kind_of?(Array) ? db[:masters] : [db[:masters]]).compact
end

def rds_slaves(db_name)
  db = RDS[db_name.to_s]
  (db[:slaves].kind_of?(Array) ? db[:slaves] : [db[:slaves]]).compact
end

def role_servers(role_name)
  instances = FOG.servers.collect { |s|
    s.dns_name if s.groups.include?(role_name.to_s) and s.state == 'running' }.compact
  instances.kind_of?(Array) ? instances : []
end

def ec2_servers(role_name)
  instances = FOG.servers.collect { |s|
    {:name => s.dns_name, :ip => s.private_ip_address} if s.groups.include?(role_name.to_s) and s.state == 'running'
  }
  instances.kind_of?(Array) ? instances.compact : []
end

def groups
  FOG.describe_security_groups.body['securityGroupInfo'].collect { |g| g['groupName'] }.compact
end
