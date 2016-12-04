require 'spec_helper'

describe 'sugarcrmstack_ng' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sugarcrmstack_ng class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('sugarcrmstack_ng::params') }
          it { is_expected.to contain_class('sugarcrmstack_ng::install').that_comes_before('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::config') }
          it { is_expected.to contain_class('sugarcrmstack_ng::service').that_subscribes_to('sugarcrmstack_ng::config') }

          #it { is_expected.to contain_service('sugarcrmstack_ng') }
          it { is_expected.to contain_package('apachetop').with_ensure('installed') }
          it { is_expected.to contain_package('bind-utils').with_ensure('installed') }
          it { is_expected.to contain_package('cpuspeed').with_ensure('installed') }
          it { is_expected.to contain_package('hal').with_ensure('installed') }
          it { is_expected.to contain_package('htop').with_ensure('installed') }
          it { is_expected.to contain_package('iftop').with_ensure('installed') }
          it { is_expected.to contain_package('iotop').with_ensure('installed') }
          it { is_expected.to contain_package('iptraf').with_ensure('installed') }
          it { is_expected.to contain_package('irqbalance').with_ensure('installed') }
          it { is_expected.to contain_package('links').with_ensure('installed') }
          it { is_expected.to contain_package('lsof').with_ensure('installed') }
          it { is_expected.to contain_package('lsscsi').with_ensure('installed') }
          it { is_expected.to contain_package('lynx').with_ensure('installed') }
          it { is_expected.to contain_package('nano').with_ensure('installed') }
          it { is_expected.to contain_package('numad').with_ensure('installed') }
          it { is_expected.to contain_package('policycoreutils-python').with_ensure('installed') }
          it { is_expected.to contain_package('sysstat').with_ensure('installed') }
          it { is_expected.to contain_package('telnet').with_ensure('installed') }
          it { is_expected.to contain_package('traceroute').with_ensure('installed') }
          it { is_expected.to contain_package('unzip').with_ensure('installed') }
          it { is_expected.to contain_package('vim-enhanced').with_ensure('installed') }
          it { is_expected.to contain_package('vim-minimal').with_ensure('installed') }
          it { is_expected.to contain_package('wget').with_ensure('installed') }
          it { is_expected.to contain_package('yum-cron').with_ensure('installed') }
          it { is_expected.to contain_package('yum-utils').with_ensure('installed') }
          it { is_expected.to contain_package('zip').with_ensure('installed') }
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
