# For python-virtualenv.
include_recipe "yum-epel"

packages = [
  "expat-devel",
  "libcurl-devel",

  # For installing the mongo-orchestration test dependency.
  "python-virtualenv",

  # For checking for file descriptor leaks during the tests.
  "lsof",
]

packages.each do |package_name|
  package(package_name) do
    action :install
  end
end
