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
  $mysql_server_enable = $::sugarcrmstack_ng::params::mysql_server_enable,
  $sugar_version = $::sugarcrmstack_ng::params::sugar_version,
  #
  $mysql_server_service_manage = $::sugarcrmstack_ng::params::mysql_server_service_manage,
  $mysql_server_service_enabled = $::sugarcrmstack_ng::params::mysql_server_service_enabled,
  $mysql_server_service_restart = $::sugarcrmstack_ng::params::mysql_server_service_restart,
  $mysql_server_config_max_connections = $::sugarcrmstack_ng::params::mysql_server_config_max_connections,
  $mysql_server_use_pxc = $::sugarcrmstack_ng::params::mysql_server_use_pxc,
  #
) inherits sugarcrmstack_ng::params {

  if ($mysql_server_enable){

    if ($::sugarcrmstack_ng::mysql_server_use_pxc == true and $sugar_version == '7.9' and $::operatingsystemmajrelease in ['7'] ){
      package {'Percona-XtraDB-Cluster-shared-compat-57':
        ensure => 'installed',
        before => Class['sugarcrmstack::mysqlserver'],
      }
    }

    if ($::operatingsystemmajrelease in ['7'] ){

      # log folder2
      file { "mysql-server log folder2":
        ensure  => directory,
        path    => "/var/log/mariadb",
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0755',
        before => Class['sugarcrmstack::mysqlserver'],
      }

      # slow query log2
      file { "mysql-server slow query log2":
        ensure  => present,
        path    => "/var/log/mariadb/mysql-slow.log",
        owner   => 'mysql',
        group   => 'mysql',
        mode    => '0644',
        before  => Class['sugarcrmstack::mysqlserver'],
        require => File['mysql-server log folder2'],
      }
    }

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      class { 'sugarcrmstack::mysqlserver':
        #mysql_server_enable => $mysql_server_enable,
        mysql_server_service_manage         => $mysql_server_service_manage,
        mysql_server_service_enabled        => $mysql_server_service_enabled,
        mysql_server_service_restart        => $mysql_server_service_restart,
        mysql_server_config_max_connections => $mysql_server_config_max_connections,
        mysql_server_use_pxc                => $mysql_server_use_pxc,
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::mysql_server']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
    }
  }
}
