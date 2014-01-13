default[:nginx][:source][:modules] = ['nginx::passenger']
default[:nginx][:passenger][:version] = '4.0.23'

# Run all passengers processes as the nginx user.
default[:nginx][:passenger][:user_switching] = false
default[:nginx][:passenger][:default_user] = 'www-data-local'

# Disable friendly error pages by default.
default[:nginx][:passenger][:friendly_error_pages] = false

# Allow more application instances.
default[:nginx][:passenger][:max_pool_size] = 16

# Ensure this is less than :max_pool_size, so there's always room for all
# other apps, even if one app is popular.
default[:nginx][:passenger][:max_instances_per_app] = 6

# Keep at least one instance running for all apps.
default[:nginx][:passenger][:min_instances] = 1

# Increase an instance idle time to 15 minutes.
default[:nginx][:passenger][:pool_idle_time] = 900

# Keep the spanwers alive indefinitely, so new app processes can spin up
# quickly.
default[:nginx][:passenger][:max_preloader_idle_time] = 0
