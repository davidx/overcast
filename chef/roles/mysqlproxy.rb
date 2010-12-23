$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'data_provider'

name "mysqlproxy"
description "mysql proxy"

run_list("recipe[base]", "recipe[mysqlproxy]")


# Attributes applied if the node doesn't have it set already.
default_attributes(
    :mysql_proxy => {
        :databases => {
            :dev => {
                :masters => rds_masters('dev').collect { |db| "#{db}:3306" },
                :slaves  => rds_slaves('dev').collect { |db| "#{db}:3306" },
            },
        },
    }
)

# Attributes applied no matter what the node has set already.
#override_attributes()
