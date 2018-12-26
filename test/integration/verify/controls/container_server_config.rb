title 'GCP Container Server Config Properties'

gcp_project_id = attribute(:gcp_project_id, default: '', description: 'The GCP project identifier.')
gcp_kube_cluster_region = attribute(:gcp_kube_cluster_region, default: '', description: 'The GKE cluster zone.')

control 'gcp-gke-container-server-config-1.0' do

  impact 1.0
  title 'Ensure available GKE versions'

  describe google_container_server_config(project: gcp_project_id, region: 'us-central1') do
    its('default_cluster_version') { should cmp '1.10.9-gke.5' }
    its('default_image_type') { should cmp 'COS' }

    its('latest_master_version') { should match /1.11/ }
    its('valid_master_versions') { should include '1.10.9-gke.7' }
    its('oldest_master_version') { should cmp '1.10.6-gke.13' }
    its('oldest_master_version') { should match /1.10/ }

    its('latest_node_version') { should match /1.11/ }
    its('valid_node_versions') { should include '1.10.9-gke.7' }
    its('oldest_node_version') { should cmp '1.8.8-gke.0' }
    its('oldest_node_version') { should match /1.8/ }
  end
end

