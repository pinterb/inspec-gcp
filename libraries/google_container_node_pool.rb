# frozen_string_literal: true

require 'gcp_backend'
require 'google/apis/container_v1'

module Inspec::Resources
  class GoogleContainerNodePool < GcpResourceBase
    name 'google_container_node_pool'
    desc 'Verifies settings for a container nodepool'

    example "
      describe google_container_node_pool(project: 'chef-inspec-gcp', zone: 'europe-west2-a', cluster_name: 'cluster-name', nodepool_name: 'inspec-test') do
        it { should exist }
        its('name') { should eq 'inspec-test' }
        ...
      end

      OR

      describe google_container_node_pool(project: 'chef-inspec-gcp', region: 'europe-west2', cluster_name: 'cluster-name', nodepool_name: 'inspec-test') do
        it { should exist }
        its('name') { should eq 'inspec-test' }
        ...
      end
    "
    def initialize(opts = {})
      # Call the parent class constructor
      super(opts)
      @display_name = opts[:nodepool_name]
      @region = opts[:region]
      catch_gcp_errors do
        location = (opts[:region].nil? || opts[:region].empty? ? opts[:zone] : opts[:region])
        name = format("projects/%s/locations/%s/clusters/%s/nodePools/%s", opts[:project], location, opts[:cluster_name], opts[:nodepool_name])
        @nodepool = @gcp.gcp_client(Google::Apis::ContainerV1::ContainerService).get_project_location_cluster_node_pool(name)
        create_resource_methods(@nodepool)
      end
    end

    def has_automatic_node_repair?
      return false if !defined?(@nodepool.management.auto_repair)
      return false if @nodepool.management.auto_repair.nil?
      @nodepool.management.auto_repair
    end

    def has_automatic_node_upgrade?
      return false if !defined?(@nodepool.management.auto_upgrade)
      return false if @nodepool.management.auto_upgrade.nil?
      @nodepool.management.auto_upgrade
    end

    def has_preemptible_nodes?
      return false if !defined?(@nodepool.config.preemptible)
      return false if @nodepool.config.preemptible.nil?
      @nodepool.config.preemptible
    end

    def config_image_type
      return '' if !defined?(@nodepool.config.image_type)
      return '' if @nodepool.config.image_type.nil?
      @nodepool.config.image_type
    end

    def config_machine_type
      return '' if !defined?(@nodepool.config.machine_type)
      return '' if @nodepool.config.machine_type.nil?
      @nodepool.config.machine_type
    end

    def config_disk_size_gb
      return 0 if !defined?(@nodepool.config.disk_size_gb)
      return 0 if @nodepool.config.disk_size_gb.nil?
      @nodepool.config.disk_size_gb
    end

    def config_local_ssd_count
      return 0 if !defined?(@nodepool.config.local_ssd_count)
      return 0 if @nodepool.config.local_ssd_count.nil?
      @nodepool.config.local_ssd_count
    end

    def config_service_account
      return '' if !defined?(@nodepool.config.service_account)
      return '' if @nodepool.config.service_account.nil?
      @nodepool.config.service_account
    end

    def config_oauth_scopes
      return false if !defined?(@nodepool.config.oauth_scopes)
      return false if @nodepool.config.oauth_scopes.nil?
      @nodepool.config.oauth_scopes
    end

    def autoscale_min_node_count
      return 0 if !defined?(@nodepool.autoscaling.min_node_count)
      return 0 if @nodepool.autoscaling.min_node_count.nil?
      @nodepool.autoscaling.min_node_count
    end

    def autoscale_max_node_count
      return 0 if !defined?(@nodepool.autoscaling.max_node_count)
      return 0 if @nodepool.autoscaling.max_node_count.nil?
      @nodepool.autoscaling.max_node_count
    end

    def exists?
      !@nodepool.nil?
    end

    def to_s
      "Nodepool #{@display_name}"
    end
  end
end
