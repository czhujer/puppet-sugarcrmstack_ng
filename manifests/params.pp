# == Class sugarcrmstack_ng::params
#
# This class is meant to be called from sugarcrmstack_ng.
# It sets variables according to platform.
#
class sugarcrmstack_ng::params {
  $apache_php_enable = true
  $mysql_server_enable = false
  $elasticsearch_server_enable = false
  $cron_enable       = false
  $redis_server_enable = false
  $memcached_server_enable = false
  $firewall_manage = false
  $beats_manage = false
  $users_env_manage = false
  $apache_mysql_config_manage = false
  $sugar_version     = '7.9'
  case $::osfamily {
    'RedHat', 'Amazon': {
      $manage_utils_packages = true

      if ($::operatingsystemmajrelease in ['7']){
        $utils_packages = ['iotop', 'iftop', 'iptraf', 'sysstat',
                'zip', 'lsscsi', 'unzip',
                'links', 'lynx', 'policycoreutils-python',
                'htop', 'bind-utils', 'wget', 'telnet', 'lsof',
                'irqbalance', 'vim-minimal', 'yum-utils',
                'traceroute', 'vim-enhanced', 'net-tools',
                'numad', 'yum-cron', 'apachetop', 'nano', 'nc', 'lftp']

        $apache_php_apache_default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter', 'mime', 'mime_magic', 'rewrite', 'speling',
                                      'version', 'vhost_alias', 'auth_digest', 'authn_anon', 'authn_dbm', 'authz_dbm', 'authz_owner',
                                      'expires', 'include', 'logio', 'substitute', 'usertrack', 'alias',
                                      'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir', 'negotiation', 'setenvif', 'auth_basic',
                                      'authz_user', 'authz_groupfile', 'env', 'suexec']

        $apache_php_php_pkg_version = '5.6.36'
        $apache_php_php_pkg_build = '1'

        $apache_php_proxy_pass_match = []
        $apache_php_proxy_pass_match_default = [ {
          'path' => '^/phpmyadmin/(.*\.php)$',
          'url'  => 'fcgi://127.0.0.1:9002/usr/share/phpMyAdmin/$1',
          },{
          'path' => '/phpmyadmin(.*/)$',
          'url'  => 'fcgi://127.0.0.1:9002/usr/share/phpMyAdmin$1index.php'
          },{
          'path' => '^/phpMyAdmin/(.*\.php)$',
          'url'  => 'fcgi://127.0.0.1:9002/usr/share/phpmyadmin/$1'
          },{
          'path' => '^/phpMyAdmin(.*/)$',
          'url'  => 'fcgi://127.0.0.1:9002/usr/share/phpMyAdmin$1index.php'
          },{
          'path' => '^/(.*\.php(/.*)?)$',
          'url'  => 'fcgi://127.0.0.1:9001/var/www/html/sugarcrm/$1'
          },
        ]

        $memcached_php_module_name = 'php-pecl-memcache'

        $beats_filebeats_prospectors_config = {
              'syslog' => {
                  'document_type' => 'syslog',
                  'paths'  => [ '/var/log/messages',
                                '/var/log/secure',
                                '/var/log/yum.log',
                                '/var/log/cron',
                                '/var/log/maillog',
                                '/var/log/ntp',
                                '/var/log/zabbix/zabbix_agentd2.log',
                              ],
              },
              'log'   => {
                  'fields' => { 'document_type' => 'log' },
                  'paths'  => [
                                  '/var/log/jenkins-slave/jenkins-slave.log',
                                  '/var/log/memcached.log',
                                  '/var/log/zabbix/zabbix_agentd.log',
                              ],
              },
              'es_log' => {
                  'document_type' => 'es_log',
                  'paths'  => [
                                  '/var/log/elasticsearch/elasticsearch/*.log',
                              ],
                  'multiline' => {
#                                  "pattern" => "^[[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}",
                                  'pattern' => '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2},[[:digit:]]{3}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'mysqld'  => {
                  'document_type' => 'mysqld',
                  'paths'  => [
                    '/var/log/mysqld.log',
                    '/var/log/mariadb/mariadb.log',
                ],
              },
              'php-fpm-error-c7' => {
                'document_type' => 'php-fpm-error-c7',
                'paths'  => [
                  '/var/log/php-fpm/error.log',
                  '/var/log/php-fpm/phpmyadmin-error.log',
                  '/var/log/php-fpm/www-error.log',
                ],
                'multiline' => {
                                'pattern' => '^\\\[\\\d{2}-\\\w{3}-\\\d{4} \\\d{2}:\\\d{2}:\\\d{2}',
                                'negate' => true,
                                'match'  => 'after',
                },
              },
              'mysql_slow_log' => {
                  'document_type' => 'mysql_slow_log',
                  'paths'  => [
                                  '/var/log/mysql-slow.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^# User@Host: ',
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              #'mysql_slow_log2' => {
              #    'document_type' => 'mysql_slow_log2',
              #    'paths'  => [
              #                    '/var/lib/mysql/mysql/slow_log.CSV',
              #                ],
              #},
              'nginx-access'  => {
                  'document_type' => 'nginx-access',
                  'paths'  => [
                                  '/var/log/nginx/*.access.log',
                                  '/var/log/nginx/access.log',
                              ],
              },
              'nginx-error'  => {
                  'document_type' => 'nginx-error',
                  'paths'  => [
                                  '/var/log/nginx/*.error.log',
                                  '/var/log/nginx/error.log',
                              ],
              },
              'apache' => {
                  'document_type' => 'apache',
                  'paths'  => [
                                  '/var/log/httpd/*access.log',
                                  '/var/log/httpd/*access_log',
                              ],
              },
              'apache-error-c7' => {
                  'document_type' => 'apache-error-c7',
                  'paths'  => [
                                  '/var/log/httpd/*error.log',
                                  '/var/log/httpd/*error_log',
                              ],
              },
              'sugar_cron_log'   => {
                  'document_type' => 'sugar-cron-log',
                  'paths'  => [ '/var/www/html/sugarcrm/sugar-cron.log',
                                '/var/log/sugarcrm/sugar-cron.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'sugar_log'   => {
                  'document_type' => 'sugar-log',
                  'paths'  => [
                                  '/var/www/html/sugarcrm/sugarcrm.log',
                                  '/var/www/html/sugarcrm/suitecrm.log',
                                  '/var/www/sugarcrm.log',
                                  '/var/log/sugarcrm/sugarcrm.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}[[:blank:]][[:digit:]]{4}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'sugar_pmse_log'   => {
                  'document_type' => 'sugar-pmse-log',
                  'paths'  => [
                                  '/var/www/html/sugarcrm/PMSE.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}[[:blank:]][[:digit:]]{4}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'redis' => {
                  'document_type' => 'redis',
                  'paths'  => [
                                  '/var/log/redis/redis.log',
                              ],
              },
              'back2own_duplicity'  => {
                  'document_type' => 'back2own_duplicity',
                  'paths'  => [ '/var/log/back2own-duplicity.log', ],
              },
        }
      }
      else{
        $utils_packages = ['iotop', 'iftop', 'iptraf', 'sysstat',
                'zip', 'lsscsi', 'unzip',
                'links', 'lynx', 'policycoreutils-python',
                'htop', 'bind-utils', 'wget', 'telnet', 'lsof',
                'irqbalance', 'vim-minimal', 'yum-utils',
                'traceroute', 'vim-enhanced', 'hal', 'cpuspeed',
                'numad', 'yum-cron', 'apachetop', 'nano', 'nc']

        $apache_php_apache_default_mods = [ 'actions', 'authn_core', 'cache', 'ext_filter', 'mime', 'mime_magic', 'rewrite', 'speling',
                                      'version', 'vhost_alias', 'auth_digest', 'authn_anon', 'authn_dbm', 'authz_dbm', 'authz_owner',
                                      'expires', 'include', 'logio', 'substitute', 'usertrack', 'authn_alias', 'authn_default', 'alias',
                                      'authn_file', 'autoindex', 'dav', 'dav_fs', 'dir', 'negotiation', 'setenvif', 'auth_basic',
                                      'authz_user', 'authz_groupfile', 'env', 'authz_default', 'suexec']

        $apache_php_php_pkg_version = '5.6.36'
        $apache_php_php_pkg_build = '1'

        $apache_php_proxy_pass_match = []
        $apache_php_proxy_pass_match_default = []

        $memcached_php_module_name = 'php56u-pecl-memcache'

        $beats_filebeats_prospectors_config = {
              'syslog' => {
                  'document_type' => 'syslog',
                  'paths'  => [ '/var/log/messages',
                                '/var/log/secure',
                                '/var/log/yum.log',
                                '/var/log/cron',
                                '/var/log/maillog',
                                '/var/log/ntp',
                                '/var/log/zabbix/zabbix_agentd2.log',
                              ],
              },
              'log'   => {
                  'fields' => { 'document_type' => 'log' },
                  'paths'  => [
                                  '/var/log/jenkins-slave/jenkins-slave.log',
                                  '/var/log/memcached.log',
                                  '/var/log/zabbix/zabbix_agentd.log',
                              ],
              },
              'es_log' => {
                  'document_type' => 'es_log',
                  'paths'  => [
                                  '/var/log/elasticsearch/elasticsearch/*.log',
                              ],
                  'multiline' => {
#                                  "pattern" => "^[[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}",
                                  'pattern' => '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2} [[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2},[[:digit:]]{3}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'mysqld'  => {
                  'document_type' => 'mysqld',
                  'paths'  => [ '/var/log/mysqld.log', ],
              },
              'mysql_slow_log' => {
                  'document_type' => 'mysql_slow_log',
                  'paths'  => [
                                  '/var/log/mysql-slow.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^# User@Host: ',
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              #'mysql_slow_log2' => {
              #    'document_type' => 'mysql_slow_log2',
              #    'paths'  => [
              #                    '/var/lib/mysql/mysql/slow_log.CSV',
              #                ],
              #},
              'nginx-access'  => {
                  'document_type' => 'nginx-access',
                  'paths'  => [
                                  '/var/log/nginx/*.access.log',
                                  '/var/log/nginx/access.log',
                              ],
              },
              'nginx-error'  => {
                  'document_type' => 'nginx-error',
                  'paths'  => [
                                  '/var/log/nginx/*.error.log',
                                  '/var/log/nginx/error.log',
                              ],
              },
              'apache' => {
                  'document_type' => 'apache',
                  'paths'  => [
                                  '/var/log/httpd/*access.log',
                                  '/var/log/httpd/*access_log',
                              ],
              },
              'apache-error' => {
                  'document_type' => 'apache-error',
                  'paths'  => [
                                  '/var/log/httpd/*error.log',
                                  '/var/log/httpd/*error_log',
                              ],
              },
              'sugar_cron_log'   => {
                  'document_type' => 'sugar-cron-log',
                  'paths'  => [ '/var/www/html/sugarcrm/sugar-cron.log',
                                '/var/log/sugarcrm/sugar-cron.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'sugar_log'   => {
                  'document_type' => 'sugar-log',
                  'paths'  => [
                                  '/var/www/html/sugarcrm/sugarcrm.log',
                                  '/var/www/html/sugarcrm/suitecrm.log',
                                  '/var/www/sugarcrm.log',
                                  '/var/log/sugarcrm/sugarcrm.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}[[:blank:]][[:digit:]]{4}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'sugar_pmse_log'   => {
                  'document_type' => 'sugar-pmse-log',
                  'paths'  => [
                                  '/var/www/html/sugarcrm/PMSE.log',
                              ],
                  'multiline' => {
                                  'pattern' => '^[a-zA-Z]{3}[[:blank:]][a-zA-Z]{3}[[:blank:]]{1,3}[[:digit:]]{1,2}[[:blank:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}[[:blank:]][[:digit:]]{4}', # lint:ignore:140chars
                                  'negate' => true,
                                  'match'  => 'after',
                  },
              },
              'redis' => {
                  'document_type' => 'redis',
                  'paths'  => [
                                  '/var/log/redis/redis.log',
                              ],
              },
              'back2own_duplicity'  => {
                  'document_type' => 'back2own_duplicity',
                  'paths'  => [ '/var/log/back2own-duplicity.log', ],
              },
        }
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
  #
  $apache_php_php_error_reporting = 'E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE & ~E_WARNING'
  $apache_php_apache_https_port = '443'
  $apache_php_apache_http_port = '80'
  $apache_php_php_memory_limit = '1024M'
  $apache_php_php_max_execution_time = '300'
  $apache_php_php_upload_max_filesize = '100M'
  $apache_php_manage_firewall = false
  $apache_php_apache_http_redirect = true
  $apache_php_php_cache_engine = 'opcache+apcu'
  $apache_php_php_session_save_handler = 'files'
  $apache_php_php_session_save_path = '/var/lib/php/session'
  $apache_php_apache_manage_user = false
  $apache_php_manage_phpmyadmin_config = true
  $apache_php_manage_phpmyadmin_files = true
  #
  $apache_php_apache_timeout = 180
  #
  $apache_php_xdebug_module_manage   = true
  $apache_php_xdebug_module_ensure   = 'absent'
  $apache_php_xdebug_module_settings = {
    'xdebug.remote_enable' => '0',
    'xdebug.default_enable' => '0',
  }
  #
  $apache_php_manage_sugarcrm_files_ownership = true
  #
  $apache_php_manage_php_remi_repo = true
  #
  $mysql_server_service_manage = true
  $mysql_server_service_enabled = true
  $mysql_server_service_restart = true
  $mysql_server_config_max_connections = '1024'
  $mysql_server_use_pxc = false
  #
  $galeracluster_galeracluster_enable = '0'
  $mysql_server_mysql_override_options = {}
  $mysql_server_mysql_users_custom = {}
  $mysql_server_mysql_grants_custom = {}
  $mysql_server_mysql_sugarcrm_pass_hash = '*BD4FB69062149C65C7EE797605C881F8777AB144'
  $mysql_server_mysql_automysqlbackup_pass_hash = '*1CB694F2DF9A301025FD3594B5461AA2EDD24AC3'
  $mysql_server_mysql_root_password = ''
  #
  $elasticsearch_server_es_disable_config = false
  $elasticsearch_server_es_java_install = true
  $elasticsearch_server_es_repo_version = '1.7'
  $elasticsearch_server_es_version = '1.7.5-1'
  $elasticsearch_server_es_manage_repo = true
  $elasticsearch_server_es_package_pin = true
  $elasticsearch_server_es_instance_init_defaults = {}
  $elasticsearch_server_es_status = 'enabled'
  $elasticsearch_server_es_restart_on_change = true
  $elasticsearch_server_es_jvm_options = []
  $elasticsearch_server_es_instance_config = {
    'network.host' => '127.0.0.1',
    'http.port' => 9200,
    #'index.number_of_replicas' => '0',
    #'index.analysis.analyzer.folding.tokenizer' => "standard",
    #'index.analysis.analyzer.folding.filter' =>  [ "lowercase", "asciifolding" ],
  }
  $elasticsearch_server_es_instance_logging_yml_ensure = false
  $cron_handle_package = true
  $cron_handle_sugarcrm_file = true
  $cron_purge_users_crontabs = true
  $cron_service_enable = true
  $cron_service_ensure = true
  $cron_sugarcrm_job_timeout = 600
  #
  $redis_server_ensure = 'installed'
  #
  $memcached_install_top_cli = false
  $memcached_server_max_memory = 32
  $memcached_service_manage = true
  $memcached_server_pkg_ensure = 'present'
  #
  $memcached_php_module_handle = false
  $memcached_php_module_ensure = 'installed'
  #
  $firewall_ssh_port = '22'
  #
  $beats_agentname   = $::fqdn
  $beats_version_v5  = true
  $beats_filebeats_enable   = true
  $beats_metricbeats_enable = false
  #
  #$beats_filebeats_prospectors_config = {}
  $beats_filebeats_prospectors_config_extra = {}
  $beats_hosts = ['logstash.sugarfactory.cz:5044']
  $beats_manage_geoip = true
  $beats_manage_repo = true
}
