class sugarcrmstack_ng::apache_php (
) inherits sugarcrmstack_ng::params {

  if ($::sugarcrmstack_ng::apache_php_enable){

    if ($::sugarcrmstack_ng::sugar_version == "7.5" or $::sugarcrmstack_ng::sugar_version == "7.9"){

      class {'sugarcrmstack::apachephpng':
        php_pkg_version => "5.6.31",
        php_pkg_build   => "1",
        php_error_reporting => "E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE & ~E_WARNING",
        apache_https_port => "443",
        apache_http_port => "80",
        php_memory_limit => "1024M",
        php_max_execution_time => '300',
        php_upload_max_filesize => "100M",
        manage_firewall => false,
        #
        apache_http_redirect => true,
        apache_default_mods => [ "actions", "authn_core", "cache", "ext_filter", "mime", "mime_magic", "rewrite", "speling", "suexec", "version", "vhost_alias", "auth_digest", "authn_anon", "authn_dbm", "authz_dbm", "authz_owner", "expires", "include", "logio", "substitute", "usertrack", "authn_alias", "authn_default", "alias", "authn_file", "autoindex", "dav", "dav_fs", "dir", "negotiation", "setenvif", "auth_basic", "authz_user", "authz_groupfile", "env", "authz_default",],
        php_cache_engine         => "opcache+apcu",
        #php_session_save_handler => 'redis',
        #php_session_save_path    => 'tcp://127.0.0.1:6379',
        #
        #apache_manage_user       => false,
      }
    }
    else{
      fail("Class['sugarcrmstack_ng::apache_php']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugarcrmstack_ng::sugar_version})")
    }
  }

}
