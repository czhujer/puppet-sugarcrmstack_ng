# == Class sugarcrmstack_ng::params
#
# This class is meant to be called from sugarcrmstack_ng.
# It sets variables according to platform.
#
class sugarcrmstack_ng::params {
  case $::osfamily {
    'RedHat', 'Amazon': {
      $manage_utils_packages = true
      $utils_packages = ["iotop", "iftop", "iptraf", "sysstat", 
	        "zip", "lsscsi", "unzip",
	        "links", "lynx", "policycoreutils-python",
	        "htop", "bind-utils", "wget", "telnet", "lsof",
	        "irqbalance", "vim-minimal", "yum-utils",
	        "traceroute", "vim-enhanced", "hal", "cpuspeed",
	        "numad", "yum-cron", "apachetop", "nano"]
      $package_name = 'sugarcrmstack_ng'
      $service_name = 'sugarcrmstack_ng'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
