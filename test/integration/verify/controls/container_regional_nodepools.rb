title 'Retrieve  all GCP Container Cluster Node Pools for a project, cluster and zone'

gcp_project_id = attribute(:gcp_project_id, default: '', description: 'The GCP project identifier.')
gcp_kube_regional_cluster_name = attribute(:gcp_kube_regional_cluster_name, default: '', description: 'The GKE regional cluster name.')
gcp_kube_nodepool_name = attribute(:gcp_kube_nodepool_name, default:'', description: 'The GKE cluster node pool name.')
gcp_kube_cluster_region = attribute(:gcp_kube_cluster_region, default: '', description: 'The GKE cluster zone.')

control 'gcp-regional-container-cluster-node-pools-1.0' do

  impact 1.0
  title 'Ensure container cluster node pools have the correct properties in bulk.'

  describe google_container_node_pools(project: gcp_project_id, region: gcp_kube_cluster_region, cluster_name: gcp_kube_regional_cluster_name) do
    it { should exist }
    its('count') { should be <= 10}
    its('node_pool_names') { should include gcp_kube_nodepool_name }
    its('node_pool_statuses') { should include "RUNNING" }
  end
end
