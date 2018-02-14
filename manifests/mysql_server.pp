# Class: mysql_server
# ===========================
#
# Full description of class mysql_server here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::mysql_server (
  $mysql_server_enable = $sugarcrmstack_ng::mysql_server_enable,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $mysql_server_service_manage = $sugarcrmstack_ng::mysql_server_service_manage,
  $mysql_server_service_enabled = $sugarcrmstack_ng::mysql_server_service_enabled,
  $mysql_server_service_restart = $sugarcrmstack_ng::mysql_server_service_restart,
  $mysql_server_config_max_connections = $sugarcrmstack_ng::mysql_server_config_max_connections,
  $mysql_server_use_pxc = $sugarcrmstack_ng::mysql_server_use_pxc,
  #
  $galeracluster_galeracluster_enable = $sugarcrmstack_ng::galeracluster_galeracluster_enable,
  $mysql_server_mysql_override_options = $sugarcrmstack_ng::mysql_server_mysql_override_options,
  $mysql_server_mysql_users_custom = $sugarcrmstack_ng::mysql_server_mysql_users_custom,
  $mysql_server_mysql_grants_custom = $sugarcrmstack_ng::mysql_server_mysql_grants_custom,
  $mysql_server_mysql_sugarcrm_pass_hash = $sugarcrmstack_ng::mysql_server_mysql_sugarcrm_pass_hash,
  $mysql_server_mysql_automysqlbackup_pass_hash = $sugarcrmstack_ng::mysql_server_mysql_automysqlbackup_pass_hash,
  $mysql_server_mysql_root_password = $sugarcrmstack_ng::mysql_server_mysql_root_password,
) {

  if($mysql_server_service_manage){
    $require_service_mysqld = Service['mysqld']
  }
  else{
    $require_service_mysqld = []
  }

  if ($mysql_server_enable){

    #we need delete /etc/percona-xtradb-cluster.conf.d config files
    if ! defined (File['/etc/percona-xtradb-cluster.conf.d']){
      file {'/etc/percona-xtradb-cluster.conf.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
        after   => Class['sugarcrmstack::mysqlserver'],
        notify  => $require_service_mysqld,
      }
    }

    if ($mysql_server_use_pxc == true and $sugar_version == '7.9' and $::operatingsystemmajrelease in ['7'] ){
      package {'Percona-XtraDB-Cluster-shared-compat-57':
        ensure => 'installed',
        before => Class['sugarcrmstack::mysqlserver'],
      }
    }

    if ($mysql_server_use_pxc == true and $sugar_version == '7.5' and $::operatingsystemmajrelease in ['7'] ){
      #fix hang on systemctl restart mysql
      if ! defined (File['/etc/my.cnf']){
        file { '/etc/my.cnf':
          ensure  => 'absent',
          after   => Class['sugarcrmstack::mysqlserver'],
          notify  => $require_service_mysqld,
        }
      }
    }

    if ($mysql_server_use_pxc == true and $sugar_version == '7.9' and $::operatingsystemmajrelease in ['7'] ){
      #fix hang on systemctl restart mysql
      if ! defined (File['/etc/my.cnf']){
        file { '/etc/my.cnf':
          ensure  => file,
          content => template('sugarcrmstack_ng/percona-5.7-my.cnf.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          after   => Class['sugarcrmstack::mysqlserver'],
          notify  => $require_service_mysqld,
        }
      }
    }

    if ($::operatingsystemmajrelease in ['7'] ){

      # log folder2
      file { 'mysql-server log folder2':
        ensure  => directory,
        path    => '/var/log/mariadb',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
        before  => Class['sugarcrmstack::mysqlserver'],
        require => Package['mysql-server'],
      }

      # slow query log2
      file { 'mysql-server slow query log2':
        ensure  => present,
        path    => '/var/log/mariadb/mysql-slow.log',
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0644',
        before  => Class['sugarcrmstack::mysqlserver'],
        require => File['mysql-server log folder2'],
      }
    }

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      class { '::sugarcrmstack::mysqlserver':
        mysql_server_enable                 => $mysql_server_enable,
        mysql_server_service_manage         => $mysql_server_service_manage,
        mysql_server_service_enabled        => $mysql_server_service_enabled,
        mysql_server_service_restart        => $mysql_server_service_restart,
        mysql_server_config_max_connections => $mysql_server_config_max_connections,
        mysql_server_use_pxc                => $mysql_server_use_pxc,
        #
        sugar_version                       => $sugar_version,
        galeracluster_galeracluster_enable  => $galeracluster_galeracluster_enable,
        mysql_override_options              => $mysql_server_mysql_override_options,
        mysql_users_custom                  => $mysql_server_mysql_users_custom,
        mysql_grants_custom                 => $mysql_server_mysql_grants_custom,
        mysql_sugarcrm_pass_hash            => $mysql_server_mysql_sugarcrm_pass_hash,
        mysql_automysqlbackup_pass_hash     => $mysql_server_mysql_automysqlbackup_pass_hash,
        mysql_root_password                 => $mysql_server_mysql_root_password,
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::mysql_server']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
    }
  }
}
