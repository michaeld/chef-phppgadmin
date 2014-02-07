#
# Cookbook Name:: phppgadmin
# Attributes:: default
#
# Copyright 2014, Tom Ligda
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['phppgadmin']['version'] = '5.1'
default['phppgadmin']['checksum'] = '42294e7b19d3b4003912eaad9a34df4096c038' \
  '0871aedce152aa13d4955878a5'
default['phppgadmin']['mirror'] = 'http://sourceforge.net/projects/' \
  'phppgadmin/files/phpPgAdmin%20%5Bstable%5D'

default['phppgadmin']['fpm'] = true

default['phppgadmin']['home'] = '/opt/phppgadmin'
default['phppgadmin']['user'] = 'phppgadmin'
default['phppgadmin']['group'] = 'phppgadmin'
default['phppgadmin']['socket'] = '/tmp/phppgadmin.sock'

if Chef::Config[:solo]
  default['phppgadmin']['blowfish_secret'] = '7654588cf9f0f92f01a6aa361d02c0cf038'
end

case node['platform_family']
when 'debian'
  default['phppgadmin']['upload_dir'] = '/var/lib/php5/uploads'
  default['phppgadmin']['save_dir'] = '/var/lib/php5/uploads'
when 'rhel'
  default['phppgadmin']['upload_dir'] = '/var/lib/php/uploads'
  default['phppgadmin']['save_dir'] = '/var/lib/php/uploads'
end
default['phppgadmin']['maxrows'] = 100
default['phppgadmin']['protect_binary'] = 'blob'
default['phppgadmin']['default_lang'] = 'en'
default['phppgadmin']['default_display'] = 'horizontal'
default['phppgadmin']['query_history'] = true
default['phppgadmin']['query_history_size'] = 100
