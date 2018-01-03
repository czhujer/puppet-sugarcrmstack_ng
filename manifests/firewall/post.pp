# Class: firewall::post
# ===========================
#
# Full description of class firewall:post here.
#
# Parameters
# ----------
#
class sugarcrmstack_ng::firewall::post {
  firewall { '999 reject all':
    proto  => 'all',
    action  => 'reject',
    reject => 'icmp-host-prohibited',
    before => undef,
  }
}
