# == Class sugarcrmstack_ng::install
#
# This class is called from sugarcrmstack_ng for install.
#
class sugarcrmstack_ng::install {

  # install epel repo
  if ( !defined(Yumrepo['epel']) and !defined(Package['epel-release'])){
    package { 'epel-release':
      ensure => 'installed',
    }
    $require_utils_packages = Package['epel-release']
  }
  else{
    $require_utils_packages = Yumrepo['epel']
  }

  # install remi repo
  if ($::sugarcrmstack_ng::apache_php_enable){
    if ($::operatingsystemmajrelease in ['7']){
      if ( !defined(Yumrepo['remi-php56']) and !defined(Package['remi-release'])){
        package { 'remi-release':
          ensure   => 'installed',
          source   => 'http://rpms.famillecollet.com/enterprise/remi-release-7.rpm',
          provider => 'rpm',
        }
      }
    }
  }

  # install utils packages
  if($::sugarcrmstack_ng::manage_utils_packages){
    package { $::sugarcrmstack_ng::utils_packages:
      ensure => 'installed',
      require => $require_utils_packages,
#                Ini_setting['remi repo exclude packages'],
#                Ini_setting['centos base repo exclude packages 2'],
#                Ini_setting['centos base repo exclude packages'],
    }
  }
}
