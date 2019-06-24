# Class: beats
# ===========================
#
# Full description of class beats here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng::beats (
  $beats_manage = $sugarcrmstack_ng::beats_manage,
  $sugar_version = $sugarcrmstack_ng::sugar_version,
  #
  $beats_agentname = $sugarcrmstack_ng::beats_agentname,
  $beats_version_v5 = $sugarcrmstack_ng::beats_version_v5,
  $beats_filebeats_enable = $sugarcrmstack_ng::beats_filebeats_enable,
  $beats_metricbeats_enable = $sugarcrmstack_ng::beats_metricbeats_enable,
  #
  $beats_filebeats_prospectors_config = $sugarcrmstack_ng::beats_filebeats_prospectors_config,
  $beats_filebeats_prospectors_config_extra = $sugarcrmstack_ng::beats_filebeats_prospectors_config_extra,
  $beats_hosts = $sugarcrmstack_ng::beats_hosts,
  #
  $beats_manage_geoip = $sugarcrmstack_ng::beats_manage_geoip,
  $beats_manage_repo = $sugarcrmstack_ng::beats_manage_repo,
) {

  if ($beats_manage){

    if ($sugar_version == '7.5' or $sugar_version == '7.9' or $sugar_version == '8.0' or $sugar_version == '9.0'){

      if ($beats_filebeats_enable){
        $outputs_logstash_file = { 'filebeat' => { 'hosts' => $beats_hosts, 'use_tls' => true, } }
      }
      else {
        $outputs_logstash_file = {}
      }

      if ($beats_metricbeats_enable){
        $outputs_logstash_top = { 'metricbeat' => { 'hosts' => $beats_hosts, 'use_tls' => true, } }
      }
      else {
        $outputs_logstash_top = {}
      }

      class { '::beats':
        outputs_deep_merge => false,
        outputs_logstash   => deep_merge($outputs_logstash_file, $outputs_logstash_top),
        agentname          => $beats_agentname,
        version_v5         => $beats_version_v5,
        manage_geoip       => $beats_manage_geoip,
        manage_repo        => $beats_manage_repo,
      }

      if ($beats_filebeats_enable){

        $filebeats_prospectors_config_final = deep_merge($beats_filebeats_prospectors_config_extra, $beats_filebeats_prospectors_config)

        class { '::beats::filebeat':
          prospectors => $filebeats_prospectors_config_final,
          version_v5  => $beats_version_v5,
        }

      }
      else{
        class { '::beats::filebeat':
          ensure => 'absent',
        }
      }

      if ($beats_metricbeats_enable){
        class { '::beats::metricbeat':
        }
      }
      else{
        class { '::beats::metricbeat':
          ensure => 'absent',
        }
      }

    }
    else{
      fail("Class['sugarcrmstack_ng::beats']: This class is compatible only with sugar_version 7.5,7.9,8.0 or 9.0 (not ${sugar_version})")
    }
  }
}
