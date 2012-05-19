package "zsh"

directory "/var/chef/cache" do
  owner "root"
  group "root"
  mode "755"
  action :create
end

include_recipe "nginx::source"

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

directory "/home/apps/#{node[:user][:name]}/example" do
  owner node[:user][:name]
end

file "/home/apps/#{node[:user][:name]}/example/index.html" do
  owner node[:user][:name]
  content "<h1>Hello World!</h1>"
end

file "#{node[:nginx][:dir]}/sites-available/example" do
  content "server { root /home/apps/#{node[:user][:name]}/example; }"
end

nginx_site "example"
