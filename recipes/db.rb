include_recipe 'api-umbrella'
include_recipe 'mongodb::10gen_repo'
include_recipe 'mongodb'
include_recipe 'iptables::mongodb'
