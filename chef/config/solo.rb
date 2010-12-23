#
# Chef Solo Config File
#
top_dir = File.expand_path(File.dirname(__FILE__) + "/../")
log_level          :debug
log_location       STDOUT
file_cache_path top_dir
cookbook_path top_dir + "/cookbooks"
role_path top_dir + "/roles"

Mixlib::Log::Formatter.show_time = true
