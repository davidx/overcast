

module Overcast
  class Configuration
   def self.check_exists(file)
    unless File.exists?(file)
      p "please create the config file #{file} "
      exit 1
    end
  end
   def self.credentials
     credentials_config_file = ENV['HOME'] + '/.fog'
     check_exists credentials_config_file
     credentials = YAML.load(IO.read(credentials_config_file))
   end
    def self.read_config
      main_config_file = File.dirname(__FILE__) + '/../../config/overcast.yml'
      check_exists main_config_file
      YAML.load(IO.read(main_config_file))
    end
   def self.get_config_for_profile(profile_name)
     main_config = read_config
     defaults = main_config[:defaults]
     unless main_config[:profiles].key?(profile_name.to_sym)
      raise "no such profile defined in config, please define a profile"
     end
      profile_server_config = main_config[:profiles][profile_name.to_sym]
      profile_server_config = defaults.merge(profile_server_config)
      profile_server_config[:key_name] = key_name
      print profile_server_config.inspect if ENV.key?('DEBUG')
     profile_server_config
   end  
  end
end
