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
  $elasticsearch_server_elasticsearch_disable_config = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_disable_config,
  $elasticsearch_server_elasticsearch_java_install = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_java_install,
  $elasticsearch_server_elasticsearch_repo_version = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_repo_version,
  $elasticsearch_server_elasticsearch_version = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_version,
  $elasticsearch_server_elasticsearch_package_pin = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_package_pin,
  $elasticsearch_server_elasticsearch_instance_init_defaults = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_instance_init_defaults,
  $elasticsearch_server_elasticsearch_status = $sugarcrmstack_ng::elasticsearch_server_elasticsearch_status,
) {

  if ($elasticsearch_server_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

      class { 'sugarcrmstack::elasticsearchserver':
        elasticsearch_server_enable          => $elasticsearch_server_enable,
        #
        sugar_version                        => $sugar_version,
        #
        elasticsearch_disable_config         => $elasticsearch_server_elasticsearch_disable_config,
        elasticsearch_java_install           => $elasticsearch_server_elasticsearch_java_install,
        elasticsearch_repo_version           => $elasticsearch_server_elasticsearch_repo_version,
        elasticsearch_version                => $elasticsearch_server_elasticsearch_version,
        elasticsearch_package_pin            => $elasticsearch_server_elasticsearch_package_pin,
        elasticsearch_instance_init_defaults => $elasticsearch_server_elasticsearch_instance_init_defaults,
        elasticsearch_status                 => $elasticsearch_server_elasticsearch_status,
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::elasticsearch_server']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
    }
  }
}
