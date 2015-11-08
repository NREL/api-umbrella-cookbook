yum_repository "api-umbrella" do
  description "API Umbrella"
  baseurl "https://dl.bintray.com/nrel/api-umbrella-el6"
  gpgcheck false
  enabled true
  action :create
end

package "api-umbrella" do
  version node[:api_umbrella][:version]
end

include_recipe "api-umbrella::config_file"

service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
