name "monitoring"
description "monitoring role"
run_list(["recipe[base]", "recipe[nagios]"])


default_attributes(
    :nagios => {
        :roles          => {
            :app => {
                :service_checks => ['http']
            },
            :smtp => {
               :service_checks => ['smtp'] 
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
