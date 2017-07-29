# == Class sugarcrmstack_ng::config
#
# This class is called from sugarcrmstack_ng for service config.
#
class sugarcrmstack_ng::config {

  #enable remi-php56 repo
  if ($::sugarcrmstack_ng::apache_php_enable){
    if ($::operatingsystemmajrelease in ['7']){
      if ( defined(Yumrepo['remi-php56']) ){
        warning('Possible override of value "enable" in repo remi-php56')
      }

      ini_setting { 'enable remi-php56 repo':
        ensure  => present,
        path    => '/etc/yum.repos.d/remi.repo',
        section => 'remi-php56',
        setting => 'enabled',
        value   => '1',
      }
    
    }
  }

}
