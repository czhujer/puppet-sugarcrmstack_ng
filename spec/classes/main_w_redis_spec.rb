require 'spec_helper'

describe 'sugarcrmstack_ng' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        #fixes for composer and mysql (root_home)
        let(:facts) { facts.merge( { 'composer_home' => '~', 'execs' => {}, 'root_home' => '/root' } ) }

        context "sugarcrmstack_ng class with redis_server_enable" do
          # switch param
          let(:params) { {'redis_server_enable' => true} }

          # check compile
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sugarcrmstack_ng') }
          it { is_expected.to contain_class('sugarcrmstack_ng::params') }
          it { is_expected.to contain_class('sugarcrmstack_ng::install') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::install').that_comes_before('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::config') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::service') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::service').that_subscribes_to('sugarcrmstack_ng::config') }

          it { should contain_class('sugarcrmstack_ng::apache_php') }

          it { should_not contain_class('sugarcrmstack_ng::elasticsearch_server') }
          it { should_not contain_class('sugarcrmstack_ng::mysql_server') }

          it { should_not contain_class('sugarcrmstack_ng::memcached_server') }
          it { should contain_class('sugarcrmstack_ng::redis_server') }

          # generic part
          ['apachetop', 'bind-utils', 'htop', 'iftop',
           'iotop', 'iptraf', 'irqbalance', 'links', 'lsof', 'lsscsi', 'lynx',
           'nano', 'numad', 'policycoreutils-python', 'sysstat', 'telnet', 'traceroute',
           'unzip', 'vim-enhanced', 'vim-minimal', 'wget', 'yum-cron', 'yum-utils', 'zip',
           ].each do |x| it {
             is_expected.to contain_package(x)
               .with(ensure: "installed")
             }
          end

          # only CentOS 6 packages
          case facts[:osfamily]
          when 'RedHat'
            case facts[:operatingsystemmajrelease]
              when '6'
                it { should contain_package("hal").with(ensure: "installed") }
                it { should contain_package("cpuspeed").with(ensure: "installed") }
              else
                it { should_not contain_package("hal").with(ensure: "installed") }
                it { should_not contain_package("cpuspeed").with(ensure: "installed") }
              end
          end

          # NOT EXISTS apache+php part
          it { should contain_class("apache::params") }
          it { should contain_package("httpd") }

          # NOT EXISTS mysql_server part
          it { should_not contain_class('mysql::server::install') }
          it { should_not contain_class('mysql::server::config') }
          it { should_not contain_class('mysql::server::service') }
          it { should_not contain_class('mysql::server::root_password') }
          it { should_not contain_class('mysql::server::providers') }

          it { should_not contain_package('mysql-server').with(ensure: "installed") }

          it { should_not contain_service('mysqld') }

          # NOT EXISTS elasticsearch_server part
          it { should_not contain_class('java') }
          it { should_not contain_class('elasticsearch::config') }
          it { should_not contain_class('elasticsearch::repo') }
          it { should_not contain_class('elasticsearch') }
          it { should_not contain_class('elasticsearch::package') }
          it { should_not contain_class('elasticsearch::config').that_requires('Class[elasticsearch::package]') }

          # Base directories
          it { should_not contain_file('/etc/elasticsearch') }
          it { should_not contain_file('/usr/share/elasticsearch') }

          # Base package
          it { should_not contain_package('elasticsearch') }

          # NOT EXISTS memcached_server part
          it { is_expected.not_to contain_class('memcached') }
          it { is_expected.not_to contain_class('memcached::params') }
          it { is_expected.not_to contain_package('memcached').with_ensure('present') }

          it { is_expected.not_to contain_firewall('100_tcp_11211_for_memcached') }
          it { is_expected.not_to contain_firewall('100_udp_11211_for_memcached') }

          # redis_server part
          it { is_expected.to create_class('redis') }
          it { is_expected.to contain_class('redis::preinstall') }
          it { is_expected.to contain_class('redis::install') }
          it { is_expected.to contain_class('redis::config') }
          it { is_expected.to contain_class('redis::service') }

          it { is_expected.to contain_package('redis') }

          it { is_expected.to contain_file('/etc/redis.conf.puppet').with_ensure('file') }

          it { is_expected.to contain_file('/etc/redis.conf.puppet').without_content(/undef/) }

          it do
            is_expected.to contain_service('redis').with(
              'ensure'     => 'running',
              'enable'     => 'true',
              'hasrestart' => 'true',
              'hasstatus'  => 'true'
            )
          end

        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'sugarcrmstack_ng class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('sugarcrmstack_ng') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
