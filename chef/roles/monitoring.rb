name "monitoring"
description "monitoring role"
run_list(["recipe[base]", "recipe[nagios]"])
default_users = %{nagios}.join(',')

default_attributes(
    :nagios => {
        :package => 'nagios-HEAD.tar.gz',
        :package_source_url => 'http://nagios.sourceforge.net/download/cvs/',
        :cgi => { :users => { :default => default_users,
                              :authorized_for_system_information => default_users,
                              :authorized_for_configuration_information => default_users,
                              :authorized_for_system_commands => default_users,
                              :authorized_for_all_services => default_users,
                              :authorized_for_all_hosts => default_users,
                              :authorized_for_all_service_commands => default_users,
                              :authorized_for_all_host_commands => default_users,
                            },
                  :html_url_path => '/nagios',
                },
        },
        :roles          => {
            :app => {
                :service_checks => ['http'],
                :hosts => Overcast::DataProvider.find_hosts_for_role(:app)
            },
            :smtp => {
               :service_checks => ['smtp'],
               :hosts => Overcast::DataProvider.find_hosts_for_role(:smtp)                
            }

        },
        :contacts       => [
            {
                :name  => 'david',
                :alias => 'davidx ops',
                :email =>'davidx@davidx.org'
            },
            {

                :name  => 'nickburns2000',
                :alias => 'Nick Burns',
                :email => 'nickburns@exmample.com'
            }
        ],
        :contact_groups => [
            {
                :name    => 'admins',
                :alias   => 'Admin Users',
                :members => %w[
                                davidx
                                nick
                              ]
            }

        ],

    }
)


# Attributes applied no matter what the node has set already.
#override_attributes()
