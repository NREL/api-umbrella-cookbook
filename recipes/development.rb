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

# Setup the shell so that API Umbrella's embedded directories are all on the
# default PATH.
template "/etc/profile.d/api_umbrella_development.sh" do
  source "development_profile.sh.erb"
  mode "0644"
  owner "root"
  group "root"
  variables({
    :bin_paths => [
      # Put /vagrant/bin at the top of the PATH. This ensures that the local,
      # development version of the "api-umbrella" bin file will be loaded from
      # here first, so the api-umbrella service on the system loads the
      # development copy of the app.
      "/vagrant/bin",
      "/opt/api-umbrella/sbin",
      "/opt/api-umbrella/bin",
      "/opt/api-umbrella/embedded/sbin",
      "/opt/api-umbrella/embedded/bin",
    ],
  })
end

# Also make sure the init.d script picks up the local development copy first.
file "/etc/sysconfig/api-umbrella" do
  content "PATH=/vagrant/bin:$PATH"
  mode "0644"
  owner "root"
  group "root"
end

log "api_umbrella_make_warning" do
  message "\n\n\nCompiling API Umbrella from source - this may take a while\nYou may view #{Chef::Config[:file_cache_path]}/api-umbrella-build.log for progress"
  level :warn
end

bash "api_umbrella_install_build_dependencies" do
  code <<-eos
    echo "" > #{Chef::Config[:file_cache_path]}/api-umbrella-build.log
    chmod 777 #{Chef::Config[:file_cache_path]}/api-umbrella-build.log
    ./build/scripts/install_build_dependencies &>> #{Chef::Config[:file_cache_path]}/api-umbrella-build.log
  eos
  cwd "/vagrant"
  user "root"
  group "root"
end

bash "api_umbrella_configure" do
  code "./configure --enable-hadoop-analytics --enable-test-dependencies &>> #{Chef::Config[:file_cache_path]}/api-umbrella-build.log"
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  environment("HOME" => ::Dir.home("vagrant"))
end

bash "api_umbrella_make" do
  code "make &>> #{Chef::Config[:file_cache_path]}/api-umbrella-build.log"
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  environment("HOME" => ::Dir.home("vagrant"))
end

bash "api_umbrella_make_install" do
  code "make install &>> #{Chef::Config[:file_cache_path]}/api-umbrella-build.log"
  cwd "/vagrant"
  user "root"
  group "root"
end

bash "api_umbrella_make_after_install" do
  code "make after-install &>> #{Chef::Config[:file_cache_path]}/api-umbrella-build.log"
  cwd "/vagrant"
  user "root"
  group "root"
end

# Setup API Umbrella in development mode.
node.set[:api_umbrella][:config][:app_env] = "development"
include_recipe "api-umbrella::config_file"

# Now start things up for the development environment.
service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
