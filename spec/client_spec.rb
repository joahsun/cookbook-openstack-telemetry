# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-telemetry::client' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    it do
      expect(chef_run).to upgrade_package('python-ceilometerclient')
    end

    it do
      expect(chef_run).to upgrade_package('python-gnocchiclient')
    end
  end
end
