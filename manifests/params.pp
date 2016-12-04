# == Class sugarcrmstack_ng::params
#
# This class is meant to be called from sugarcrmstack_ng.
# It sets variables according to platform.
#
class sugarcrmstack_ng::params {
  case $::osfamily {
    'RedHat', 'Amazon': {
      $package_name = 'sugarcrmstack_ng'
      $service_name = 'sugarcrmstack_ng'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
