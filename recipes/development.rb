#
# Cookbook Name:: api-umbrella
# Recipe:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

# Setup API Umbrella in development mode pointing to local checkouts.
node.set[:api_umbrella][:config][:app_env] = "development"
node.set[:api_umbrella][:config][:router][:dir] = "/vagrant/workspace/router"
node.set[:api_umbrella][:config][:static_site][:dir] = "/vagrant/workspace/static-site"
node.set[:api_umbrella][:config][:web][:dir] = "/vagrant/workspace/web"

# Install compilers for building C gems and npm modules.
include_recipe "build-essential"

# Install libcurl as an npm test dependencies.
include_recipe "curl::libcurl"

# Install git to checkout code.
include_recipe "git"

# Install phantomjs for running web tests.
node.set[:phantomjs][:version] = "1.9.8"
node.set[:phantomjs][:base_url] = "https://bitbucket.org/ariya/phantomjs/downloads"
node.set[:phantomjs][:basename] = "phantomjs-#{node[:phantomjs][:version]}-linux-#{node[:kernel][:machine]}"
include_recipe "phantomjs::source"

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

# Checkout local copies of the projects to /vagrant/workspace for development
# work.
%w(gatekeeper router static-site web).each do |project|
  # Use a straight git clone command, rather than Chef's git resource, so that
  # the checkout is sitting on master, rather than a detached "deploy" branch.
  url = "https://github.com/NREL/api-umbrella-#{project}.git"
  dir = "/vagrant/workspace/#{project}"
  execute "git clone #{url} #{dir}" do
    user "vagrant"
    group "vagrant"
    not_if { ::Dir.exists?(dir) }
  end
end

bin_paths = [
  "/vagrant/workspace/router/bin",
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

# Now install API Umbrella's package.
include_recipe "api-umbrella::default"

# Change permissions from the default package installer so the vagrant user
# owns things.
bash "api_umbrella_permissions" do
  code <<-EOS
    mkdir -p /opt/api-umbrella/embedded/apps/gatekeeper/shared/node_modules
    chown -R vagrant:vagrant /opt/api-umbrella/embedded/apps/gatekeeper/shared/node_modules
    chown -R vagrant:vagrant /opt/api-umbrella/embedded/apps/web/shared/bundle
    chown -R vagrant:vagrant /opt/api-umbrella/embedded/apps/static-site/shared/bundle
    chown -R vagrant:vagrant /opt/api-umbrella/embedded/apps/router/shared/node_modules
  EOS
end

env = {
  # Ensure that the "bundle" and "npm" commands find our API Umbrella embedded
  # bins even on the first Chef run, when the profile.d script might not be in
  # effect yet.
  "PATH" => "#{bin_paths.join(":")}:#{ENV["PATH"]}",

  # npm needs its HOME set in order to install things:
  # http://stackoverflow.com/a/25282701
  "HOME" => "/home/vagrant",
}

# Run through all the development project checkouts and ensure that all
# development/test dependencies get installed.
bash "api_umbrella_web_install" do
  code <<-EOS
    cd /vagrant/workspace/web
    rm -f ./vendor/bundle
    ln -sf /opt/api-umbrella/embedded/apps/web/shared/bundle ./vendor/bundle
    bundle install --path=vendor/bundle
  EOS
  environment(env)
  user "vagrant"
  group "vagrant"
end

bash "api_umbrella_static_site_install" do
  code <<-EOS
    cd /vagrant/workspace/static-site
    rm -f ./vendor/bundle
    ln -sf /opt/api-umbrella/embedded/apps/static-site/shared/bundle ./vendor/bundle
    bundle install --path=vendor/bundle
  EOS
  environment(env)
  user "vagrant"
  group "vagrant"
end

bash "api_umbrella_gatekeeper_install" do
  code <<-EOS
    cd /vagrant/workspace/gatekeeper
    rm -f ./node_modules
    ln -sf /opt/api-umbrella/embedded/apps/gatekeeper/shared/node_modules ./node_modules
    npm install
    sudo npm link
  EOS
  environment(env)
  user "vagrant"
  group "vagrant"
end

bash "api_umbrella_router_install" do
  code <<-EOS
    cd /vagrant/workspace/router
    rm -f ./node_modules
    ln -sf /opt/api-umbrella/embedded/apps/router/shared/node_modules ./node_modules
    npm link api-umbrella-gatekeeper
    npm install
  EOS
  environment(env)
  user "vagrant"
  group "vagrant"
end

# Now start things up for the development environment.
service "api-umbrella" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
