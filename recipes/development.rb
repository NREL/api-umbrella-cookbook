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
      "/vagrant/build/work/dev-env/sbin",
      "/vagrant/build/work/dev-env/bin",
      "/vagrant/build/work/test-env/sbin",
      "/vagrant/build/work/test-env/bin",
      "/vagrant/build/work/stage/opt/api-umbrella/sbin",
      "/vagrant/build/work/stage/opt/api-umbrella/bin",
      "/vagrant/build/work/stage/opt/api-umbrella/embedded/sbin",
      "/vagrant/build/work/stage/opt/api-umbrella/embedded/bin",
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

# Symlink the build directories off of the NFS mount and onto guest OS
# partition for better build performance. This also ensures that when the
# vagrant box is destroyed/recreated, the build will always be fresh.
[
  "CMakeFiles",
  "build/work",
  "test/tmp/root",
].each do |path|
  directory "/opt/api-umbrella-build/#{path}" do
    recursive true
    owner "vagrant"
    group "vagrant"
    mode "0755"
  end

  directory "/vagrant/#{path}" do
    action :delete
    recursive true
    only_if { File.directory?("/vagrant/#{path}") && !File.symlink?("/vagrant/#{path}") }
  end

  link "/vagrant/#{path}" do
    to "/opt/api-umbrella-build/#{path}"
  end
end

log "api_umbrella_make_warning" do
  message "\n\n\nCompiling API Umbrella from source - this may take a while\nYou may view #{Chef::Config[:file_cache_path]}/api-umbrella-build.log for progress"
  level :warn
end

bash "api_umbrella_install_build_dependencies" do
  code <<-eos
    echo "" > #{Chef::Config[:file_cache_path]}/api-umbrella-build.log
    chmod 777 #{Chef::Config[:file_cache_path]}/api-umbrella-build.log
    ./build/scripts/install_build_dependencies 2>&1 | tee -a #{Chef::Config[:file_cache_path]}/api-umbrella-build.log; (exit ${PIPESTATUS[0]})
  eos
  cwd "/vagrant"
  user "root"
  group "root"
end

bash "api_umbrella_configure" do
  code "./configure --enable-test-dependencies 2>&1 | tee -a #{Chef::Config[:file_cache_path]}/api-umbrella-build.log; (exit ${PIPESTATUS[0]})"
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  environment({
    "HOME" => ::Dir.home("vagrant"),
    "USER" => "vagrant",
  })
end

bash "api_umbrella_make" do
  code "make 2>&1 | tee -a #{Chef::Config[:file_cache_path]}/api-umbrella-build.log; (exit ${PIPESTATUS[0]})"
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  environment({
    "HOME" => ::Dir.home("vagrant"),
    "USER" => "vagrant",
  })
  # Extend timeout, since initial make can take a long time.
  timeout 7200
end

bash "api_umbrella_make_install" do
  code "make install 2>&1 | tee -a #{Chef::Config[:file_cache_path]}/api-umbrella-build.log; (exit ${PIPESTATUS[0]})"
  cwd "/vagrant"
  user "root"
  group "root"
end

bash "api_umbrella_make_after_install" do
  code "make after-install 2>&1 | tee -a #{Chef::Config[:file_cache_path]}/api-umbrella-build.log; (exit ${PIPESTATUS[0]})"
  cwd "/vagrant"
  user "root"
  group "root"
end

# Setup API Umbrella in development mode.
node.set[:api_umbrella][:config][:app_env] = "development"
node.set[:api_umbrella][:config][:user] = "vagrant"
node.set[:api_umbrella][:config][:group] = "vagrant"
include_recipe "api-umbrella::config_file"

# Now start things up for the development environment.
service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
