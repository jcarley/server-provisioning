package "zsh"

#directory "/var/chef/cache" do
  #owner "root"
  #group "root"
  #mode "755"
  #action :create
#end

group "admin" do
end

user node[:user][:name] do
  password node[:user][:password]
  gid "admin"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/usr/bin/zsh"
end

template "/home/#{node[:user][:name]}/.zshrc" do
  source "zshrc.erb"
  owner node[:user][:name]
end

directory "/home/#{node[:user][:name]}/apps/example" do
  owner node[:user][:name]
  recursive true
end

file "/home/#{node[:user][:name]}/apps/example/index.html" do
  owner node[:user][:name]
  content "<h1>Hello World!</h1>"
end

file "#{node[:nginx][:dir]}/sites-available/example" do
  content "server { root /home/#{node[:user][:name]}/apps/example; }"
end

include_recipe "nginx::source"
nginx_site "example"
