# == Class sugarcrmstack_ng::install
#
# This class is called from sugarcrmstack_ng for install.
#
class sugarcrmstack_ng::install {

  # install epel repo
  if ( !defined(Yumrepo['epel']) and !defined(Package['epel-release'])){
    package { 'epel-release':
      ensure => 'installed',
    }
    $require_utils_packages = Package['epel-release']
  }
  else{
    $require_utils_packages = Yumrepo['epel']
  }

  # install remi repo
  if ($::sugarcrmstack_ng::apache_php_enable){
    if ($::operatingsystemmajrelease in ['7']){
      if ( !defined(Yumrepo['remi-php56']) and !defined(Package['remi-release'])){
        package { 'remi-release':
          ensure   => 'installed',
          source   => 'http://rpms.famillecollet.com/enterprise/remi-release-7.rpm',
          provider => 'rpm',
        }
      }
    }
    elsif ($::operatingsystemmajrelease in ['6']){
      if ( !defined(Yumrepo['ius']) and !defined(Yumrepo['ius-archive']) and !defined(Package['ius-release']) ){
        package { 'ius-release':
          ensure   => 'installed',
          source   => 'http://dl.iuscommunity.org/pub/ius/archive/CentOS/6/x86_64/ius-release-1.0-11.ius.centos6.noarch.rpm',
          provider => 'rpm',
        }
      }
    }
  }

  # install mysql/percona repo
  if ($::sugarcrmstack_ng::mysql_server_enable){
    if($::sugarcrmstack_ng::mysql_server_use_pxc){

      package { 'percona-release':
        ensure   => installed,
        provider => rpm,
        source   => 'https://www.percona.com/redir/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm',
      }

    }
    else{

      if ($::operatingsystemmajrelease in ['7']){
        package { 'mysql-repo':
          ensure   => 'el7-5',
          name     => 'mysql-community-release',
          provider => 'rpm',
          #source => 'http://repo.mysql.com/mysql-community-release-el7.rpm'
          source   => 'https://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm',
        }
      }
      else{
        package { 'mysql-repo':
          ensure   => 'el6-7',
          name     => 'mysql-community-release',
          provider => 'rpm',
          #source => 'http://repo.mysql.com/mysql-community-release-el6.rpm'
          source   => 'https://repo.mysql.com/mysql-community-release-el6-7.noarch.rpm',
        }
      }
    }
  }

  # install utils packages
  if($::sugarcrmstack_ng::manage_utils_packages){
    package { $::sugarcrmstack_ng::utils_packages:
      ensure  => 'installed',
      require => $require_utils_packages,
#                Ini_setting['remi repo exclude packages'],
#                Ini_setting['centos base repo exclude packages 2'],
#                Ini_setting['centos base repo exclude packages'],
    }
  }

  # uninstall old mysql/percona packages
  if ($::sugarcrmstack_ng::mysql_server_enable){

    if ($::operatingsystemmajrelease in ['7'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == true and
        $::sugarcrmstack_ng::sugar_version == '7.5') {
      $mysql_server_packages_old = ['mariadb', 'mariadb-server', 'mariadb-libs',
                                    'mysql-community-server', 'mysql-community-client',
                                    'mysql-community-common', 'mysql-community-libs',
                                    'Percona-XtraDB-Cluster-shared-compat-57', 'Percona-XtraDB-Cluster-client-57',
                                    'Percona-XtraDB-Cluster-shared-57',
      ]
    }
    elsif ($::operatingsystemmajrelease in ['7'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == true and
        ($::sugarcrmstack_ng::sugar_version == '7.9' or $::sugarcrmstack_ng::sugar_version == '8.0' or $::sugarcrmstack_ng::sugar_version == '9.0')) {
      $mysql_server_packages_old = ['mariadb', 'mariadb-server', 'mariadb-libs',
                                    'mysql-community-server', 'mysql-community-client',
                                    'mysql-community-common', 'mysql-community-libs',
                                    'Percona-XtraDB-Cluster-shared-compat-56', 'Percona-XtraDB-Cluster-client-56',
                                    'Percona-XtraDB-Cluster-shared-56', 'Percona-XtraDB-Cluster-galera-3',
      ]
    }
    elsif ($::operatingsystemmajrelease in ['7'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == false) {
      $mysql_server_packages_old = ['mariadb', 'mariadb-server', 'mariadb-libs',
                                    'Percona-XtraDB-Cluster-shared-compat-56', 'Percona-XtraDB-Cluster-client-56',
                                    'Percona-XtraDB-Cluster-shared-56', 'Percona-XtraDB-Cluster-galera-3',
                                    'Percona-XtraDB-Cluster-shared-compat-57', 'Percona-XtraDB-Cluster-client-57',
                                    'Percona-XtraDB-Cluster-shared-57',
      ]
    }
    elsif ($::operatingsystemmajrelease in ['6'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == true and
        $::sugarcrmstack_ng::sugar_version == '7.5'){
      $mysql_server_packages_old = ['mysql55', 'mysql55-libs', 'mysql55-server', 'mysql-community-server', 'mysql-community-client' ]
    }
    elsif ($::operatingsystemmajrelease in ['6'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == false and
        $::sugarcrmstack_ng::sugar_version == '7.5'){
      $mysql_server_packages_old = ['mysql55', 'mysql55-libs', 'mysql55-server']
    }
    elsif ($::operatingsystemmajrelease in ['6'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == true and
        ($::sugarcrmstack_ng::sugar_version == '7.9' or $::sugarcrmstack_ng::sugar_version == '8.0' or $::sugarcrmstack_ng::sugar_version == '9.0')){
      $mysql_server_packages_old = ['mysql55', 'mysql55-libs', 'mysql55-server', 'mysql-community-server', 'mysql-community-client' ]
      #add Percona-XtraDB-Cluster-client-56, Percona-XtraDB-Cluster-server-56, Percona-XtraDB-Cluster-shared-56,
      #Percona-XtraDB-Cluster-galera-3
    }
    elsif ($::operatingsystemmajrelease in ['6'] and
        $::sugarcrmstack_ng::mysql_server_use_pxc == false and
        ($::sugarcrmstack_ng::sugar_version == '7.9' or $::sugarcrmstack_ng::sugar_version == '8.0' or $::sugarcrmstack_ng::sugar_version == '9.0')){
      $mysql_server_packages_old = ['mysql55', 'mysql55-libs', 'mysql55-server']
    }
    else{
    }

    package { $mysql_server_packages_old:
      ensure   => 'purged',
      provider => 'yum',
    }
  }

}
