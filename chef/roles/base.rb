$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'data_provider'


name "base"
description "base role applied to all nodes."
run_list("recipe[systembase]", "recipe[ganglia::client]")

default_attributes(
    :users    => {
        :davidx => {
            :comment => 'David Andersen',
            :uid     => 1500,
            :gid     => 'users',
            :homedir => '/home/davidx',
            :shell   => '/bin/zsh',
        },
        :app    => {
            :comment => 'app user',
            :uid     => 1501,
            :gid     => 'users',
            :homedir => '/home/app',
            :shell   => '/bin/zsh',
        },
    },


    :packages => %w{
      app-admin/ec2-ami-tools
      app-admin/ec2-api-tools
      app-admin/sudo
      app-admin/syslog-ng
      app-editors/vim
      app-misc/screen
      app-misc/sphinx
      app-portage/cfg-update
      dev-lang/ruby-enterprise
      dev-libs/libmemcache
      dev-libs/libmemcached
      dev-ruby/rubygems
      dev-util/strace
      dev-vcs/bzr
      dev-vcs/git
      net-analyzer/netcat
      net-analyzer/nmap
      net-misc/memcached
      sys-apps/slocate
      sys-devel/distcc
      sys-fs/xfsprogs
      sys-libs/libmath++
      sys-process/atop
      sys-process/vixie-cron
      virtual/mysql
      www-client/lynx
      }
)

