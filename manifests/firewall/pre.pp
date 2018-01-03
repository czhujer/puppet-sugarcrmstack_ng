# Class: firewall::pre
# ===========================
#
# Full description of class firewall::pre here.
#
# Parameters
# ----------
#
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
  -> firewall { '001 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }
  -> firewall { '002 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }
  -> firewall { "003 accept new tcp to dport ${sugarcrmstack_ng::firewall_ssh_port} / SSH":
    chain  => 'INPUT',
    state  => 'NEW',
    proto  => 'tcp',
    dport  => $sugarcrmstack_ng::firewall_ssh_port,
    action => 'accept',
  }
  -> firewall { '222 reject all forward':
    chain  => 'FORWARD',
    proto  => 'all',
    action => 'reject',
    reject => 'icmp-host-prohibited',
  }
}
