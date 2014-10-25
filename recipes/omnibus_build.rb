#
# Cookbook Name:: api-umbrella
# Recipe:: omnibus_build
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "omnibus"

# Output to a temp log file, in addition to the screen. Since the build takes
# a long time, this allows us to login to the machine to view progress, while
# also ensuring the output is captured by Chef in case things error.
build_log_file = ".kitchen/logs/#{node[:hostname]}-api-umbrella-build.log"
node.run_state[:api_umbrella_log_redirect] = "2>&1 | tee -a #{build_log_file}; test ${PIPESTATUS[0]} -eq 0"

# Workaround for the fact that chef's bash resource doesn't have an easy way to
# run a command as a non-root user, taking into account that user's login stuff
# (without this, the omnibus bash environment variables don't get setup
# properly, so omnibus's ruby version doesn't get picked up).
# See: https://tickets.opscode.com/browse/CHEF-2288
def command_as_build_user(command)
  "su -l -c 'cd #{node[:omnibus][:build_dir]} && env #{command} #{node.run_state[:api_umbrella_log_redirect]}' #{node[:omnibus][:build_user]}"
end

# Places the built packages in a directory based on the platform and version.
# This prevents builds from different OS versions from colliding and
# overwriting each other.
package_dir = File.join(node[:omnibus][:build_dir], "pkg/#{node[:platform]}-#{node[:platform_version]}")

build_script = <<-EOH
  set -e
  rm -rf #{package_dir} /var/cache/omnibus/pkg/*
  mkdir -p #{package_dir}
  #{command_as_build_user("env")}
  #{command_as_build_user("bundle install")}
  #{command_as_build_user("bin/omnibus build api-umbrella -l info --override package_dir:#{package_dir}")}

  # There's a hard-coded "package_me" step in omnibus that copies the built
  # packages to the root pkg/ directory. We don't need theese, since we want
  # them in the OS-specific directories.
  #{command_as_build_user("rm -f pkg/*.deb pkg/*.rpm pkg/*.json")}
EOH

bash "build api-umbrella" do
  cwd node[:omnibus][:build_dir]
  code build_script
  only_if do
    Chef::Log.info("\n\n\nBuilding api-umbrella, this could take a while...\n(tail #{build_log_file} to view progress)\n")
    true
  end
end
