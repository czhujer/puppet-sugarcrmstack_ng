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
          it { is_expected.to contain_package('sugarcrmstack_ng').with_ensure('present') }
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
