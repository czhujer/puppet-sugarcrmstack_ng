  # == Class sugarcrmstack_ng::config
  #
  # This class is called from sugarcrmstack_ng for service config.
  #
  class sugarcrmstack_ng::config {

    #enable/disable remi-php repo(s)
    if ($::sugarcrmstack_ng::apache_php_enable and $::sugarcrmstack_ng::apache_php_manage_php_remi_repo){
      if ($::operatingsystemmajrelease in ['7']){

        if ($::sugarcrmstack_ng::sugar_version == '8.0'){

          ini_setting { 'enable remi-php71 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi-php71.repo',
            section => 'remi-php71',
            setting => 'enabled',
            value   => '1',
          }

          ini_setting { 'disable remi-php56 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi.repo',
            section => 'remi-php56',
            setting => 'enabled',
            value   => '0',
          }
        }
        elsif ($::sugarcrmstack_ng::sugar_version == '9.0' and $::sugarcrmstack_ng::apache_php_php_pkg_version =~ /^7\.1\.[0-9][0-9]/){

          ini_setting { 'enable remi-php71 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi-php71.repo',
            section => 'remi-php71',
            setting => 'enabled',
            value   => '1',
          }

          ini_setting { 'disable remi-php56 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi.repo',
            section => 'remi-php56',
            setting => 'enabled',
            value   => '0',
          }
        }
        elsif ($::sugarcrmstack_ng::sugar_version == '9.0' and $::sugarcrmstack_ng::apache_php_php_pkg_version =~ /^7\.3\.[0-9]/){

          ini_setting { 'enable remi-php73 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi-php73.repo',
            section => 'remi-php73',
            setting => 'enabled',
            value   => '1',
          }

          ini_setting { 'disable remi-php71 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi-php71.repo',
            section => 'remi-php71',
            setting => 'enabled',
            value   => '0',
          }

          ini_setting { 'disable remi-php56 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi.repo',
            section => 'remi-php56',
            setting => 'enabled',
            value   => '0',
          }
        }
        else {

          ini_setting { 'enable remi-php56 repo':
            ensure  => present,
            path    => '/etc/yum.repos.d/remi.repo',
            section => 'remi-php56',
            setting => 'enabled',
            value   => '1',
          }
        }
      }

      elsif ($::operatingsystemmajrelease in ['6']){

        if ( defined(Yumrepo['ius-archive']) ){
          warning('Possible override of value "enable" in repo ius-archive')
        }

        ini_setting { 'ius-archive enable':
          ensure  => present,
          path    => '/etc/yum.repos.d/ius-archive.repo',
          section => 'ius-archive',
          setting => 'enabled',
          value   => '1',
        }

      }
    }

    #enable/disable mysql repos
    if ($::sugarcrmstack_ng::mysql_server_enable){

      if ($::operatingsystemmajrelease in ['7'] and  $::sugarcrmstack_ng::sugar_version == '7.5' ) {

        if (defined_with_params(Package['mysql-repo'], {'ensure' => 'el6-7' }) or
          defined_with_params(Package['mysql-repo'], {'ensure' => 'el7-5' }) ) {

          ini_setting { 'mysql 5.7 repo disable':
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
      }
      elsif ($::operatingsystemmajrelease in ['7'] and
        ($::sugarcrmstack_ng::sugar_version == '7.9' or $::sugarcrmstack_ng::sugar_version == '8.0' or $::sugarcrmstack_ng::sugar_version == '9.0')) {

        if (defined_with_params(Package['mysql-repo'], {'ensure' => 'el6-7' }) or
           defined_with_params(Package['mysql-repo'], {'ensure' => 'el7-5' }) ) {

          ini_setting { 'mysql 5.7 repo enable':
            ensure  => present,
            path    => '/etc/yum.repos.d/mysql-community.repo',
            section => 'mysql57-community-dmr',
            setting => 'enabled',
            value   => '1',
          }

          ini_setting { 'mysql 5.6 repo disable':
            ensure  => present,
            path    => '/etc/yum.repos.d/mysql-community.repo',
            section => 'mysql56-community',
            setting => 'enabled',
            value   => '0',
          }
        }
      }
    }
  }
