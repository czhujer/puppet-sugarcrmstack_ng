require 'spec_helper'

describe 'sugarcrmstack_ng' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        #fixes for composer
        let(:facts) { facts.merge( { 'composer_home' => '~', 'execs' => {} } ) }

        context "sugarcrmstack_ng class with mysql_server_enable" do
          # switch param
          let(:params) { {'mysql_server_enable' => true} }

          # check compile
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sugarcrmstack_ng') }
          it { is_expected.to contain_class('sugarcrmstack_ng::params') }
          it { is_expected.to contain_class('sugarcrmstack_ng::install') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::install').that_comes_before('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::service') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::service').that_subscribes_to('sugarcrmstack_ng::config') }

          it { should contain_class('sugarcrmstack_ng::apache_php') }
          it { should contain_class('sugarcrmstack_ng::mysql_server') }

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

          # apache+php part
          it { should contain_class("apache::params") }
          it { should contain_package("httpd") }

          # mysql_server part
          it { is_expected.to contain_class('mysql::server::install') }
          it { is_expected.to contain_class('mysql::server::config') }
          it { is_expected.to contain_class('mysql::server::service') }
          it { is_expected.to contain_class('mysql::server::root_password') }
          it { is_expected.to contain_class('mysql::server::providers') }

          it { is_expected.to contain_package('mysql-server').with(ensure: :present) }

          it { is_expected.to contain_service('mysqld') }

        end

        context "sugarcrmstack_ng class with mysql_server_enable and _use_pxc => true" do
          # switch param
          let(:params) { {'mysql_server_enable' => true,
                          'mysql_server_use_pxc' => true} }

          # check compile
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sugarcrmstack_ng') }
          it { is_expected.to contain_class('sugarcrmstack_ng::params') }
          it { is_expected.to contain_class('sugarcrmstack_ng::install') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::install').that_comes_before('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::service') }
#          it { is_expected.to contain_class('sugarcrmstack_ng::service').that_subscribes_to('sugarcrmstack_ng::config') }

          it { should contain_class('sugarcrmstack_ng::apache_php') }
          it { should contain_class('sugarcrmstack_ng::mysql_server') }

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

          # apache+php part
          it { should contain_class("apache::params") }
          it { should contain_package("httpd") }

          # mysql_server part
          it { is_expected.to contain_class('mysql::server::install') }
          it { is_expected.to contain_class('mysql::server::config') }
          it { is_expected.to contain_class('mysql::server::service') }
          it { is_expected.to contain_class('mysql::server::root_password') }
          it { is_expected.to contain_class('mysql::server::providers') }

          it { is_expected.to contain_package('mysql-server').with(ensure: :present) }

          it { is_expected.to contain_service('mysqld') }

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
