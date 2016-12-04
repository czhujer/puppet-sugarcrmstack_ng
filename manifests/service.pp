# == Class sugarcrmstack_ng::service
#
# This class is meant to be called from sugarcrmstack_ng.
# It ensure the service is running.
#
class sugarcrmstack_ng::service {

  service { $::sugarcrmstack_ng::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
