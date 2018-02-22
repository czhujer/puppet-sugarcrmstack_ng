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
  $apache_php_apache_manage_user = $sugarcrmstack_ng::$apache_php_apache_manage_user,
) {

  if ($users_env_manage){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      $git_config = '[color]
         ui = auto
      [alias]
        co = checkout
        ci = commit
        st = status
        br = branch
        hist = log --pretty=format:\'%h %ad | %s%d [%an]\' --graph --date=short
        type = cat-file -t
        dump = cat-file -p
      '
      $bash_config = '# User specific aliases and functions

        alias rm=\'rm -i\'
        alias cp=\'cp -i\'
        alias mv=\'mv -i\'

        # Source global definitions
        if [ -f /etc/bashrc ]; then
              . /etc/bashrc
        fi

        PS1=\'\[\e[1;32m\]\u@\h \W\$\[\e[0m\] \'

        alias sugarlog=\'tail -f -n 50 /var/www/html/sugarcrm/sugarcrm.log /var/log/httpd/ssl_error_log\'
        alias sugartest=\'cd /var/www/html/sugarcrm/tests/unit-php; php ../../vendor/bin/phpunit --testsuite SugarFactory\'
        alias cdsugar=\'cd /var/www/html/sugarcrm/\'
        alias rebuild-all=\'/var/www/html/Deployer/do rebuild-all\'
        alias rebuild-cache=\'/var/www/html/Deployer/do rebuild-cache\'
        alias xdebugKey=\'f(){ export XDEBUG_CONFIG=ïdekey=$1";  unset -f f; }; f\'
      '

      file { '/root/.gitconfig':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $git_config,
      }

      file { '/root/.bashrc':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $bash_config,
      }


      if($apache_php_apache_manage_user){

        file { '/var/www/.gitconfig':
          ensure  => file,
          owner   => 'apache',
          group   => 'apache',
          mode    => '0644',
          content => $git_config,
        }

        file { '/var/www/.bash_profile':
          ensure  => file,
          owner   => 'apache',
          group   => 'apache',
          mode    => '0644',
          content => $bash_config,
        }

      }
    }
    else{
      fail("Class['sugarcrmstack_ng::users_env']: This class is not compatible with this sugar_version (${sugar_version})")
    }
  }
}
