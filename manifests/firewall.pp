# Class: firewall
# ===========================
#
# Full description of class firewall here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::firewall (
  $firewall_manage = $sugarcrmstack_ng::firewall_manage,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $firewall_ssh_port = $sugarcrmstack_ng::firewall_ssh_port,
) {

  #include ::sugarcrmstack_ng::firewall::pre
  #include ::sugarcrmstack_ng::firewall::post

  if ($sugar_version == '7.5' or $sugar_version == '7.9' or $sugar_version == '8.0' or $sugar_version == '9.0'){

    if ($firewall_manage) {
      resources { 'firewall':
        purge => true,
      }

      class { ['::sugarcrmstack_ng::firewall::pre', '::sugarcrmstack_ng::firewall::post']: }

      Firewall {
        before  => Class['::sugarcrmstack_ng::firewall::post'],
        require => Class['::sugarcrmstack_ng::firewall::pre'],
      }
    }
  }
  else{
      fail("Class['sugarcrmstack_ng::firewall']: This class is not compatible with this sugar_version (${sugar_version})")
  }

}
