#
# Cookbook Name:: api-umbrella
# Recipe:: legacy_db_upgrade
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

execute "rsync -av /var/lib/mongodb/ /opt/api-umbrella/var/db/mongodb/"
execute "rsync -av /usr/local/var/data/elasticsearch/elasticsearch/ /opt/api-umbrella/var/db/elasticsearch/api-umbrella/"

ruby_block "shutdown_elasticsearch_if_running" do
  block do
    require "socket"

    begin
      TCPSocket.new("localhost", 9200)

      system <<-eos
        curl -s -XPUT localhost:9200/_cluster/settings -d '{
          "persistent" : {
            "cluster.routing.allocation.disable_allocation" : true
          }
        }'
      eos

      system "curl -s -XPOST 'http://localhost:9200/_shutdown'"

      puts "\nWaiting for elasticsearch to shutdown..."
      while true
        begin
          TCPSocket.new("localhost", 9200)
        rescue Errno::ECONNREFUSED
          break
        end
        print "."
        sleep 5
      end
    rescue Errno::ECONNREFUSED
      puts "\nElasticsearch not running... skipping shutdown"
    end
  end
end

service "mongod" do
  action [:stop, :disable]
end

service "elasticsearch" do
  action [:stop, :disable]
end

execute "rsync -av --delete-after /var/lib/mongodb/ /opt/api-umbrella/var/db/mongodb/"
execute "chown -R api-umbrella:api-umbrella /opt/api-umbrella/var/db/mongodb"

execute "rsync -av --delete-after /usr/local/var/data/elasticsearch/elasticsearch/ /opt/api-umbrella/var/db/elasticsearch/api-umbrella/"
execute "chown -R api-umbrella:api-umbrella /opt/api-umbrella/var/db/elasticsearch"

service "api-umbrella" do
  action [:enable, :start]
end

ruby_block "wait_for_elasticsearch" do
  block do
    require "json"

    puts "\nWaiting for elasticsearch..."
    while true
      body = `curl -s 'http://localhost:9200/_cluster/health'`.strip
      unless(body.empty?)
        data = JSON.parse(body)
        if(%w(yellow green).include?(data["status"]))
          break
        end
      end
      print "."
      sleep 5
    end
  end
end

execute <<-eos
  curl -s -XPUT http://localhost:9200/_cluster/settings -d '{
    "persistent" : {
      "cluster.routing.allocation.disable_allocation": false,
      "cluster.routing.allocation.enable" : "all"
    }
  }'
eos
