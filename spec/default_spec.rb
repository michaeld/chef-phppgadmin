require 'spec_helper'

describe 'chef-phppgadmin::default' do
  platforms = {
    'ubuntu' => [ '12.04' ],
    'centos' => [ '6.4' ]
  }

  platforms.each do | platform, versions |
    versions.each do | version |
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(platform: platform, version: version) do |node|
          
            env = Chef::Environment.new
            env.name 'development'
            node.stub(:chef_environment).and_return(env.name)
            Chef::Environment.stub(:load).and_return(env)
            
            # These are needed for the php cookbook to work
            node.set['memory']['total'] = 17179869184
            node.set['memory']['swap']['total'] = 17179869184
                  
            node.name "chef-repo-aws-db-precise64-1"
            
          end.converge(described_recipe)
          
        end
  
        it 'includes recipe php::default' do
          expect(chef_run).to include_recipe('php::default')
        end
  
        it 'includes recipe php::module_mbstring' do
          expect(chef_run).to include_recipe('php::module_mbstring')
        end
  
        it 'includes recipe php::module_mcrypt' do
          expect(chef_run).to include_recipe('php::module_mcrypt')
        end
  
        it 'includes recipe php::module_gd' do
          expect(chef_run).to include_recipe('php::module_gd')
        end
  
        it 'includes recipe php::module_pgsql' do
          expect(chef_run).to include_recipe('php::module_pgsql')
        end

        it 'creates a group with the name phppgadmin' do
          expect(chef_run).to create_group('phppgadmin')
        end
  
        it 'creates a user with the name phppgadmin and with the right attributes' do
          expect(chef_run).to create_user('phppgadmin').with(
            comment:  'PHPPgAdmin User',
            gid:      'phppgadmin',
            home:     '/opt/phppgadmin',
            shell:    '/usr/sbin/nologin'
          )
        end
       
        it 'creates a directory /opt/phppgadmin with the correct attributes' do
          expect(chef_run).to create_directory('/opt/phppgadmin').with(
            owner:      'phppgadmin',
            group:      'phppgadmin',
            recursive:  true,
            mode:       00755
          )
        end
     
        it 'downloads phpPgAdmin-5.1.tar.gz using remote_file with the ' \
          'correct attributes' do
          expect(chef_run).to create_remote_file_if_missing(
            '/var/chef/cache/phpPgAdmin-5.1/phpPgAdmin-5.1.tar.gz'
          ).with(
            owner:    'phppgadmin',
            group:    'phppgadmin',
            mode:     00644,
            source:   'http://sourceforge.net/projects/' \
              'phppgadmin/files/phpPgAdmin%20%5Bstable%5D/phpPgAdmin-5.1/' \
              'phpPgAdmin-5.1.tar.gz',
            checksum: '42294e7b19d3b4003912eaad9a34df4096c038' \
              '0871aedce152aa13d4955878a5'
          )
        end

        it 'runs a bash script to extract the package with the correct ' \
          'attributes' do
          expect(chef_run).to run_bash('extract-phppgadmin').with(
            user:     'phppgadmin',
            group:    'phppgadmin',
          	cwd:      '/opt/phppgadmin'
          )
        end
     
        it 'creates a directory /opt/phppgadmin/conf.d with the correct ' \
          'attributes' do
          expect(chef_run).to create_directory('/opt/phppgadmin/conf.d').with(
            owner:      'phppgadmin',
            group:      'phppgadmin',
            recursive:  true,
            mode:       00755
          )
        end
       
        it 'creates the file /opt/phppgadmin/config.inc.php from the ' \
          'template config.inc.php.erb with the right attributes' do
          expect(chef_run).to create_template(
            '/opt/phppgadmin/config.inc.php'
          ).with(
            source: 'config.inc.php.erb',
            owner:  'phppgadmin',
            group:  'phppgadmin',
            mode:   00644
            )
        end
     
        case platform
        when 'ubuntu'
          
          it 'creates a directory /var/lib/php5/uploads' do
            expect(chef_run).to create_directory('/var/lib/php5/uploads').with(
              owner:      'root',
              group:      'root',
              recursive:  true,
              mode:       01777
            )
          end
     
        when 'centos'

          it 'creates a directory /var/lib/php/uploads' do
            expect(chef_run).to create_directory('/var/lib/php/uploads').with(
              owner:      'root',
              group:      'root',
              recursive:  true,
              mode:       01777
            )
          end
     
        else
          
          raise "Platform has unexpected value: #{platform}."
        
        end
      end
    end
  end
end







