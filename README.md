# api-umbrella-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['api-umbrella']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### api-umbrella::default

Include `api-umbrella` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[api-umbrella::default]"
  ]
}
```

```
curl -Ls https://www.getchef.com/chef/install.sh | bash -s -- -v 11.16.2
/opt/chef/embedded/bin/gem install berkshelf --no-ri --no-rdoc --version 3.1.5
mkdir /opt/chef/solo
git clone https://github.com/NREL-cookbooks/api-umbrella.git /opt/chef/solo/api-umbrella
cd /opt/chef/solo/api-umbrella
/opt/chef/embedded/bin/berks vendor /opt/chef/solo/cookbooks
chef-solo -c /etc/chef/solo.rb -j /etc/chef/solo.json
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
