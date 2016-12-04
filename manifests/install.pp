# == Class sugarcrmstack_ng::install
#
# This class is called from sugarcrmstack_ng for install.
#
class sugarcrmstack_ng::install {

  package { $::sugarcrmstack_ng::package_name:
    ensure => present,
  }
}
