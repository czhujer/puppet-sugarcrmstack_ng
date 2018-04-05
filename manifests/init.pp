# Class: sugarcrmstack_ng
# ===========================
#
# Full description of class sugarcrmstack_ng here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng (
  $manage_utils_packages = $sugarcrmstack_ng::params::manage_utils_packages,
  $utils_packages = $sugarcrmstack_ng::params::utils_packages,
  #
  $apache_php_enable = $sugarcrmstack_ng::params::apache_php_enable,
  $mysql_server_enable = $sugarcrmstack_ng::params::mysql_server_enable,
  $elasticsearch_server_enable = $sugarcrmstack_ng::params::elasticsearch_server_enable,
  $cron_enable = $sugarcrmstack_ng::params::cron_enable,
  $redis_server_enable = $sugarcrmstack_ng::params::redis_server_enable,
  $memcached_server_enable = $sugarcrmstack_ng::params::memcached_server_enable,
  $users_env_manage = $sugarcrmstack_ng::params::users_env_manage,
  $apache_mysql_config_manage = $sugarcrmstack_ng::params::apache_mysql_config_manage,
  #
  $sugar_version = $sugarcrmstack_ng::params::sugar_version,
  #
  $apache_php_php_pkg_version = $sugarcrmstack_ng::params::apache_php_php_pkg_version,
  $apache_php_php_pkg_build = $sugarcrmstack_ng::params::apache_php_php_pkg_build,
  $apache_php_php_error_reporting = $sugarcrmstack_ng::params::apache_php_php_error_reporting,
  $apache_php_apache_https_port = $sugarcrmstack_ng::params::apache_php_apache_https_port,
  $apache_php_apache_http_port = $sugarcrmstack_ng::params::apache_php_apache_http_port,
  $apache_php_php_memory_limit = $sugarcrmstack_ng::params::apache_php_php_memory_limit,
  $apache_php_php_max_execution_time = $sugarcrmstack_ng::params::apache_php_php_max_execution_time,
  $apache_php_php_upload_max_filesize = $sugarcrmstack_ng::params::apache_php_php_upload_max_filesize,
  $apache_php_manage_firewall = $sugarcrmstack_ng::params::apache_php_manage_firewall,
  $apache_php_apache_http_redirect = $sugarcrmstack_ng::params::apache_php_apache_http_redirect,
  $apache_php_apache_default_mods = $sugarcrmstack_ng::params::apache_php_apache_default_mods,
  $apache_php_php_cache_engine = $sugarcrmstack_ng::params::apache_php_php_cache_engine,
  $apache_php_php_session_save_handler = $sugarcrmstack_ng::params::apache_php_php_session_save_handler,
  $apache_php_php_session_save_path = $sugarcrmstack_ng::params::apache_php_php_session_save_path,
  $apache_php_apache_manage_user = $sugarcrmstack_ng::params::apache_php_apache_manage_user,
  $apache_php_manage_phpmyadmin_config = $sugarcrmstack_ng::params::apache_php_manage_phpmyadmin_config,
  $apache_php_manage_phpmyadmin_files = $sugarcrmstack_ng::params::apache_php_manage_phpmyadmin_files,
  #
  #$apache_php_apache_serveradmin =
  #$apache_php_apache_mpm =
  #$apache_php_apache_timeout =
  #$apache_php_apache_keepalive =
  #
  $apache_php_xdebug_module_manage   = $sugarcrmstack_ng::params::apache_php_xdebug_module_manage,
  $apache_php_xdebug_module_ensure   = $sugarcrmstack_ng::params::apache_php_xdebug_module_ensure,
  $apache_php_xdebug_module_settings = $sugarcrmstack_ng::params::apache_php_xdebug_module_settings,
  #
  $mysql_server_service_manage = $sugarcrmstack_ng::params::mysql_server_service_manage,
  $mysql_server_service_enabled = $sugarcrmstack_ng::params::mysql_server_service_enabled,
  $mysql_server_service_restart = $sugarcrmstack_ng::params::mysql_server_service_restart,
  $mysql_server_config_max_connections = $sugarcrmstack_ng::params::mysql_server_config_max_connections,
  $mysql_server_use_pxc = $sugarcrmstack_ng::params::mysql_server_use_pxc,
  #
  $galeracluster_galeracluster_enable = $sugarcrmstack_ng::params::galeracluster_galeracluster_enable,
  $mysql_server_mysql_override_options = $sugarcrmstack_ng::params::mysql_server_mysql_override_options,
  $mysql_server_mysql_users_custom = $sugarcrmstack_ng::params::mysql_server_mysql_users_custom,
  $mysql_server_mysql_grants_custom = $sugarcrmstack_ng::params::mysql_server_mysql_grants_custom,
  $mysql_server_mysql_sugarcrm_pass_hash = $sugarcrmstack_ng::params::mysql_server_mysql_sugarcrm_pass_hash,
  $mysql_server_mysql_automysqlbackup_pass_hash = $sugarcrmstack_ng::params::mysql_server_mysql_automysqlbackup_pass_hash,
  $mysql_server_mysql_root_password = $sugarcrmstack_ng::params::mysql_server_mysql_root_password,
  #
  $elasticsearch_server_es_disable_config = $sugarcrmstack_ng::params::elasticsearch_server_es_disable_config,
  $elasticsearch_server_es_java_install = $sugarcrmstack_ng::params::elasticsearch_server_es_java_install,
  $elasticsearch_server_es_repo_version = $sugarcrmstack_ng::params::elasticsearch_server_es_repo_version,
  $elasticsearch_server_es_version = $sugarcrmstack_ng::params::elasticsearch_server_es_version,
  $elasticsearch_server_es_package_pin = $sugarcrmstack_ng::params::elasticsearch_server_es_package_pin,
  $elasticsearch_server_es_instance_init_defaults = $sugarcrmstack_ng::params::elasticsearch_server_es_instance_init_defaults,
  $elasticsearch_server_es_status = $sugarcrmstack_ng::params::elasticsearch_server_es_status,
  $elasticsearch_server_es_instance_config = $sugarcrmstack_ng::params::elasticsearch_server_es_instance_config,
  #
  $cron_handle_package = $sugarcrmstack_ng::params::cron_handle_package,
  $cron_handle_sugarcrm_file = $sugarcrmstack_ng::params::cron_handle_sugarcrm_file,
  $cron_purge_users_crontabs = $sugarcrmstack_ng::params::cron_purge_users_crontabs,
  #
  $cron_service_enable = $sugarcrmstack_ng::params::cron_service_enable,
  $cron_service_ensure = $sugarcrmstack_ng::params::cron_service_ensure,
  #
  $redis_server_ensure = $sugarcrmstack_ng::params::redis_server_ensure,
  #
  $memcached_install_top_cli   = $sugarcrmstack_ng::params::memcached_install_top_cli,
  $memcached_server_max_memory = $sugarcrmstack_ng::params::memcached_server_max_memory,
  $memcached_service_manage    = $sugarcrmstack_ng::params::memcached_service_manage,
  $memcached_server_pkg_ensure = $sugarcrmstack_ng::params::memcached_server_pkg_ensure,
  #
  $memcached_php_module_handle = $sugarcrmstack_ng::params::memcached_php_module_handle,
  $memcached_php_module_name   = $sugarcrmstack_ng::params::memcached_php_module_name,
  $memcached_php_module_ensure = $sugarcrmstack_ng::params::memcached_php_module_ensure,
  #
  $firewall_manage   = $sugarcrmstack_ng::params::firewall_manage,
  $firewall_ssh_port = $sugarcrmstack_ng::params::firewall_ssh_port,
  #
  $beats_manage      = $sugarcrmstack_ng::params::beats_manage,
  $beats_agentname   = $sugarcrmstack_ng::params::beats_agentname,
  $beats_version_v5  = $sugarcrmstack_ng::params::beats_version_v5,
  $beats_filebeats_enable   = $sugarcrmstack_ng::params::beats_filebeats_enable,
  $beats_metricbeats_enable = $sugarcrmstack_ng::params::beats_metricbeats_enable,
  #
  $beats_filebeats_prospectors_config = $sugarcrmstack_ng::params::beats_filebeats_prospectors_config,
  $beats_filebeats_prospectors_config_extra = $sugarcrmstack_ng::params::beats_filebeats_prospectors_config_extra,
  $beats_hosts = $sugarcrmstack_ng::params::beats_hosts,
  #
) inherits sugarcrmstack_ng::params {

  # validate general parameters
  validate_bool($manage_utils_packages)
  validate_array($utils_packages)

  validate_bool($apache_php_enable)
  validate_bool($mysql_server_enable)
  validate_bool($elasticsearch_server_enable)
  validate_bool($cron_enable)
  validate_bool($redis_server_enable)
  validate_bool($memcached_server_enable)

  validate_bool($firewall_manage)

  validate_string($sugar_version)

  if ($sugar_version != '7.5' and $sugar_version != '7.9'){
    fail("Class['sugarcrmstack_ng']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
  }

  # validate apache_php parameters

  #$apache_php_php_pkg_version
  #$apache_php_php_pkg_build
  #$apache_php_php_error_reporting
  #$apache_php_apache_https_port
  #$apache_php_apache_http_port
  #$apache_php_php_memory_limit
  #$apache_php_php_max_execution_time
  #$apache_php_php_upload_max_filesize
  validate_bool($apache_php_manage_firewall)
  validate_bool($apache_php_apache_http_redirect)
  validate_array($apache_php_apache_default_mods)
  #$apache_php_php_cache_engine
  #$apache_php_php_session_save_handler
  #$apache_php_php_session_save_path
  validate_bool($apache_php_apache_manage_user)
  validate_bool($apache_php_manage_phpmyadmin_config)
  validate_bool($apache_php_manage_phpmyadmin_files)

  validate_bool($apache_php_xdebug_module_manage)
  validate_string($apache_php_xdebug_module_ensure)
  validate_hash($apache_php_xdebug_module_settings)

  # validate mysql_server parameters

  #$mysql_server_service_manage
  #$mysql_server_service_enabled
  #$mysql_server_service_restart
  validate_integer($mysql_server_config_max_connections)
  validate_bool($mysql_server_use_pxc)

  #$galeracluster_galeracluster_enable
  validate_hash($mysql_server_mysql_override_options)
  validate_hash($mysql_server_mysql_users_custom)
  validate_hash($mysql_server_mysql_grants_custom)
  #$mysql_server_mysql_sugarcrm_pass_hash
  #$mysql_server_mysql_automysqlbackup_pass_hash
  #$mysql_server_mysql_root_password

  # validate elasticsearch_server parameters

  validate_bool($elasticsearch_server_es_disable_config)
  validate_bool($elasticsearch_server_es_java_install)
  #$elasticsearch_server_es_repo_version
  #$elasticsearch_server_es_version
  validate_bool($elasticsearch_server_es_package_pin)
  validate_hash($elasticsearch_server_es_instance_init_defaults)
  #$elasticsearch_server_es_status
  validate_hash($elasticsearch_server_es_instance_config)

  validate_bool($cron_handle_package)
  validate_bool($cron_handle_sugarcrm_file)
  validate_bool($cron_purge_users_crontabs)

  validate_bool($cron_service_enable)
  validate_bool($cron_service_ensure)

  #validate_string($redis_server_ensure)

  validate_bool($memcached_install_top_cli)
  validate_integer($memcached_server_max_memory)
  validate_bool($memcached_service_manage)
  #$memcached_server_pkg_ensure

  #$memcached_php_module_handle
  #$memcached_php_module_name
  #$memcached_php_module_ensure

  validate_string($firewall_ssh_port)

  validate_bool($beats_manage)
  validate_string($beats_agentname)
  validate_bool($beats_version_v5)
  validate_bool($beats_filebeats_enable)
  validate_bool($beats_metricbeats_enable)

  validate_hash($beats_filebeats_prospectors_config)
  validate_hash($beats_filebeats_prospectors_config_extra)
  validate_array($beats_hosts)

  # run
  contain ::sugarcrmstack_ng::install
  contain ::sugarcrmstack_ng::config

  Class['sugarcrmstack_ng::install']
  -> Class['sugarcrmstack_ng::config']

  if ($apache_php_enable) {
    contain ::sugarcrmstack_ng::apache_php

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::apache_php']
  }

  if ($mysql_server_enable) {
    contain ::sugarcrmstack_ng::mysql_server

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::mysql_server']
  }

  if ($elasticsearch_server_enable) {
    contain ::sugarcrmstack_ng::elasticsearch_server

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::elasticsearch_server']
  }

  if ($cron_enable){
    contain ::sugarcrmstack_ng::cron

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::cron']
  }

  if ($redis_server_enable){
    contain ::sugarcrmstack_ng::redis_server

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::redis_server']
  }

  if ($memcached_server_enable){
    contain ::sugarcrmstack_ng::memcached_server

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::memcached_server']
  }

  if ($firewall_manage){
    contain ::sugarcrmstack_ng::firewall

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::firewall']
  }

  if ($beats_manage){
    contain ::sugarcrmstack_ng::beats

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::beats']
  }

  if ($users_env_manage){
    contain ::sugarcrmstack_ng::users_env

    Class['sugarcrmstack_ng::config']
    -> Class['sugarcrmstack_ng::users_env']
  }
}
