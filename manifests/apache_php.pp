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
) inherits sugarcrmstack_ng::params {

  if ($::sugarcrmstack_ng::apache_php_enable){

    if ($::sugarcrmstack_ng::sugar_version == "7.5" or $::sugarcrmstack_ng::sugar_version == "7.9"){

      class {'::sugarcrmstack::apachephpng':
        php_pkg_version          => $::sugarcrmstack_ng::params::apache_php_php_pkg_version,
        php_pkg_build            => $::sugarcrmstack_ng::params::apache_php_php_pkg_build,
        php_error_reporting      => $::sugarcrmstack_ng::params::apache_php_php_error_reporting,
        apache_https_port        => $::sugarcrmstack_ng::params::apache_php_apache_https_port,
        apache_http_port         => $::sugarcrmstack_ng::params::apache_php_apache_http_port,
        php_memory_limit         => $::sugarcrmstack_ng::params::apache_php_php_memory_limit,
        php_max_execution_time   => $::sugarcrmstack_ng::params::apache_php_php_max_execution_time,
        php_upload_max_filesize  => $::sugarcrmstack_ng::params::apache_php_php_upload_max_filesize,
        manage_firewall          => $::sugarcrmstack_ng::params::apache_php_manage_firewall,
        #
        apache_http_redirect     => $::sugarcrmstack_ng::params::apache_php_apache_http_redirect,
        apache_default_mods      => $::sugarcrmstack_ng::params::apache_php_apache_default_mods,
        php_cache_engine         => $::sugarcrmstack_ng::params::apache_php_php_cache_engine,
        php_session_save_handler => $::sugarcrmstack_ng::params::apache_php_php_session_save_handler,
        php_session_save_path    => $::sugarcrmstack_ng::params::apache_php_php_session_save_path,
        #
        apache_manage_user       => $::sugarcrmstack_ng::params::apache_php_apache_manage_user
      }
    }
    else{
      fail("Class['sugarcrmstack_ng::apache_php']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugarcrmstack_ng::sugar_version})")
    }
  }

}
