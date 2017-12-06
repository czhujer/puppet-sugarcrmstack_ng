# Class: cron
# ===========================
#
# Full description of class cron here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::cron (
  $cron_enable = $sugarcrmstack_ng::cron_enable,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $cron_handle_package = $sugarcrmstack_ng::cron_handle_package,
  $cron_handle_sugarcrm_file = $sugarcrmstack_ng::cron_handle_sugarcrm_file,
  $cron_purge_users_crontabs = $sugarcrmstack_ng::cron_purge_users_crontabs,
  #
  $cron_service_enable = $sugarcrmstack_ng::cron_service_enable,
  $cron_service_ensure = $sugarcrmstack_ng::cron_service_ensure,
) {

  if ($cron_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      case $::operatingsystem {
        'redhat', 'scientific', 'centos': {$package_name = 'crontabs' $service_name = 'crond'}
        default: {fail('Unable to find appropriate cron package for this OS.')}
      }

      if ($cron_handle_package){
        package {'cron':
          ensure => 'present',
          name   => $package_name,
        }
      }

      service {'cron':
        enable  => $cron_service_enable,
        ensure  => $cron_service_ensure,
        name    => $service_name,
        require => Package['cron'],
      }

      if ($cron_handle_sugarcrm_file){
        file {'sugar cron file':
          name    => '/etc/cron.d/sugarcrm',
          content => template('sugarcrmstack_ng/cron.sugarcrm.erb'),
          require => Package['cron'],
          notify  => Service['cron'],
        }
      }
      else{
        file {'sugar cron file':
          ensure  => absent,
          name    => '/etc/cron.d/sugarcrm',
          require => Package['cron'],
          notify  => Service['cron'],
        }
      }

      if ($cron_purge_users_crontabs){
        # disable user crons
        file {['/var/spool/cron/root', '/var/spool/cron/apache']:
          ensure  => absent,
          require => Package['cron'],
          notify  => Service['cron'],
        }
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::cron']: This class is not compatible with this sugar_version (${sugar_version})")
    }
  }
}
