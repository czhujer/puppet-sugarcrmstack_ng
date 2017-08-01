# == Class sugarcrmstack_ng::config
#
# This class is called from sugarcrmstack_ng for service config.
#
class sugarcrmstack_ng::config {

  #enable remi-php56 repo
  if ($::sugarcrmstack_ng::apache_php_enable){
    if ($::operatingsystemmajrelease in ['7']){
      if ( defined(Yumrepo['remi-php56']) ){
        warning('Possible override of value "enable" in repo remi-php56')
      }

      ini_setting { 'enable remi-php56 repo':
        ensure  => present,
        path    => '/etc/yum.repos.d/remi.repo',
        section => 'remi-php56',
        setting => 'enabled',
        value   => '1',
      }

    }
  }

  #enable/disable mysql repos
  if ($::sugarcrmstack_ng::mysql_server_enable){

    if ($::operatingsystemmajrelease in ['7'] and $::sugarcrmstack_ng::mysql_server_use_pxc == true) {
      ini_setting { 'mysql 5.7 repo enable':
        ensure  => present,
        path    => '/etc/yum.repos.d/mysql-community.repo',
        section => 'mysql57-community-dmr',
        setting => 'enabled',
        value   => '0',
      }

      ini_setting { 'mysql 5.6 repo disable':
        ensure  => present,
        path    => '/etc/yum.repos.d/mysql-community.repo',
        section => 'mysql56-community',
        setting => 'enabled',
        value   => '0',
      }
    }
    elsif ($::operatingsystemmajrelease in ['7'] and $::sugarcrmstack_ng::mysql_server_use_pxc == false and $::sugarcrmstack_ng::sugar_version == '7.5' ) {
      ini_setting { 'mysql 5.7 repo enable':
        ensure  => present,
        path    => '/etc/yum.repos.d/mysql-community.repo',
        section => 'mysql57-community-dmr',
        setting => 'enabled',
        value   => '0',
      }

      ini_setting { 'mysql 5.6 repo enable':
        ensure  => present,
        path    => '/etc/yum.repos.d/mysql-community.repo',
        section => 'mysql56-community',
        setting => 'enabled',
        value   => '1',
      }
    }
    elsif ($::operatingsystemmajrelease in ['7'] and $::sugarcrmstack_ng::mysql_server_use_pxc == false and $::sugarcrmstack_ng::sugar_version == '7.9' ) {
      ini_setting { 'mysql 5.7 repo enable':
        ensure  => present,
        path    => '/etc/yum.repos.d/mysql-community.repo',
        section => 'mysql57-community-dmr',
        setting => 'enabled',
        value   => '1',
      }

      ini_setting { 'mysql 5.6 repo enable':
        ensure  => present,
        path    => '/etc/yum.repos.d/mysql-community.repo',
        section => 'mysql56-community',
        setting => 'enabled',
        value   => '0',
      }
    }
  }

}
