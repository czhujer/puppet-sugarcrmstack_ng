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
  $elasticsearch_server_es_disable_config = $sugarcrmstack_ng::elasticsearch_server_es_disable_config,
  $elasticsearch_server_es_java_install = $sugarcrmstack_ng::elasticsearch_server_es_java_install,
  $elasticsearch_server_es_repo_version = $sugarcrmstack_ng::elasticsearch_server_es_repo_version,
  $elasticsearch_server_es_version = $sugarcrmstack_ng::elasticsearch_server_es_version,
  $elasticsearch_server_es_package_pin = $sugarcrmstack_ng::elasticsearch_server_es_package_pin,
  $elasticsearch_server_es_instance_init_defaults = $sugarcrmstack_ng::elasticsearch_server_es_instance_init_defaults,
  $elasticsearch_server_es_status = $sugarcrmstack_ng::elasticsearch_server_es_status,
  $elasticsearch_server_es_restart_on_change = $sugarcrmstack_ng::elasticsearch_server_es_restart_on_change,
  $elasticsearch_server_es_instance_config = $sugarcrmstack_ng::elasticsearch_server_es_instance_config,
  $elasticsearch_server_es_instance_logging_yml_ensure = $sugarcrmstack_ng::elasticsearch_server_es_instance_logging_yml_ensure,
) {

  if ($elasticsearch_server_enable){

    if ($sugar_version == '7.5' or $sugar_version == '7.9' or $sugar_version == '8.0'){

      class { '::elasticsearch':
        version           => $elasticsearch_server_es_version,
        java_install      => $elasticsearch_server_es_java_install,
        package_pin       => $elasticsearch_server_es_package_pin,
        manage_repo       => true,
        repo_version      => $elasticsearch_server_es_repo_version,
        status            => $elasticsearch_server_es_status,
        restart_on_change => $elasticsearch_server_es_restart_on_change,
        datadir           => '/var/lib/elasticsearch/data',
      }

      unless($elasticsearch_server_es_disable_config){
        ::elasticsearch::instance { 'elasticsearch':
          config             => $elasticsearch_server_es_instance_config,
          init_defaults      => $elasticsearch_server_es_instance_init_defaults,
          logging_yml_ensure => $elasticsearch_server_es_instance_logging_yml_ensure,
        }
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::elasticsearch_server']: This class is not compatible with this sugar_version (${sugar_version})")
    }
  }
}
