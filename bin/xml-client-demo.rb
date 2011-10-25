#!/usr/bin/env ruby

require 'rubygems'
require 'xmlrpc/client'
require 'ap'    # awesome_print

# Please correctly fill following vars
@host = 'localhost'
@port = 3000
@user = 'user@email'
@password = ''

puts 'PLATFORMS'
client = XMLRPC::Client.new(@host, '/api/xmlrpc', @port, nil, nil, @user, @password, false, 900)
ap client.call("platforms")

puts 'USER PROJECTS'
client = XMLRPC::Client.new(@host, '/api/xmlrpc', @port, nil, nil, @user, @password, false, 900)
ap client.call("user_projects")

puts 'PROJECT VERSIONS'
client = XMLRPC::Client.new(@host, '/api/xmlrpc', @port, nil, nil, @user, @password, false, 900)
project_id = 1    # FIXME!
ap client.call("project_versions", project_id)

puts 'BUILD STATUS'
client = XMLRPC::Client.new(@host, '/api/xmlrpc', @port, nil, nil, @user, @password, false, 900)
build_list_id = 1 # FIXME
ap client.call("build_status", build_list_id)

puts 'BUILD PACKET'
client = XMLRPC::Client.new(@host, '/api/xmlrpc', @port, nil, nil, @user, @password, false, 900)
project_id = 1    # FIXME
repo_id = 1       # FIXME
ap client.call("build_packet", project_id, repo_id)

puts 'DONE'