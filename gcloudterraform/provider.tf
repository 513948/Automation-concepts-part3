provider "google" {
  project = "My First Project" # Replace with your project ID
  region  = "us-central1"
  credentials = file("nimble-sylph-449914-i0-8c4520b922e9.json") # Replace with your service account key file IN jsON format
}
