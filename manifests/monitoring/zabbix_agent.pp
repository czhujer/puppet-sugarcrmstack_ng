# Class: monitoring::zabbix_agent
# ===========================
#
# Full description of class monitoring::zabbix_agent here.
#
# Parameters
# ----------
#
class sugarcrmstack_ng::monitoring::zabbix_agent (
  $manage_agent_class = true,
  $manage_firewall = true,
  $manage_custom_logging = true,
  $manage_custom_extensions = true,
  $manage_extra_firewall_rules = false,
  $agent_hostname = $::fqdn,
  $agent_version = '3.0',
  $agent_server  = '192.168.127.1',
  $agent_activeserver = '192.168.127.1',
  $agent_tlspskidentity = undef,
  $agent_tlspskfile = undef,
  $agent_tlsaccept = undef,
  $agent_tlsconnect = undef,
  $firewall_src = '192.168.127.1',
  $extra_firewall_rule_src = '172.16.2.130',
  $plugin_apache_stats_handle_httpd_config = false,
  $plugin_apache_stats_use_script_wo_verify_certs = true,
  $plugin_apache_stats_script_params  = ' -r https -p 443',
  ){

  # validate general parameters
  validate_bool($manage_firewall)
  validate_bool($manage_agent_class)
  validate_bool($manage_custom_extensions)
  validate_bool($manage_custom_logging)
  validate_bool($plugin_apache_stats_handle_httpd_config)
  validate_bool($plugin_apache_stats_use_script_wo_verify_certs)
  validate_string($plugin_apache_stats_script_params)
  validate_bool($manage_extra_firewall_rules)

  #code
  if($manage_agent_class){
    class { '::zabbix::agent':
      hostname       => $agent_hostname,
      zabbix_version => $agent_version,
      server         => $agent_server,
      serveractive   => $agent_activeserver,
      listenip       => '0.0.0.0',
      logtype        => 'system',
      manage_selinux => false,
      tlspskidentity => $agent_tlspskidentity,
      tlspskfile     => $agent_tlspskfile,
      tlsaccept      => $agent_tlsaccept,
      tlsconnect     => $agent_tlsconnect,
    }
  }

  if($manage_firewall){
    firewall { '110 accept tcp to dport 10050 / ZABBIX-AGENT':
      chain  => 'INPUT',
      state  => 'NEW',
      proto  => 'tcp',
      dport  => ['10050'],
      source => $firewall_src,
      action => 'accept',
    }
  }

  if($manage_extra_firewall_rules){
    firewall { "111 accept tcp to dport 10050 from ${extra_firewall_rule_src} / ZABBIX-AGENT":
      chain  => 'INPUT',
      state  => 'NEW',
      proto  => 'tcp',
      dport  => ['10050'],
      source => $extra_firewall_rule_src,
      action => 'accept',
    }
  }

  if($manage_custom_logging){

    file { 'rsyslog zabbix-agent config':
      ensure  => present,
      path    => '/etc/rsyslog.d/zabbix-agent.conf',
      content => template('sugarcrmstack_ng/zabbix_agent_rsyslog_config.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['rsyslog'],
    }

    if !defined(Service['rsyslog']){
      service { 'rsyslog':
        ensure => running,
        enable => true,
      }
    }

    file { 'zabbix-agent2 logrotate':
      ensure  => present,
      path    => '/etc/logrotate.d/zabbix-agent2',
      content => template('sugarcrmstack_ng/zabbix_agent2_logrotate.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if($manage_custom_extensions){

    if ($agent_version != '4.0'){
      zabbix::userparameters { 'vfs-dir-size':
        source => 'puppet:///modules/zabbixagent/configs/userparameter_dir_size.conf',
      }
    }

    #class { 'zabbixagent::plugin2::linux_disk_io_stats':
    #  use_puppetlabs_zabbix_class => true,
    #}

    zabbixagent::plugin {'redhat-yum-stats':
      use_puppetlabs_zabbix_class => true,
    }

    zabbixagent::plugin { 'apache-stats':
      apache_stats_script_params              => $plugin_apache_stats_script_params,
      apache_stats_handle_httpd_config        => $plugin_apache_stats_handle_httpd_config,
      apache_stats_use_script_wo_verify_certs => $plugin_apache_stats_use_script_wo_verify_certs,

      use_puppetlabs_zabbix_class             => true,
    }

    zabbixagent::plugin { 'nginx-stats':
      use_puppetlabs_zabbix_class => true,
    }

    zabbixagent::plugin {'memcached-stats':
        use_puppetlabs_zabbix_class => true,
    }

    class { '::zabbixagent::plugin2::redis_stats':
      use_puppetlabs_zabbix_class => true,
    }

    class { '::zabbixagent::plugin2::sugarcrm_stats':
      use_puppetlabs_zabbix_class => true,
    }

    if ($::operatingsystemmajrelease in ['7']){
      if ($agent_version != '4.0'){
        class { '::zabbixagent::plugin2::systemd_services':
        }
      }
      else{
        notify {'zabbixagent::plugin2::systemd_services is not compatible with puppet 4.0': }
      }
    }
    else{
      class { '::zabbixagent::plugin2::linux_services':
        use_puppetlabs_zabbix_class => true,
      }
    }
  }
}
