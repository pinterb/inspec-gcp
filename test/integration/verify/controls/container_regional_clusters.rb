title 'Retrieve all GCP Container Clusters for a project and region'

gcp_project_id = attribute(:gcp_project_id, default: '', description: 'The GCP project identifier.')
gcp_kube_regional_cluster_name = attribute(:gcp_kube_cluster_name, default: '', description: 'The GKE cluster name.')
gcp_kube_cluster_region = attribute(:gcp_kube_cluster_region, default: '', description: 'The GKE cluster zone.')

control 'gcp-container-clusters-1.0' do

  impact 1.0
  title 'Ensure regional container clusters have the correct properties in bulk.'

  describe google_container_clusters(project: gcp_project_id, region: gcp_kube_cluster_region) do
    it { should exist }
    its('count') { should be <= 10}
    its('cluster_names') { should include gcp_kube_regional_cluster_name }
    its('cluster_statuses') { should include "RUNNING" }
  end
end