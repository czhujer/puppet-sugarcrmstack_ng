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

  if ($sugar_version == '7.5' or $sugar_version == '7.9'){

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

class sugarcrmstack_ng::firewall::pre {
  Firewall {
    require => undef,
  }
  # Default firewall rules
  firewall { '000 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
  firewall { '001 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '002 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }
  firewall { '003 accept new tcp to dport 22 / SSH':
    chain   => 'INPUT',
    state   => 'NEW',
    proto   => 'tcp',
    dport   => ['22'],
    action  => 'accept',
  }
  firewall { '222 reject all forward':
    chain   => 'FORWARD',
    proto   => 'all',
    action  => 'reject',
    reject => 'icmp-host-prohibited',
  }
}

class sugarcrmstack_ng::firewall::post {
  firewall { '999 reject all':
    proto  => 'all',
    action  => 'reject',
    reject => 'icmp-host-prohibited',
    before => undef,
  }
}
