# encoding: UTF-8
#
# Cookbook Name:: openstack-telemetry
# Recipe:: default
#
# Copyright 2013, AT&T Services, Inc.
# Copyright 2013-2014, SUSE Linux GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set the endpoints for the telemetry services to allow all other cookbooks to
# access and use them
%w(telemetry telemetry-metric).each do |ts|
  %w(public internal admin).each do |ep_type|
    default['openstack']['endpoints'][ep_type][ts]['host'] = '127.0.0.1'
    default['openstack']['endpoints'][ep_type][ts]['scheme'] = 'http'
    default['openstack']['endpoints'][ep_type][ts]['path'] = ''
    default['openstack']['endpoints'][ep_type]['telemetry']['port'] = 8777
    default['openstack']['endpoints'][ep_type]['telemetry-metric']['port'] = 8041
    # web-service (e.g. apache) listen address (can be different from openstack
    # telemetry endpoints)
  end
  default['openstack']['bind_service']['all'][ts]['host'] = '127.0.0.1'
end
default['openstack']['bind_service']['all']['telemetry']['port'] = 8777
default['openstack']['bind_service']['all']['telemetry-metric']['port'] = 8041

default['openstack']['telemetry']['conf_dir'] = '/etc/ceilometer'
default['openstack']['telemetry']['conf_file'] =
  ::File.join(node['openstack']['telemetry']['conf_dir'], 'ceilometer.conf')
default['openstack']['telemetry-metric']['conf_dir'] = '/etc/gnocchi'
default['openstack']['telemetry-metric']['conf_file'] =
  ::File.join(node['openstack']['telemetry-metric']['conf_dir'], 'gnocchi.conf')
default['openstack']['telemetry']['syslog']['use'] = false

default['openstack']['telemetry']['user'] = 'ceilometer'
default['openstack']['telemetry']['group'] = 'ceilometer'

default['openstack']['telemetry-metric']['user'] = 'gnocchi'
default['openstack']['telemetry-metric']['group'] = 'gnocchi'

default['openstack']['telemetry']['service_role'] = 'admin'
default['openstack']['telemetry-metric']['service_role'] = 'admin'

default['openstack']['telemetry']['identity-api']['auth']['version'] =
  node['openstack']['api']['auth']['version']
default['openstack']['telemetry-metric']['identity-api']['auth']['version'] =
  node['openstack']['api']['auth']['version']

case platform_family
when 'rhel'
  default['openstack']['telemetry']['platform'] = {
    'common_packages' => ['openstack-ceilometer-common'],
    'gnocchi_packages' => ['openstack-gnocchi-api', 'openstack-gnocchi-metricd'],
    'gnocchi-api_service' => 'openstack-gnocchi-api',
    'gnocchi-metricd_service' => 'openstack-gnocchi-metricd',
    'agent_central_packages' => ['openstack-ceilometer-central'],
    'agent_central_service' => 'openstack-ceilometer-central',
    'agent_compute_packages' => ['openstack-ceilometer-compute'],
    'agent_compute_service' => 'openstack-ceilometer-compute',
    'agent_notification_packages' => ['openstack-ceilometer-collector'],
    'agent_notification_service' => 'openstack-ceilometer-notification',
    'api_packages' => ['openstack-ceilometer-api'],
    'api_service' => 'openstack-ceilometer-api',
    'client_packages' => ['python-ceilometerclient', 'python-gnocchiclient'],
    'collector_packages' => ['openstack-ceilometer-collector'],
    'collector_service' => 'openstack-ceilometer-collector',
    'package_overrides' => ''
  }

when 'debian'
  default['openstack']['telemetry']['platform'] = {
    'common_packages' => ['ceilometer-common'],
    'gnocchi_packages' => ['gnocchi-api', 'gnocchi-metricd'],
    'gnocchi-api_service' => 'gnocchi-api',
    'gnocchi-metricd_service' => 'gnocchi-metricd',
    'agent_central_packages' => ['ceilometer-agent-central'],
    'agent_central_service' => 'ceilometer-agent-central',
    'agent_compute_packages' => ['ceilometer-agent-compute'],
    'agent_compute_service' => 'ceilometer-agent-compute',
    'agent_notification_packages' => ['ceilometer-agent-notification'],
    'agent_notification_service' => 'ceilometer-agent-notification',
    'api_packages' => ['ceilometer-api'],
    'api_service' => 'ceilometer-api',
    'client_packages' => ['python-ceilometerclient', 'python-gnocchiclient'],
    'collector_packages' => ['ceilometer-collector', 'python-mysqldb'],
    'collector_service' => 'ceilometer-collector',
    'package_overrides' => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end
