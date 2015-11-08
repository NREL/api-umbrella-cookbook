directory "/etc/api-umbrella" do
  owner "root"
  group "root"
  mode "0755"
end

require "yaml"
template "/etc/api-umbrella/api-umbrella.yml" do
  source "api-umbrella.yml.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :reload, "service[api-umbrella]"
end
