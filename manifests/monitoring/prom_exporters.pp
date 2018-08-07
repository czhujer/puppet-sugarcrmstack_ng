# Class: monitoring::prom_exporters
# ===========================
#
# Full description of class monitoring::prom_exporters here.
#
# Parameters
# ----------
#
class sugarcrmstack_ng::monitoring::prom_exporters (
  $manage_firewall                = true,
  $manage_nginx_vts_module        = false,
  $enable_redis_exporter          = false,
  $enable_redis_exporter_auto_add = true,
  $enable_apache_exporter         = false,
  $enable_apache_exporter_auto_add = true,
  $enable_elasticsearch_exporter   = false,
  $enable_elasticsearch_exporter_auto_add = true,
  $enable_phpfpm_exporter          = false,
  $enable_phpfpm_exporter_auto_add = true,
  ) {

  # validate general parameters
  validate_bool($manage_firewall)
  validate_bool($manage_nginx_vts_module)

  validate_bool($enable_redis_exporter)
  validate_bool($enable_redis_exporter_auto_add)
  validate_bool($enable_apache_exporter)
  validate_bool($enable_apache_exporter_auto_add)
  validate_bool($enable_elasticsearch_exporter)
  validate_bool($enable_elasticsearch_exporter_auto_add)
  validate_bool($enable_phpfpm_exporter)
  validate_bool($enable_phpfpm_exporter_auto_add)

  if ($::operatingsystemmajrelease in ['6']){
    $service_add_end_of_command = '|grep JobName -c'
  }
  else{
    $service_add_end_of_command = '-e'
  }

  if !defined (Package['jq']){
    package {'jq':
      ensure => installed,
    }
  }

  if($manage_nginx_vts_module){
    file { '/usr/lib64/nginx/modules/ngx_http_vhost_traffic_status_module.so':
      ensure  => file,
      content => file('sugarcrmstack_ng/nginx-modules/ngx_http_vhost_traffic_status_module.c7.nginx.1.14.0.so'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['nginx'],
      notify  => Service['nginx'],
    }
  }

  if($manage_firewall){
    firewall { '114 accept tcp to dports 9xxx / sf-pmm-s2 exporters':
      chain  => 'INPUT',
      state  => 'NEW',
      proto  => 'tcp',
      dport  => ['9117','9121','9108','9253', '9913'],
      source => '192.168.127.0/24',
      action => 'accept',
    }
  }

  # redis exporter

  if($enable_redis_exporter){
    class { '::prometheus::redis_exporter':
      extra_options => "-redis.alias ${::hostname}",
    }

    if($enable_redis_exporter_auto_add){
      $redis_prefix='redis-'

      exec { 'pmm redis exporter service':
        command => "sudo pmm-admin add external:service --service-port=9121 ${redis_prefix}${::hostname}",
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => "pmm-admin list --json |jq '.[\"ExternalServices\"][] | select( .JobName | contains(\"${redis_prefix}${::hostname}\"))' -c  ${service_add_end_of_command}", # lint:ignore:140chars
        require => [
          Class['prometheus::redis_exporter'],
          Package['jq'],
        ],
      }
    }
  }

  # apache exporter

  if($enable_apache_exporter){
    class { '::prometheus::apache_exporter':
      url           => 'https://localhost/server-status?auto',
      extra_options => '-insecure',
    }

    if($enable_apache_exporter_auto_add){
      $apache_prefix='apache-'

      exec { 'pmm apache exporter service':
        command => "sudo pmm-admin add external:service --service-port=9117 ${apache_prefix}${::hostname}",
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => "pmm-admin list --json |jq '.[\"ExternalServices\"][] | select( .JobName | contains(\"${apache_prefix}${::hostname}\"))' -c  ${service_add_end_of_command}", # lint:ignore:140chars
        require => [
          Class['prometheus::apache_exporter'],
          Package['jq'],
        ],
      }
    }
  }

  # elasticsearch exporters

  if($enable_elasticsearch_exporter){
    class { '::prometheus::elasticsearch_exporter':
    }

    $es_prefix='elasticsearch-'

    if($enable_elasticsearch_exporter_auto_add){
      exec { 'pmm elasticsearch exporter service':
        command => "sudo pmm-admin add external:service --service-port=9108 ${es_prefix}${::hostname}",
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => "pmm-admin list --json |jq '.[\"ExternalServices\"][] | select( .JobName | contains(\"${es_prefix}${::hostname}\"))' -c ${service_add_end_of_command}", # lint:ignore:140chars
        require => [
          Class['prometheus::elasticsearch_exporter'],
          Package['jq'],
        ],
      }
    }

  }

  # php-fpm exporter

  if($enable_phpfpm_exporter){
    class { '::prometheus::phpfpm_exporter':
      url => 'tcp://127.0.0.1:9001/fpm-status,tcp://127.0.0.1:9002/fpm-status',
    }

    if($enable_phpfpm_exporter_auto_add){
      $phpfpm_prefix='php-fpm-'

      exec { 'pmm phpfpm exporter service':
        command => "sudo pmm-admin add external:service --service-port=9253 ${phpfpm_prefix}${::hostname}",
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => "pmm-admin list --json |jq '.[\"ExternalServices\"][] | select( .JobName | contains(\"${phpfpm_prefix}${::hostname}\"))' -c  ${service_add_end_of_command}", # lint:ignore:140chars
        require => [
          Class['prometheus::redis_exporter'],
          Package['jq'],
        ],
      }
    }
  }
}
