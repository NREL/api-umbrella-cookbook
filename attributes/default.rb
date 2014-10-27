#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.6.0"

package_path = nil
package_checksum = nil

case node[:platform_family]
when "rhel"
  case(node[:platform_version].to_i)
  when 6
    package_path = "el/6/api-umbrella-#{node[:api_umbrella][:version]}-1.el6.x86_64.rpm"
    package_checksum = "6729e74c7b6c89870901ca333d675beac0bb31a6abda944f8587ad8fc2fa5ad3"
  when 7
    package_path = "el/7/api-umbrella-#{node[:api_umbrella][:version]}-1.el7.x86_64.rpm"
    package_checksum = "6729e74c7b6c89870901ca333d675beac0bb31a6abda944f8587ad8fc2fa5ad3"
  end
when "debian"
  case(node[:platform])
  when "debian"
    case(node[:platform_version].to_i)
    when 7
      package_path = "debian/7/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "6729e74c7b6c89870901ca333d675beac0bb31a6abda944f8587ad8fc2fa5ad3"
    end
  when "ubuntu"
    case(node[:platform_version])
    when "14.04"
      package_path = "ubuntu/14.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "6729e74c7b6c89870901ca333d675beac0bb31a6abda944f8587ad8fc2fa5ad3"
    when "12.04"
      package_path = "ubuntu/12.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "6729e74c7b6c89870901ca333d675beac0bb31a6abda944f8587ad8fc2fa5ad3"
    end
  end
end

if(package_path && package_checksum)
  default[:api_umbrella][:package_path] = "https://developer.nrel.gov/downloads/api-umbrella/#{package_path}"
  default[:api_umbrella][:package_checksum] = package_checksum
end

default[:api_umbrella][:config][:services] = [
  "general_db",
  "log_db",
  "router",
  "web",
]
