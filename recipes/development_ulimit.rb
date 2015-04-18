include_recipe "ulimit"

# API Umbrella will raise its own ulimits when running, but during development,
# it's useful to raise the default limits too, so that when running API
# Umbrella as the development user, the development user can also do things in
# other shells (in case API Umbrella bumps into the normal limits in place on
# the system).
ulimit_domain "api-umbrella" do
  domain_name "*"
  rule do
    item :nofile
    type :hard
    value 100000
  end
  rule do
    item :nofile
    type :soft
    value 100000
  end
  rule do
    item :nproc
    type :hard
    value 20000
  end
  rule do
    item :nproc
    type :soft
    value 20000
  end
end


