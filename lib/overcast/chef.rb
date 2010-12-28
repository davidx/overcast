module Overcast
  Bootstrap = { :commands =>
          %w{
          "emerge --sync"
          "emerge portage"
          "etc-update"
          "rc-update add sshd default"
          },

          :packages =>
          %w{
          dev-vcs/git
          dev-lang/ruby
          rubygems
         },


        :gems =>
          %w{
          rake
          ohai
          chef
          choice
          bundler
        }
  }
  class Chef
    def self.bootstrap

    end
  end
end