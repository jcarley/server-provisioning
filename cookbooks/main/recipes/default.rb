package "zsh"

directory "/var/chef/cache" do
  owner "root"
  group "root"
  mode "755"
  action :create
end

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

include_recipe "nginx::source"
