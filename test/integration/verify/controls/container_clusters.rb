title 'Retrieve all GCP Container Clusters for a project and zone'

gcp_project_id = attribute(:gcp_project_id, default: '', description: 'The GCP project identifier.')
gcp_kube_cluster_name = attribute(:gcp_kube_cluster_name, default: '', description: 'The GKE cluster name.')
gcp_kube_cluster_zone = attribute(:gcp_kube_cluster_zone, default: '', description: 'The GKE cluster zone.')

control 'gcp-container-clusters-1.0a' do

  impact 1.0
  title 'Ensure zonal container clusters have the correct properties in bulk.'

  describe google_container_clusters(project: gcp_project_id, zone: gcp_kube_cluster_zone) do
    it { should exist }
    its('count') { should be <= 10}
    its('cluster_names') { should include gcp_kube_cluster_name }
    its('cluster_statuses') { should include "RUNNING" }
  end
end

control 'gcp-container-clusters-1.0b' do

  impact 1.0
  title 'Ensure zonal container clusters are found when zone is not specified.'

  describe google_container_clusters(project: gcp_project_id, zone: '') do
    it { should exist }
    its('count') { should be <= 10}
    its('cluster_names') { should include gcp_kube_cluster_name }
    its('cluster_statuses') { should include "RUNNING" }
  end
end
