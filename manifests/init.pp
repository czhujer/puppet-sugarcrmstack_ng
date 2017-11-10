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
  $apache_php_enable = $sugarcrmstack_ng::params::apache_php_enable,
  $mysql_server_enable = $sugarcrmstack_ng::params::mysql_server_enable,
  $elasticsearch_server_enable = $sugarcrmstack_ng::params::elasticsearch_server_enable,
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
  $mysql_server_service_manage = $sugarcrmstack_ng::params::mysql_server_service_manage,
  $mysql_server_service_enabled = $sugarcrmstack_ng::params::mysql_server_service_enabled,
  $mysql_server_service_restart = $sugarcrmstack_ng::params::mysql_server_service_restart,
  $mysql_server_config_max_connections = $sugarcrmstack_ng::params::mysql_server_config_max_connections,
  $mysql_server_use_pxc = $sugarcrmstack_ng::params::mysql_server_use_pxc,
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
) inherits sugarcrmstack_ng::params {

  # validate general parameters
  validate_bool($manage_utils_packages)
  validate_array($utils_packages)

  validate_bool($apache_php_enable)
  validate_bool($mysql_server_enable)
  validate_bool($elasticsearch_server_enable)

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

  # validate mysql_server parameters

  #$mysql_server_service_manage
  #$mysql_server_service_enabled
  #$mysql_server_service_restart
  validate_integer($mysql_server_config_max_connections)
  validate_bool($mysql_server_use_pxc)

  # validate elasticsearch_server parameters

  validate_bool($elasticsearch_server_es_disable_config)
  validate_bool($elasticsearch_server_es_java_install)
  #$elasticsearch_server_es_repo_version
  #$elasticsearch_server_es_version
  validate_bool($elasticsearch_server_es_package_pin)
  validate_hash($elasticsearch_server_es_instance_init_defaults)
  #$elasticsearch_server_es_status
  validate_hash($elasticsearch_server_es_instance_config)

  # run
  if ($apache_php_enable and $mysql_server_enable and $elasticsearch_server_enable){
    class { '::sugarcrmstack_ng::install': }
    -> class { '::sugarcrmstack_ng::config': }
    -> class { '::sugarcrmstack_ng::apache_php': }
    -> class { '::sugarcrmstack_ng::mysql_server': }
    -> class { '::sugarcrmstack_ng::elasticsearch_server': }
    ~> class { '::sugarcrmstack_ng::service': }
    -> Class['::sugarcrmstack_ng']
  }
  elsif ($apache_php_enable and $elasticsearch_server_enable){
    class { '::sugarcrmstack_ng::install': }
    -> class { '::sugarcrmstack_ng::config': }
    -> class { '::sugarcrmstack_ng::apache_php': }
    -> class { '::sugarcrmstack_ng::elasticsearch_server': }
    ~> class { '::sugarcrmstack_ng::service': }
    -> Class['::sugarcrmstack_ng']
  }
  elsif ($mysql_server_enable and $elasticsearch_server_enable){
    class { '::sugarcrmstack_ng::install': }
    -> class { '::sugarcrmstack_ng::config': }
    -> class { '::sugarcrmstack_ng::mysql_server': }
    -> class { '::sugarcrmstack_ng::elasticsearch_server': }
    ~> class { '::sugarcrmstack_ng::service': }
    -> Class['::sugarcrmstack_ng']
  }
  elsif ($apache_php_enable and $mysql_server_enable){
    class { '::sugarcrmstack_ng::install': }
    -> class { '::sugarcrmstack_ng::config': }
    -> class { '::sugarcrmstack_ng::apache_php': }
    -> class { '::sugarcrmstack_ng::mysql_server': }
    ~> class { '::sugarcrmstack_ng::service': }
    -> Class['::sugarcrmstack_ng']
  }
  elsif ($apache_php_enable){
    class { '::sugarcrmstack_ng::install': }
    -> class { '::sugarcrmstack_ng::config': }
    -> class { '::sugarcrmstack_ng::apache_php': }
    ~> class { '::sugarcrmstack_ng::service': }
    -> Class['::sugarcrmstack_ng']
  }
  else{
    class { '::sugarcrmstack_ng::install': }
    -> class { '::sugarcrmstack_ng::config': }
    ~> class { '::sugarcrmstack_ng::service': }
    -> Class['::sugarcrmstack_ng']
  }
}
