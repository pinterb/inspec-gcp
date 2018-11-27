title 'GKE Regional Container Cluster Properties'

gcp_project_id = attribute(:gcp_project_id, default: '', description: 'The GCP project identifier.')
gcp_kube_regional_cluster_name = attribute(:gcp_kube_regional_cluster_name, default: '', description: 'The GKE regional cluster name.')
gcp_kube_cluster_region = attribute(:gcp_kube_cluster_region, default: '', description: 'The GKE cluster region.')
gcp_kube_cluster_master_user = attribute(:gcp_kube_cluster_master_user, default: '', description: 'The GKE cluster master user.')
gcp_kube_cluster_master_pass = attribute(:gcp_kube_cluster_master_pass, default: '', description: 'The GKE cluster master password.')


control 'gcp-gke-regional-container-cluster-1.0' do

  impact 1.0
  title 'Ensure GKE Regional Container Cluster was built correctly'

  describe google_container_cluster(project: gcp_project_id, region: gcp_kube_cluster_region, name: gcp_kube_regional_cluster_name) do
    it { should exist }
    its('name') { should eq gcp_kube_regional_cluster_name }
    its('location') { should match gcp_kube_cluster_region }

    # the cluster should not be tainted
    its('tainted?') { should be false }

    # the cluster should not be untrusted
    its('untrusted?') { should be false }

    # the cluster should be in running state
    its('status') { should eq 'RUNNING' }

    # importantly for the cluster, check the kube master user/password
    its('master_auth.username'){ should eq gcp_kube_cluster_master_user}
    its('master_auth.password'){ should eq gcp_kube_cluster_master_pass}

    # no special network settings currently applied
    its('network'){should eq "default"}
    its('subnetwork'){should eq "default"}

    # check node configuration settings
    its('node_config.disk_size_gb'){should eq 100}
    its('node_config.image_type'){should eq "COS"}
    its('node_config.machine_type'){should eq "n1-standard-1"}

    # check ipv4 cidr size
    its('node_ipv4_cidr_size'){should eq 24}

    # check there is one node pool in the cluster
    its('node_pools.count'){should eq 1}

  end
end
