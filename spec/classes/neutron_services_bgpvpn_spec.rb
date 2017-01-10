# Copyright (C) 2017 Red Hat Inc.
#
# Author: Ricardo Noriega <rnoriega@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'neutron::services::bgpvpn' do

  let :default_params do
    { :package_ensure    => 'present',
      :service_providers => '<SERVICE_DEFAULT>'}
  end

  shared_examples_for 'neutron bgpvpn service plugin' do

    context 'with default params' do
      let :params do
        default_params
      end

      it 'installs bgpvpn package' do
        is_expected.to contain_package('python-networking-bgpvpn').with(
          :ensure => params[:package_ensure],
	  :name   => platform_params[:bgpvpn_package_name],
	)
      end
    end

    context 'with multiple service providers' do
      let :params do
	default_params.merge(
          { :service_providers => ['provider1', 'provider2'] }
	)
      end

      it 'configures networking_bgpvpn.conf' do
        is_expected.to contain_neutron_bgpvpn_service_config(
          'service_providers/service_provider'
	).with_value(['provider1', 'provider2'])
      end
    end

  end

  context 'on Red Hat platforms' do
    let :facts do
      @default_facts.merge({
	:osfamily  => 'RedHat'
	:operatingsystemrelease => '7'
      })
    end

    let :platform_params do
      { :vpnaas_package_name => 'python-networking-bgpvpn'}
    end

    it_configures 'neutron bgpvpn service plugin'
  end

end
