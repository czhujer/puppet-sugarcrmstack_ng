# Class: memcached_server
# ===========================
#
# Full description of class memcached_server here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::memcached_server (
  $memcached_server_enable = $sugarcrmstack_ng::memcached_server_enable,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $memcached_install_top_cli = $sugarcrmstack_ng::memcached_install_top_cli,
  $memcached_server_max_memory = $sugarcrmstack_ng::memcached_server_max_memory,
  $memcached_service_manage = $sugarcrmstack_ng::memcached_service_manage,
  $memcached_server_pkg_ensure = $sugarcrmstack_ng::memcached_server_pkg_ensure,
) {

  if ($memcached_server_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

        class { '::memcached':
            max_memory     => $memcached_server_max_memory,
            listen_ip      => '127.0.0.1',
            package_ensure => $memcached_server_pkg_ensure,
            service_manage => $memcached_service_manage,
        }

#        if($memcached_module_suffix == "memcache"){
#            $memcache_module_name = "${memcache_module_prefix}-pecl-memcache"
#            $memcache_module_name2 = "${memcache_module_prefix}-pecl-memcached"
#        }
#        elsif($memcached_module_suffix == "memcached"){
#            $memcache_module_name = "${memcache_module_prefix}-pecl-memcached"
#            $memcache_module_name2 = "${memcache_module_prefix}-pecl-memcache"
#
#            package { "libmemcached-last":
#                ensure   => "installed",
#                require  => $pkg_require,
#                before   => Package[$memcache_module_name],
#            }
#
#        }
#        else{
#            warning "Unsupported suffix for memcached library support"
#            warning "Please install php module manualy"
#        }

#        package { $memcache_module_name:
#                ensure   => "installed",
#                require  => $pkg_require,
#                notify   => Service["httpd"],
#        }

#        package { $memcache_module_name2:
#                ensure   => "absent",
#                require  => $pkg_require,
#                notify   => Service["httpd"],
#        }

    }
    else{
      fail("Class['sugarcrmstack_ng::memcached_server']: This class is not compatible with this sugar_version (${sugar_version})")
    }
  }

  if ($memcached_install_top_cli){

    package { 'perl-Time-HiRes':
      ensure => installed,
    }

    if !defined(File['/root/scripts']) {
      file { '/root/scripts':
        ensure  => directory,
        mode    => '0755',
        group   => 'root',
        owner   => 'root',
      }
    }

    file { 'memcache-top':
      ensure  => present,
      path    => '/root/scripts/memcache-top-v0.6',
      content => template('sugarcrmstack_ng/memcache-top-v0.6.erb'),
      recurse => true,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => File['/root/scripts'],
    }
  }
}