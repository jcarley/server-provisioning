cookbook_path File.expand_path("../cookbooks", __FILE__)
json_attribs File.expand_path("../node.json", __FILE__)
file_cache_path "/var/chef/cache"
Ohai::Config[:plugin_path] = "/etc/chef/ohai_plugins"
