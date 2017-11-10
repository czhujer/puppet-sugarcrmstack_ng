# Class: elasticsearch_server
# ===========================
#
# Full description of class elasticsearch_server here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::elasticsearch_server (
  $elasticsearch_server_enable = $sugarcrmstack_ng::elasticsearch_server_enable,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
) {

  if ($elasticsearch_server_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){


    }
    else{
      fail("Class['sugarcrmstack_ng::elasticsearch_server']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
    }
  }
}
