# Class: redis_server
# ===========================
#
# Full description of class redis_server here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::redis_server (
  $redis_server_enable = $sugarcrmstack_ng::redis_server_enable,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $ensure = $sugarcrmstack_ng::redis_server_ensure,
) {

  if ($redis_server_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      class { 'redis':
        bind           => '127.0.0.1',
        package_ensure => $ensure,
      }
    }
    else{
      fail("Class['sugarcrmstack_ng::redis_server']: This class is not compatible with this sugar_version (${sugar_version})")
    }
  }
}
