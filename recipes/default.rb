#
# Cookbook Name:: phppgadmin
# Recipe:: default
#
# Copyright 2014, Tom Ligda
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'digest/sha1'

# PHP Recipe includes we already know PHPPgAdmin needs
include_recipe 'php'
include_recipe 'php::module_mbstring'
include_recipe 'php::module_mcrypt'
include_recipe 'php::module_gd'
# include_recipe 'php::module_mysql'
include_recipe 'php::module_pgsql'

home = node['phppgadmin']['home']
user = node['phppgadmin']['user']
group = node['phppgadmin']['group']
conf = "#{home}/config.inc.php"

group group do
	action [ :create, :manage ]
end

user user do
	action [ :create, :manage ]
	comment 'PHPPgAdmin User'
	gid group
	home home
	shell '/usr/sbin/nologin'
	supports :manage_home => true 
end

directory home do
	owner user
	group group
	mode 00755
	recursive true
	action :create
end

directory node['phppgadmin']['upload_dir'] do
	owner 'root'
	group 'root'
	mode 01777
	recursive true
	action :create
end

directory node['phppgadmin']['save_dir'] do
	owner 'root'
	group 'root'
	mode 01777
	recursive true
	action :create
end

# Download the selected PHPPgAdmin archive
remote_file "#{Chef::Config['file_cache_path']}/phpPgAdmin-" \
  "#{node['phppgadmin']['version']}.tar.gz" do
  owner user
  group group
  mode 00644
  action :create_if_missing
  source "#{node['phppgadmin']['mirror']}/phpPgAdmin-" \
    "#{node['phppgadmin']['version']}/phpPgAdmin-" \
    "#{node['phppgadmin']['version']}.tar.gz"
  checksum node['phppgadmin']['checksum']
end

bash 'extract-phppgadmin' do
	user user
	group group
	cwd home
	code <<-EOH
		rm -fr *
		tar xzf #{Chef::Config['file_cache_path']}/phpPgAdmin-#{node['phppgadmin']['version']}.tar.gz
		mv phpPgAdmin-#{node['phppgadmin']['version']} #{home}/
	EOH
	not_if { ::File.exists?("#{home}/phpPgAdmin-#{node['phppgadmin']['version']}")}
end

directory "#{home}/conf.d" do
	owner user
	group group
	mode 00755
	recursive true
	action :create
end

# Blowfish Secret - set it statically when running on Chef Solo via attribute
unless Chef::Config[:solo] || node['phppgadmin']['blowfish_secret']
  node.set['phppgadmin']['blowfish_secret'] = Digest::SHA1.hexdigest(IO.read('/dev/urandom', 2048))
  node.save
end

template "#{home}/config.inc.php" do
	source 'config.inc.php.erb'
	owner user
	group group
	mode 00644
end

if (node['phppgadmin'].attribute?('fpm') && node['phppgadmin']['fpm'])
 	php_fpm 'phppgadmin' do
	  action :add
	  user user
	  group group
	  socket true
	  socket_path node['phppgadmin']['socket']
	  socket_user user
	  socket_group group
	  socket_perms '0666'
	  start_servers 2
	  min_spare_servers 2
	  max_spare_servers 8
	  max_children 8
	  terminate_timeout (node['php']['ini_settings']['max_execution_time'].to_i + 20)
	  value_overrides({ 
	    :error_log => "#{node['php']['fpm_log_dir']}/phppgadmin.log"
	  })
	end
end
