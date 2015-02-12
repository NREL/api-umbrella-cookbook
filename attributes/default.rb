#
# Cookbook Name:: api-umbrella
# Attributes:: api-umbrella
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:api_umbrella][:version] = "0.7.1"

package_path = nil
package_checksum = nil

case node[:platform_family]
when "rhel"
  case(node[:platform_version].to_i)
  when 6
    package_path = "el/6/api-umbrella-#{node[:api_umbrella][:version]}-1.el6.x86_64.rpm"
    package_checksum = "262a23fbcfd790daf715616a551f28712075e357e82a1da5b105b388b6f4ca33"
  when 7
    package_path = "el/7/api-umbrella-#{node[:api_umbrella][:version]}-1.el7.x86_64.rpm"
    package_checksum = "fe25bc62b3e44273cd515fb8107864a6388803574e44fe145f1c2b6bf747fbea"
  end
when "debian"
  case(node[:platform])
  when "debian"
    case(node[:platform_version].to_i)
    when 7
      package_path = "debian/7/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "dfb4a05df16329ebe2b5fb109889f9c99881283413084985567ac08245b0d019"
    end
  when "ubuntu"
    case(node[:platform_version])
    when "14.04"
      package_path = "ubuntu/14.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "f1807a77ba6448b47d4ee86eba94ab135b4900a666f04552a334ff3c0a44a1d2"
    when "12.04"
      package_path = "ubuntu/12.04/api-umbrella-#{node[:api_umbrella][:version]}-1_amd64.deb"
      package_checksum = "2291abae0105c110637e7b7af3d83f45b8aa45d914125316c9fb35e2c0b64946"
    end
  end
end

if(package_path && package_checksum)
  default[:api_umbrella][:package_url] = "https://developer.nrel.gov/downloads/api-umbrella/#{package_path}"
  default[:api_umbrella][:package_checksum] = package_checksum
end

default[:api_umbrella][:config] = {}
