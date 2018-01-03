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
  $beats_filebeats_enable = $sugarcrmstack_ng::filebeats_enable,
  $beats_metricbeats_enable = $sugarcrmstack_ng::metricbeats_enable,
  #
  $beats_filebeats_prospectors_config = $sugarcrmstack_ng::beats_filebeats_prospectors_config,
  $beats_hosts = $sugarcrmstack_ng::beats_hosts,
) {

  if ($beats_manage){

    if ($sugar_version == '7.5' or $sugar_version == '7.9'){

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
      }

      if ($beats_filebeats_enable){

        $filebeats_prospectors_config_default = {
              'syslog' => {
                  'document_type' => "syslog",
                  'paths'  => [ "/var/log/messages",
                                "/var/log/secure",
                                "/var/log/yum.log",
                                "/var/log/cron",
                                "/var/log/maillog",
                                "/var/log/ntp",
                                "/var/log/zabbix/zabbix_agentd2.log",
                              ],
              },
              'log'   => {
                  'fields' => { 'document_type' => "log" },
                  'paths'  => [
                                  "/var/log/jenkins-slave/jenkins-slave.log",
                                  "/var/log/memcached.log",
                                  "/var/log/zabbix/zabbix_agentd.log",
                              ],
              },
              'es_log' => {
                  'document_type' => "es_log",
                  'paths'  => [
                                  "/var/log/elasticsearch/elasticsearch/*.log",
                              ],
                  'multiline' => {
#                                  "pattern" => "^[[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}",
                                  "pattern" => "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2},[[:digit:]]{3}",
                                  "negate" => "true",
                                  "match"  => "after",
                  },
              },
              'mysqld'  => {
                  'document_type' => "mysqld",
                  'paths'  => [ "/var/log/mysqld.log", ],
              },
              'mysql_slow_log' => {
                  'document_type' => "mysql_slow_log",
                  'paths'  => [
                                  "/var/log/mysql-slow.log",
                              ],
                  'multiline' => {
#                                  "pattern" => "^# Time: [[:digit:]]{6}[[:blank:]]{1,2}[[:digit:]]{1,2}:[[:digit:]]{2}:[[:digit:]]{2}",
                                  "pattern" => "^(# (Time: [[:digit:]]{6}[[:blank:]]{1,2}[[:digit:]]{1,2}:[[:digit:]]{2}:[[:digit:]]{2})|(User@Host: sugarcrm))",
                                  "negate" => "true",
                                  "match"  => "after",
                  },
              },
              'mysql_slow_log2' => {
                  'document_type' => "mysql_slow_log2",
                  'paths'  => [
                                  "/var/lib/mysql/mysql/slow_log.CSV",
                              ],
              },
              'nginx-access'  => {
                  'document_type' => "nginx-access",
                  'paths'  => [
                                   "/var/log/nginx/*.access.log",
                                   "/var/log/nginx/access.log",
                              ],
              },
              'nginx-error'  => {
                  'document_type' => "nginx-error",
                  'paths'  => [
                                  "/var/log/nginx/*.error.log",
                                  "/var/log/nginx/error.log",
                              ],
              },
              'apache' => {
                  'document_type' => "apache",
                  'paths'  => [
                                  "/var/log/httpd/*access.log",
                                  "/var/log/httpd/*access_log",
                              ],
              },
              'apache-error' => {
                  'document_type' => "apache-error",
                  'paths'  => [
                                  "/var/log/httpd/*error.log",
                                  "/var/log/httpd/*error_log",
                              ],
              },
              'sugar_cron_log'   => {
                  'document_type' => "sugar-cron-log",
                  'paths'  => [ "/var/www/html/sugarcrm/sugar-cron.log" ],
                  'multiline' => {
                                  "pattern" => "^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}",
                                  "negate" => "true",
                                  "match"  => "after",
                  },
              },
              'sugar_log'   => {
                  'document_type' => "sugar-log",
                  'paths'  => [
                                "/var/www/html/sugarcrm/sugarcrm.log",
                                "/var/www/html/sugarcrm/sugarcrm*2016*.log",
                                "/var/www/html/sugarcrm/suitecrm.log",
                                "/var/www/sugarcrm.log",
                               ],
                  'multiline' => {
                                  "pattern" => "^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}[[:blank:]][[:digit:]]{4}",
                                  "negate" => "true",
                                  "match"  => "after",
                  },
              },
              'sugar_pmse_log'   => {
                  'document_type' => "sugar-pmse-log",
                  'paths'  => [
                                "/var/www/html/sugarcrm/PMSE.log",
                               ],
                  'multiline' => {
                                  "pattern" => "^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}[[:blank:]][[:digit:]]{4}",
                                  "negate" => "true",
                                  "match"  => "after",
                  },
              },
              'redis' => {
                  'document_type' => "redis",
                  'paths'  => [
                                 "/var/log/redis/redis.log",
                              ],
              },
              'back2own_duplicity'  => {
                  'document_type' => "back2own_duplicity",
                  'paths'  => [ "/var/log/back2own-duplicity.log", ],
              },
        }

        $filebeats_prospectors_config_final = deep_merge($beats_filebeats_prospectors_config, $filebeats_prospectors_config_default)

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
      fail("Class['sugarcrmstack_ng::beats']: This class is compatible only with sugar_version 7.5 or 7.9 (not ${sugar_version})")
    }
  }
}
