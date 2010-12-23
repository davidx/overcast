$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'data_provider'

name "loadbalancer"
description "load balancer role"

run_list("recipe[base]", "recipe[varnish]", "recipe[haproxy]")

#
# Attributes applied if the node doesn't have it set already.
default_attributes(
    :haproxy => {
        :vips => {:search => {:listen      => '0.0.0.0:9312',
                              :mode        => 'tcp',
                              :server_port => '9312',

                              :servers     => ec2_servers(:search),
                              :balance     => 'leastconn',
        },
                  :app    => {

                      :listen      => '0.0.0.0:81',
                      :mode        => 'http',
                      :stats       => true,
                      :stats_auth  => "admin:changemenowplease",
                      :options     => ['httpclose', 'forwardfor'],
                      :server_port => '80',
                      :servers     => ec2_servers(:app),
                      :balance     => 'leastconn',
                  },
        },
    },
    :varnish => {:listen   => '0.0.0.0:80',
                 :director => [{:name     => 'apps',
                                :probe    => {
                                    :url       => "/",
                                    :interval  => '5s',
                                    :timeout   => '5s',
                                    :window    => 5,
                                    :threshold => 3,


                                },
                                :backends => ec2_servers(:app),
                               }],
    }
)
