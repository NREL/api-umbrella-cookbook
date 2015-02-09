#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.7.0"

package_path = nil
package_checksum = nil

case node[:platform_family]
when "rhel"
  case(node[:platform_version].to_i)
  when 6
    package_path = "el/6/api-umbrella-#{node[:api_umbrella][:version]}-1.el6.x86_64.rpm"
    package_checksum = "00b54462ba7e83fca65bd380e3cd1d9364d00bcfb19ad313e5dc22a7c708bdf6"
  when 7
    package_path = "el/7/api-umbrella-#{node[:api_umbrella][:version]}-1.el7.x86_64.rpm"
    package_checksum = "4c78a83e0b2f746a107373cd958b6ae49be8bff34dad947e4201f21c571d6828"
  end
when "debian"
  case(node[:platform])
  when "debian"
    case(node[:platform_version].to_i)
    when 7
      package_path = "debian/7/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "bd4f9d71a2015ed564e5f27948a3bf932dd398dd2983cd2c747103d1bca545a7"
    end
  when "ubuntu"
    case(node[:platform_version])
    when "14.04"
      package_path = "ubuntu/14.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "f0a926874223d38693e901ecba750dec9f4253a350afe97623a9cf6b948899c5"
    when "12.04"
      package_path = "ubuntu/12.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "56752c704761c53d56385c48d340f0d58e8f1a7610941518af58664abba6fe83"
    end
  end
end

if(package_path && package_checksum)
  default[:api_umbrella][:package_url] = "https://developer.nrel.gov/downloads/api-umbrella/#{package_path}"
  default[:api_umbrella][:package_checksum] = package_checksum
end

default[:api_umbrella][:config] = {}
