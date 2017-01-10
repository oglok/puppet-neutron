#
# Copyright (C) 2017 Red Hat Inc.
#
# Author: Ricardo Noriega <rnoriega@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: neutron::services::bgpvpn
#
# Configure BGPVPN Neutron API
#
# === Parameters:
#
# [*package_ensure*]
#   Whether to install the bgpvpn service package
#   Default to 'present'
#
# [*service_providers*]
#   Array of allowed service types

class neutron::services::bgpvpn (
  $package_ensure              = 'present',
  $service_providers           = $::os_service_default,
) {

  include ::neutron::params
 
  #This package just include the service API
  ensure_resource( 'package', 'python-networking-bgpvpn', {
    ensure => $package_ensure,
    name   => $::neutron::params::bgpvpn_plugin_package,
    tag    => ['openstack', 'neutron-package'],
  })
 
  if !is_service_default($service_providers) {
    # default value is uncommented setting, so we should not touch it at all
    neutron_bgpvpn_service_config { 'service_providers/service_provider':
      value => $service_providers,
    }
}
