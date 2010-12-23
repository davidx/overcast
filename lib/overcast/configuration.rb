

module Overcast
  class Configuration

   def self.credentials
     credentials_config_file = ENV['HOME'] + '/.fog'
     YAML.load(IO.read(credentials_config_file))
   end
    def self.read
      main_config_file = File.dirname(__FILE__) + '/../config/overcast.yml'
      YAML.load(IO.read(main_config_file))
    end
  end
end

