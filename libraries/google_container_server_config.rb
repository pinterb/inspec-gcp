# frozen_string_literal: true

require 'gcp_backend'
require 'google/apis/container_v1'

module Inspec::Resources
  class GoogleContainerServerConfig < GcpResourceBase
    name 'google_container_server_config'
    desc 'Verifies settings for a container server config'

    example "
      describe google_container_server_config(project: 'chef-inspec-gcp', zone: 'europe-west2-a') do
        it { should exist }
        its('defaultClusterVersion') { should eq '1.10.9-gke.5' }
        ...
      end

      OR

      describe google_container_server_config(project: 'chef-inspec-gcp', region: 'europe-west2') do
        it { should exist }
        its('defaultClusterVersion') { should eq '1.10.9-gke.5' }
        ...
      end
    "
    def initialize(opts = {})
      # Call the parent class constructor
      super(opts)
      @display_name = opts[:project]
      catch_gcp_errors do
        # projects/us-dev/locations/us-central1
        @location = (opts[:region].nil? || opts[:region].empty? ? opts[:zone] : opts[:region])
        name = format("projects/%s/locations/%s", opts[:project], @location)
        @servercfg = @gcp.gcp_client(Google::Apis::ContainerV1::ContainerService).get_project_location_server_config(name)
        create_resource_methods(@servercfg)
      end
      @display_name = format("%s/%s", opts[:project], @location)
    end

    def latest_master_version
      return '' if !defined?(@servercfg.valid_master_versions)
      return '' if @servercfg.valid_master_versions.nil?
      @servercfg.valid_master_versions[0]
    end

    def oldest_master_version
      return '' if !defined?(@servercfg.valid_master_versions)
      return '' if @servercfg.valid_master_versions.nil?
      @servercfg.valid_master_versions.last
    end

    def latest_node_version
      return '' if !defined?(@servercfg.valid_node_versions)
      return '' if @servercfg.valid_node_versions.nil?
      @servercfg.valid_node_versions[0]
    end

    def oldest_node_version
      return '' if !defined?(@servercfg.valid_node_versions)
      return '' if @servercfg.valid_node_versions.nil?
      @servercfg.valid_node_versions.last
    end

    def exists?
      !@servercfg.nil?
    end

    def to_s
      "Server Config #{@display_name}"
    end
  end
end
