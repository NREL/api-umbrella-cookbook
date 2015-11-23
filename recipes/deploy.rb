# For building gems when deploying from master.
include_recipe "build-essential"

# Nokogiri updates require zlib-devel as well.
case(node["platform_family"])
when "rhel", "fedora", "suse"
  package "zlib-devel"
when "arch"
  package "zlib"
else
  package "zlib1g-dev"
end
