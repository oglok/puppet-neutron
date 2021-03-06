#
# Class to execute neutron dbsync
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the neutron-db-manage upgrade heads command. These will be
#   inserted in the command line between 'neutron-db-manage' and
#   'upgrade heads'.
#   Defaults to ''
#
class neutron::db::sync(
  $extra_params = '',
) {

  include ::neutron::deps
  include ::neutron::params

  exec { 'neutron-db-sync':
    command     => "neutron-db-manage ${extra_params} upgrade heads",
    path        => '/usr/bin',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['neutron::install::end'],
      Anchor['neutron::config::end'],
      Anchor['neutron::dbsync::begin']
    ],
    notify      => Anchor['neutron::dbsync::end'],
  }
}
