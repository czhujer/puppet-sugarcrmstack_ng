# Class: sugarcrmstack_ng
# ===========================
#
# Full description of class sugarcrmstack_ng here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class sugarcrmstack_ng (
  $manage_utils_packages = $::sugarcrmstack_ng::params::manage_utils_packages,
  $utils_packages = $::sugarcrmstack_ng::params::utils_packages,
  $apache_php_enable = $::sugarcrmstack_ng::params::apache_php_enable,
#  $package_name = $::sugarcrmstack_ng::params::package_name,
#  $service_name = $::sugarcrmstack_ng::params::service_name,
) inherits ::sugarcrmstack_ng::params {

  # validate parameters here

  class { '::sugarcrmstack_ng::install': } ->
  class { '::sugarcrmstack_ng::config': } ~>
  class { '::sugarcrmstack_ng::service': } ->
  Class['::sugarcrmstack_ng']
}
