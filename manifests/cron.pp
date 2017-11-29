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
) {

  if ($cron_server_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      case $operatingsystem {
        ubuntu: {$package_name = 'cron' $service_name = 'cron'}
        gentoo: {$package_name = 'vixie-cron' $service_name = 'vixie-cron' $hasstatus = 'false' $status = 'pgrep cron'}
        redhat, scientific, centos: {$package_name = 'crontabs' $service_name = 'crond'}
        default: {fail('Unable to find appropriate cron package for this OS.')}
      }

      if ($cron_handle_package){
        package {'cron':
          ensure => 'present',
          name   => $package_name,
        }
      }

      service {'cron':
        enable  => $enable,
        ensure  => $ensure,
        name    => $service_name,
        require => Package['cron'],
      }

      $cron_content = '#* * * * * apache cd /var/www/html/sugarcrm; php -f cron.php > /dev/null 2>&1
'
      $cron_content_final = "${cron_content}#*    *    *    *    *  apache   echo `date` >> /var/www/html/sugarcrm/sugar-cron.log 2>&1; cd /var/www/html/sugarcrm; php -f cron.php >> /var/www/html/sugarcrm/sugar-cron.log 2>&1
"
      $cron_content_final2 = '*    *    *    *    *  apache   hash=$(openssl rand -base64 6 2>/dev/null); file="/var/www/html/sugarcrm/sugar-cron.log"; echo "`date` STARTED $hash" >> $file 2>&1; cd /var/www/html/sugarcrm; timeout 600 php -f cron.php >> $file 2>&1; echo "`date` STOPPED $hash" >> $file 2>&1;
'

      if ($cron_handle_sugarcrm_file){
        file {'sugar cron file':
          name    => '/etc/cron.d/sugarcrm',
          content => "${cron_content_final} ${cron_content_final2}",
          require => Package['cron'],
          notify  => Service['cron'],
        }
      }
      else{
        file {'sugar cron file':
          name => "/etc/cron.d/sugarcrm",
          ensure => "absent",
          require => Package["cron"],
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
