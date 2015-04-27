#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.8.0"

package_path = nil
package_checksum = nil

case node[:platform_family]
when "rhel"
  case(node[:platform_version].to_i)
  when 6
    package_path = "el/6/api-umbrella-#{node[:api_umbrella][:version]}-1.el6.x86_64.rpm"
    package_checksum = "47b1427465d971b99e87fb6220abea8399184701f19b989574928614b5234c08"
  when 7
    package_path = "el/7/api-umbrella-#{node[:api_umbrella][:version]}-1.el7.x86_64.rpm"
    package_checksum = "6dc70c2498dba51026af99c510a89bb2f41fa8ec5a83afcf1b3be7962a1eadfd"
  end
when "debian"
  case(node[:platform])
  when "debian"
    case(node[:platform_version].to_i)
    when 7
      package_path = "debian/7/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "09a9ce43db90bc0cc1a5c53a4ab1eaf1333a27354c5ffd3137880d4678b8a45d"
    end
  when "ubuntu"
    case(node[:platform_version])
    when "14.04"
      package_path = "ubuntu/14.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "d295a8cba205df0100784e4b2617bb7245c30eeb5b2dc8e056cbe9e408ab23da"
    when "12.04"
      package_path = "ubuntu/12.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "503dfd80f3d7d46fe45a428cecfef1b8b84d783f763af00658d33eb28a1ba645"
    end
  end
end

if(package_path && package_checksum)
  default[:api_umbrella][:package_url] = "https://developer.nrel.gov/downloads/api-umbrella/#{package_path}"
  default[:api_umbrella][:package_checksum] = package_checksum
end

default[:api_umbrella][:config] = {}
