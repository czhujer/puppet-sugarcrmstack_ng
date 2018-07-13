# Class: monitoring::pmm_client
# ===========================
#
# Full description of class monitoring::pmm_client here.
#
# Parameters
# ----------
#
class sugarcrmstack_ng::monitoring::pmm_client (
  $manage_firewall = true,
  $manage_package = true,
  $manage_repo_package = true,
  ){

  # validate general parameters
  validate_bool($manage_firewall)
  validate_bool($manage_package)
  validate_bool($manage_repo_package)

  if($manage_repo_package){
    package { 'percona-release':
      name     => 'percona-release',
      ensure   => 'installed',
      provider => 'rpm',
      source   => 'http://repo.percona.com/release/centos/latest/os/noarch/percona-release-0.1-6.noarch.rpm',
    }
  }

  if($manage_package){
    package { 'pmm-client':
      ensure  => 'installed',
      require => Package['percona-release'],
    }
  }


  if($manage_firewall){
    firewall { '112 accept tcp to dports 42000:42004 / sf-pmm-s2':
      chain   => 'INPUT',
      state   => 'NEW',
      proto   => 'tcp',
      dport   => ['42000','42001','42002','42003','42004'],
      source  => '192.168.127.0/24',
      action  => 'accept',
    }
  }
}
