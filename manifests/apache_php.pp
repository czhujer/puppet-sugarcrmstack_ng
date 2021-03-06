# Class: apache_php
# ===========================
#
# Full description of class apache_php here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::apache_php (
  $apache_php_enable = $sugarcrmstack_ng::apache_php_enable,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $apache_php_php_pkg_version = $sugarcrmstack_ng::apache_php_php_pkg_version,
  $apache_php_php_pkg_build = $sugarcrmstack_ng::apache_php_php_pkg_build,
  $apache_php_php_error_reporting = $sugarcrmstack_ng::apache_php_php_error_reporting,
  $apache_php_apache_https_port = $sugarcrmstack_ng::apache_php_apache_https_port,
  $apache_php_apache_http_port = $sugarcrmstack_ng::apache_php_apache_http_port,
  $apache_php_php_memory_limit = $sugarcrmstack_ng::apache_php_php_memory_limit,
  $apache_php_php_max_execution_time = $sugarcrmstack_ng::apache_php_php_max_execution_time,
  $apache_php_php_upload_max_filesize = $sugarcrmstack_ng::apache_php_php_upload_max_filesize,
  $apache_php_php_post_max_size = $sugarcrmstack_ng::apache_php_php_post_max_size,
  $apache_php_apache_timeout = $sugarcrmstack_ng::apache_php_apache_timeout,
  $apache_php_proxy_timeout = $sugarcrmstack_ng::apache_php_proxy_timeout,
  $apache_php_manage_firewall = $sugarcrmstack_ng::apache_php_manage_firewall,
  $apache_php_apache_http_redirect = $sugarcrmstack_ng::apache_php_apache_http_redirect,
  $apache_php_apache_default_mods =$sugarcrmstack_ng::apache_php_apache_default_mods,
  $apache_php_php_cache_engine = $sugarcrmstack_ng::apache_php_php_cache_engine,
  $apache_php_php_session_save_handler = $sugarcrmstack_ng::apache_php_php_session_save_handler,
  $apache_php_php_session_save_path = $sugarcrmstack_ng::apache_php_php_session_save_path,
  $apache_php_apache_manage_user = $sugarcrmstack_ng::apache_php_apache_manage_user,
  $apache_php_manage_phpmyadmin_config = $sugarcrmstack_ng::apache_php_manage_phpmyadmin_config,
  $apache_php_manage_phpmyadmin_files = $sugarcrmstack_ng::apache_php_manage_phpmyadmin_files,
  $apache_php_xdebug_module_manage   = $sugarcrmstack_ng::apache_php_xdebug_module_manage,
  $apache_php_xdebug_module_ensure   = $sugarcrmstack_ng::apache_php_xdebug_module_ensure,
  $apache_php_xdebug_module_settings = $sugarcrmstack_ng::apache_php_xdebug_module_settings,
  $apache_php_proxy_pass_match        = $sugarcrmstack_ng::apache_php_proxy_pass_match,
  $apache_php_proxy_pass_match_default = $sugarcrmstack_ng::apache_php_proxy_pass_match_default,
  $apache_php_manage_sugarcrm_files_ownership = $sugarcrmstack_ng::apache_php_manage_sugarcrm_files_ownership,
) {

  if ($apache_php_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9' or $sugar_version == '8.0' or $sugar_version == '9.0'){

      if($sugar_version == '8.0' or $sugar_version == '9.0'){
        if empty($apache_php_proxy_pass_match){
          $apache_php_proxy_pass_match_final = $apache_php_proxy_pass_match_default
        }
        else {
          $apache_php_proxy_pass_match_final = $apache_php_proxy_pass_match
        }
      }
      else{
        $apache_php_proxy_pass_match_final = []
      }

      class {'::sugarcrmstack::apachephpng':
        php_pkg_version                 => $apache_php_php_pkg_version,
        php_pkg_build                   => $apache_php_php_pkg_build,
        php_error_reporting             => $apache_php_php_error_reporting,
        apache_https_port               => $apache_php_apache_https_port,
        apache_http_port                => $apache_php_apache_http_port,
        php_memory_limit                => $apache_php_php_memory_limit,
        php_max_execution_time          => $apache_php_php_max_execution_time,
        php_upload_max_filesize         => $apache_php_php_upload_max_filesize,
        php_post_max_size               => $apache_php_php_post_max_size,
        apache_timeout                  => $apache_php_apache_timeout,
        apache_php_proxy_timeout        => $apache_php_proxy_timeout,
        #
        manage_firewall                 => $apache_php_manage_firewall,
        #
        apache_http_redirect            => $apache_php_apache_http_redirect,
        apache_default_mods             => $apache_php_apache_default_mods,
        php_cache_engine                => $apache_php_php_cache_engine,
        php_session_save_handler        => $apache_php_php_session_save_handler,
        php_session_save_path           => $apache_php_php_session_save_path,
        #
        apache_manage_user              => $apache_php_apache_manage_user,
        #
        manage_phpmyadmin_config        => $apache_php_manage_phpmyadmin_config,
        manage_phpmyadmin_files         => $apache_php_manage_phpmyadmin_files,
        #
        xdebug_module_manage            => $apache_php_xdebug_module_manage,
        xdebug_module_ensure            => $apache_php_xdebug_module_ensure,
        xdebug_module_settings          => $apache_php_xdebug_module_settings,
        #
        proxy_pass_match                => $apache_php_proxy_pass_match_final,
        #
        manage_sugarcrm_files_ownership => $apache_php_manage_sugarcrm_files_ownership,

      }
    }
    else{
      fail("Class['sugarcrmstack_ng::apache_php']: This class is compatible only with sugar_version 7.5,7.9,8.0 or 9.0 (not ${sugar_version})")
    }
  }

}
