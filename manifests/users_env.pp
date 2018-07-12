# Class: users_env
# ===========================
#
# Full description of class users_env here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::users_env (
  $users_env_manage = $sugarcrmstack_ng::users_env_manage,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $apache_php_apache_manage_user = $sugarcrmstack_ng::apache_php_apache_manage_user,
  $apache_mysql_config_manage    = $sugarcrmstack_ng::apache_mysql_config_manage,
) {

  if ($users_env_manage){

    if ($sugar_version == '7.5' or $sugar_version == '7.9' or $sugar_version == '8.0'){

      file { '/root/.gitconfig':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('sugarcrmstack_ng/user_git_config.erb'),
      }

      file { '/root/.bashrc':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('sugarcrmstack_ng/user_bash_config.erb'),
      }


      unless($apache_php_apache_manage_user){

        file { '/var/www/.gitconfig':
          ensure  => file,
          owner   => 'apache',
          group   => 'apache',
          mode    => '0644',
          content => template('sugarcrmstack_ng/user_git_config.erb'),
        }

        file { '/var/www/.bash_profile':
          ensure  => file,
          owner   => 'apache',
          group   => 'apache',
          mode    => '0644',
          content => template('sugarcrmstack_ng/user_bash_config.erb'),
        }
      }

      if($apache_mysql_config_manage){
        file { '/var/www/.my.cnf':
          content => template('sugarcrmstack_ng/my.cnf.pass.erb'),
          owner   => 'apache',
          group   => 'apache',
          mode    => '0600',
        }
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::users_env']: This class is not compatible with this sugar_version (${sugar_version})")
    }
  }
}
