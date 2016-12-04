# == Class sugarcrmstack_ng::install
#
# This class is called from sugarcrmstack_ng for install.
#
class sugarcrmstack_ng::install {

  if($::sugarcrmstack_ng::manage_utils_packages){
    package { $::sugarcrmstack_ng::utils_packages:
      ensure => 'installed',
#    require => [ Package["epel-repo"],
#                Ini_setting['remi repo exclude packages'],
#                Ini_setting['centos base repo exclude packages 2'],
#                Ini_setting['centos base repo exclude packages'],
#            ]
    }
  }
}
