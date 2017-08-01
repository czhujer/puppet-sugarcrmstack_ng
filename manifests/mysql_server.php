# Class: mysql_server
# ===========================
#
# Full description of class mysql_server here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::mysql_server (
  $mysql_server_enable = $::sugarcrmstack_ng::params::mysql_server_enable,
  $sugar_version = $::sugarcrmstack_ng::params::sugar_version,
) inherits sugarcrmstack_ng::params {

  if ($apache_php_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      #class {'::sugarcrmstack::mysqlserver':
      #}
    }
    else{
      fail("Class['sugarcrmstack_ng::mysql_server']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
    }
  }
}
