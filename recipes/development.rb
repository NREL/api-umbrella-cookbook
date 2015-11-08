include_recipe "api-umbrella::development_ulimit"
include_recipe "api-umbrella::test_dependencies"

# Since this is a dev box, keep our custom PATH when running sudo.
node.set[:authorization][:sudo][:include_sudoers_d] = true
node.set[:authorization][:sudo][:sudoers_defaults] = ["!env_reset", "!secure_path"]
include_recipe "sudo"

# If this vagrant box is running a local firewall, disable it to simplify
# development setup.
case(node[:platform_family])
when "rhel"
  %w(iptables ip6tables).each do |service_name|
    service(service_name) do
      action [:stop, :disable]
    end
  end
end

bin_paths = [
  # Put /vagrant/bin at the top of the PATH. This ensures that the local,
  # development version of the "api-umbrella" bin file will be loaded from here
  # first, so the api-umbrella service on the system loads the development copy
  # of the app.
  "/vagrant/bin",
  "/opt/api-umbrella/sbin",
  "/opt/api-umbrella/bin",
  "/opt/api-umbrella/embedded/sbin",
  "/opt/api-umbrella/embedded/bin",
]

# Setup the shell so that API Umbrella's embedded directories are all on the
# default PATH.
template "/etc/profile.d/api_umbrella_development.sh" do
  source "development_profile.sh.erb"
  mode "0644"
  owner "root"
  group "root"
  variables(:bin_paths => bin_paths)
end

include_recipe "build-essential"

yum_repository "wandisco-git" do
  description "WANdisco Distribution of git"
  baseurl "http://opensource.wandisco.com/rhel/6/git/$basearch"
  gpgkey "http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco"
  enabled true
end

# Additional packages needed for runtime or building.
# Based on the dependencies defined for the packaging process:
# https://github.com/NREL/api-umbrella/blob/master/build/package/build
packages = [
  "bash",
  "bzip2",
  "gcc",
  "gcc-c++",
  "git",
  "glibc",
  "java-1.8.0-openjdk",
  "libffi-devel",
  "libuuid-devel",
  "libxml2-devel",
  "libyaml-devel",
  "ncurses-devel",
  "openssl-devel",
  "patch",
  "pcre-devel",
  "tar",
  "tcl-devel",
  "unzip",
  "util-linux-ng",
  "which",
  "xz",
  "zlib-devel",
]

packages.each do |package_name|
  package(package_name) do
    action :install
  end
end

log "api_umbrella_make_warning" do
  message "\n\n\nCompiling API Umbrella from source - this may take a while"
  level :warn
end

# Install API Umbrella from source.
execute "api_umbrella_make" do
  command "make"
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  environment("HOME" => ::Dir.home("vagrant"))
end

execute "api_umbrella_make_install" do
  command "make install"
  cwd "/vagrant"
  user "root"
  group "root"
end

execute "api_umbrella_make_after_install" do
  command "make after_install"
  cwd "/vagrant"
  user "root"
  group "root"
end

execute "api_umbrella_make_test_dependencies" do
  command "make test_dependencies"
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  environment("HOME" => ::Dir.home("vagrant"))
end

# Setup API Umbrella in development mode.
node.set[:api_umbrella][:config][:app_env] = "development"
include_recipe "api-umbrella::config_file"

# Now start things up for the development environment.
service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
