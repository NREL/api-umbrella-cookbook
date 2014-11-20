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
    package_checksum = "58efa3e8285871270eed5cd754f130bb51ba2d002a62a534b0b281d4bfd63ff8"
  when 7
    package_path = "el/7/api-umbrella-#{node[:api_umbrella][:version]}-1.el7.x86_64.rpm"
    package_checksum = "c04ac8b79ece518fbb7128d5d3e8ec1ca2b886c3812f3bd4f3125b00c37d5ff9"
  end
when "debian"
  case(node[:platform])
  when "debian"
    case(node[:platform_version].to_i)
    when 7
      package_path = "debian/7/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "4ceafe9554232c81da7cb993764e1c3a97adafb80d31d6f6e06332bd40372e67"
    end
  when "ubuntu"
    case(node[:platform_version])
    when "14.04"
      package_path = "ubuntu/14.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "49cae3321ab0631e38cbc8f216e165bb229c86a95c52ae6a4ebfbb44a2359006"
    when "12.04"
      package_path = "ubuntu/12.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "b82f0a648ed977ede2dfdc977103d27e530422ecf6fe3252e95dd385c5635384"
    end
  end
end

if(package_path && package_checksum)
  default[:api_umbrella][:package_url] = "https://developer.nrel.gov/downloads/api-umbrella/#{package_path}"
  default[:api_umbrella][:package_checksum] = package_checksum
end

default[:api_umbrella][:config] = {}
