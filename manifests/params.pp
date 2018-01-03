# == Class sugarcrmstack_ng::params
#
# This class is meant to be called from sugarcrmstack_ng.
# It sets variables according to platform.
#
class sugarcrmstack_ng::params {
  $apache_php_enable = true
  $mysql_server_enable = false
  $elasticsearch_server_enable = false
  $cron_enable       = false
  $redis_server_enable = false
  $memcached_server_enable = false
  $firewall_manage = false
  $beats_manage = false
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

        $apache_php_apache_default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter', 'mime', 'mime_magic', 'rewrite', 'speling',
                                      'version', 'vhost_alias', 'auth_digest', 'authn_anon', 'authn_dbm', 'authz_dbm', 'authz_owner',
                                      'expires', 'include', 'logio', 'substitute', 'usertrack', 'alias',
                                      'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir', 'negotiation', 'setenvif', 'auth_basic',
                                      'authz_user', 'authz_groupfile', 'env', 'suexec']

        $apache_php_php_pkg_version = '5.6.32'
        $apache_php_php_pkg_build = '1'

        $memcached_php_module_name = 'php-pecl-memcache'

      }
      else{
        $utils_packages = ['iotop', 'iftop', 'iptraf', 'sysstat',
                'zip', 'lsscsi', 'unzip',
                'links', 'lynx', 'policycoreutils-python',
                'htop', 'bind-utils', 'wget', 'telnet', 'lsof',
                'irqbalance', 'vim-minimal', 'yum-utils',
                'traceroute', 'vim-enhanced', 'hal', 'cpuspeed',
                'numad', 'yum-cron', 'apachetop', 'nano']

        $apache_php_apache_default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter', 'mime', 'mime_magic', 'rewrite', 'speling',
                                      'version', 'vhost_alias', 'auth_digest', 'authn_anon', 'authn_dbm', 'authz_dbm', 'authz_owner',
                                      'expires', 'include', 'logio', 'substitute', 'usertrack', 'authn_alias', 'authn_default', 'alias',
                                      'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir', 'negotiation', 'setenvif', 'auth_basic',
                                      'authz_user', 'authz_groupfile', 'env', 'authz_default', 'suexec']

        $apache_php_php_pkg_version = '5.6.32'
        $apache_php_php_pkg_build = '2'

        $memcached_php_module_name = 'php56u-pecl-memcache'
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
  #
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
  $mysql_server_config_max_connections = '1024'
  $mysql_server_use_pxc = false
  #
  $galeracluster_galeracluster_enable = '0'
  $mysql_server_mysql_override_options = {}
  $mysql_server_mysql_users_custom = {}
  $mysql_server_mysql_grants_custom = {}
  $mysql_server_mysql_sugarcrm_pass_hash = '*BD4FB69062149C65C7EE797605C881F8777AB144'
  $mysql_server_mysql_automysqlbackup_pass_hash = '*1CB694F2DF9A301025FD3594B5461AA2EDD24AC3'
  $mysql_server_mysql_root_password = ''
  #
  $elasticsearch_server_es_disable_config = false
  $elasticsearch_server_es_java_install = true
  $elasticsearch_server_es_repo_version = '1.7'
  $elasticsearch_server_es_version = '1.7.5-1'
  $elasticsearch_server_es_package_pin = true
  $elasticsearch_server_es_instance_init_defaults = {}
  $elasticsearch_server_es_status = 'enabled'
  $elasticsearch_server_es_instance_config = {
    'network.host' => '127.0.0.1',
    'http.port' => 9200,
    'index.number_of_replicas' => '0',
  }
  $cron_handle_package = true
  $cron_handle_sugarcrm_file = true
  $cron_purge_users_crontabs = true
  $cron_service_enable = true
  $cron_service_ensure = true
  #
  $redis_server_ensure = 'installed'
  #
  $memcached_install_top_cli = false
  $memcached_server_max_memory = 32
  $memcached_service_manage = true
  $memcached_server_pkg_ensure = 'present'
  #
  $memcached_php_module_handle = false
  $memcached_php_module_ensure = 'installed'
  #
  $firewall_ssh_port = '22'
  #
  $beats_agentname   = $::fqdn
  $beats_version_v5  = true
  $beats_filebeats_enable   = true
  $beats_metricbeats_enable = false
  #
  $beats_filebeats_prospectors_config = {}
  $beats_hosts = ['logstash.sugarfactory.cz:5044']
}
