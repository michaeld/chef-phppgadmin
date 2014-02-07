name              'chef-phppgadmin'
maintainer        'Tom Ligda'
maintainer_email  'tligda@ncomputing.com'
license           'Apache Public License 2.0'
description       'Installs/Configures PHPPgAdmin'
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md')).chomp
version            IO.read(File.join(File.dirname(__FILE__), 'VERSION')).chomp rescue '0.1.0'

depends           'php'

recommends        'nginx'
recommends        'apache2'
  
suggests          'percona'
suggests          'postgresql'

supports          'ubuntu', '>= 12.04'
supports          'debian', '>= 6.0'
supports          'centos', '>= 6.0'
supports          'redhat', '>= 9.0'

attribute 'phppgadmin/version',
  :display_name => 'PHPPgAdmin version',
  :description => 'The desired PPA version'

attribute 'phppgadmin/checksum',
  :display_name => 'PHPPgAdmin archive checksum',
  :description => 'The sha256 checksum of the PPA desired version'

attribute 'phppgadmin/mirror',
  :display_name => 'PHPPgAdmin download mirror',
  :description => 'The desired PPA download mirror',
  :default => 'http://netcologne.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin'

attribute 'phppgadmin/fpm',
  :display_name => 'PHPPgAdmin FPM instance',
  :description => 'Enables the PPA FPM instance for serving via NGINX',
  :default => 'true'

attribute 'phppgadmin/home',
  :display_name => 'PHPPgAdmin home',
  :description => 'The desired PPA installation home',
  :default => '/opt/phpmyadmin'

attribute 'phppgadmin/user',
  :display_name => 'PHPPgAdmin user',
  :description => 'The user PPA runs as',
  :default => 'phpmyadmin'

attribute 'phppgadmin/group',
  :display_name => 'PHPPgAdmin group',
  :description => 'The group PPA runs as',
  :default => 'phpmyadmin'

attribute 'phppgadmin/blowfish_secret',
  :display_name => 'PHPPgAdmin blowfish secret',
  :description => 'The encryption key for PHPPgAdmin',
  :default => '7654588cf9f0f92f01a6aa361d02c0cf038'

attribute 'phppgadmin/socket',
  :display_name => 'PHPPgAdmin FPM socket',
  :description => 'The socket that FPM will be exposing for PPA',
  :default => '/tmp/phppgadmin.sock'

attribute 'phppgadmin/upload_dir',
  :display_name => 'PHPPgAdmin upload directory',
  :description => 'The directory PPA will be using for uploads',
  :calculated => true

attribute 'phppgadmin/save_dir',
  :display_name => 'PHPPgAdmin save directory',
  :description => 'The directory PPA will be using for file saves',
  :calculated => true

attribute 'phppgadmin/maxrows',
  :display_name => 'PHPPgAdmin maximum rows',
  :description => 'The maximum rows PPA shall display in a table view',
  :default => '100'

attribute 'phppgadmin/protect_binary',
  :display_name => 'PHPPgAdmin binary field protection',
  :description => 'Define the binary field protection PPA will be using',
  :default => 'blob'

attribute 'phppgadmin/default_lang',
  :display_name => 'PHPPgAdmin default language',
  :description => 'The default language PPA will be using',
  :default => 'en'

attribute 'phppgadmin/default_display',
  :display_name => 'PHPPgAdmin default row display',
  :description => 'The default display of rows inside PPA',
  :default => 'horizontal'

attribute 'phppgadmin/query_history',
  :display_name => 'PHPPgAdmin query history',
  :description => 'Enable or disable the Javascript query history',
  :default => 'true'

attribute 'phppgadmin/query_history_size',
  :display_name => 'PHPPgAdmin query history size',
  :description => 'Set the maximum size of the Javascript query history',
  :default => '100'
