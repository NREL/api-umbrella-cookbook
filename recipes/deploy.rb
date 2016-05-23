# For building gems when deploying from master.
include_recipe "build-essential"

# Nokogiri updates require zlib-devel as well.
case(node["platform_family"])
when "rhel", "fedora", "suse"
  package "zlib-devel"
else
  package "zlib1g-dev"
end

# For installing our lua dependencies when deploying.
package "cmake"

# For building lyaml.
case(node["platform_family"])
when "rhel", "fedora", "suse"
  package "libyaml-devel"
else
  package "libyaml-dev"
end
