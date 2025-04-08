resource "google_container_cluster" "GKE-cluster" {
  name     = "cloudshirt-cluster"
  location = "us-central1"

  initial_node_count = 1
  deletion_protection = false

  node_config {
    machine_type = "e2-medium"
  }
}

resource "google_artifact_registry_repository" "Cloudshirt-repository" {
  provider = google

  location      = "us-central1"
  repository_id = "cloudshirt-repository"
  description   = "cloudshirt repository for assignment 3"
  format        = "DOCKER"
  
  labels = {
    environment = "dev"
  }
}

# gcloud container clusters get-credentials cloudshirt-cluster --region us-central1 --project cloud-concepts-451813
output "gke_connect_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.GKE-cluster.name} --region ${google_container_cluster.GKE-cluster.location} --project ${google_container_cluster.GKE-cluster.project}"
}
