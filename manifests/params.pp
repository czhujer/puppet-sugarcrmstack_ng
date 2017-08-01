# == Class sugarcrmstack_ng::params
#
# This class is meant to be called from sugarcrmstack_ng.
# It sets variables according to platform.
#
class sugarcrmstack_ng::params {
  $apache_php_enable = true
  $mysql_server_enable = false
  $sugar_version     = '7.9'
  case $::osfamily {
    'RedHat', 'Amazon': {
      $manage_utils_packages = true

      if ($::operatingsystemmajrelease in ['7']){
        $utils_packages = ['iotop', 'iftop', 'iptraf', 'sysstat',
                'zip', 'lsscsi', 'unzip',
                'links', 'lynx', 'policycoreutils-python',
                'htop', 'bind-utils', 'wget', 'telnet', 'lsof',
                'irqbalance', 'vim-minimal', 'yum-utils',
                'traceroute', 'vim-enhanced', 'net-tools',
                'numad', 'yum-cron', 'apachetop', 'nano']

        $apache_php_apache_default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter', 'mime', 'mime_magic', 'rewrite', 'speling', 'suexec',
                                      'version', 'vhost_alias', 'auth_digest', 'authn_anon', 'authn_dbm', 'authz_dbm', 'authz_owner',
                                      'expires', 'include', 'logio', 'substitute', 'usertrack', 'alias',
                                      'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir', 'negotiation', 'setenvif', 'auth_basic',
                                      'authz_user', 'authz_groupfile', 'env', ]

      }
      else{
        $utils_packages = ['iotop', 'iftop', 'iptraf', 'sysstat',
                'zip', 'lsscsi', 'unzip',
                'links', 'lynx', 'policycoreutils-python',
                'htop', 'bind-utils', 'wget', 'telnet', 'lsof',
                'irqbalance', 'vim-minimal', 'yum-utils',
                'traceroute', 'vim-enhanced', 'hal', 'cpuspeed',
                'numad', 'yum-cron', 'apachetop', 'nano']

        $apache_php_apache_default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter', 'mime', 'mime_magic', 'rewrite', 'speling', 'suexec',
                                      'version', 'vhost_alias', 'auth_digest', 'authn_anon', 'authn_dbm', 'authz_dbm', 'authz_owner',
                                      'expires', 'include', 'logio', 'substitute', 'usertrack', 'authn_alias', 'authn_default', 'alias',
                                      'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir', 'negotiation', 'setenvif', 'auth_basic',
                                      'authz_user', 'authz_groupfile', 'env', 'authz_default',]

      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
  #
  $apache_php_php_pkg_version = '5.6.31'
  $apache_php_php_pkg_build = '1'
  $apache_php_php_error_reporting = 'E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE & ~E_WARNING'
  $apache_php_apache_https_port = '443'
  $apache_php_apache_http_port = '80'
  $apache_php_php_memory_limit = '1024M'
  $apache_php_php_max_execution_time = '300'
  $apache_php_php_upload_max_filesize = '100M'
  $apache_php_manage_firewall = false
  $apache_php_apache_http_redirect = true
  $apache_php_php_cache_engine = 'opcache+apcu'
  $apache_php_php_session_save_handler = 'files'
  $apache_php_php_session_save_path = '/var/lib/php/session'
  $apache_php_apache_manage_user = false
  $apache_php_manage_phpmyadmin_config = true
  $apache_php_manage_phpmyadmin_files = true
  #
  $mysql_server_service_manage = true
  $mysql_server_service_enabled = true
  $mysql_server_service_restart = true
  $mysql_server_config_max_connections = "1024"
  $mysql_server_use_pxc = false
}
