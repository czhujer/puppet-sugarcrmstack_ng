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
) inherits sugarcrmstack_ng::params {

  # validate parameters
  validate_bool($cli)

  validate_bool($cli)

  # run
  if ($apache_php_enable and $mysql_server_enable){
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
