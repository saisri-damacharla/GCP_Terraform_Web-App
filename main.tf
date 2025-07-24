# Define the GCP provider configuration.
provider "google" {
  project = "gcptfdemo1"  
  region  = "us-central1"          
}

variable "cidr" {
  default = "10.0.0.0/16"
}

resource "google_compute_network" "myvpc" {
  name                    = "myvpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub1" {
  name          = "sub1"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.myvpc.id
}

resource "google_compute_firewall" "web_firewall" {
  name    = "web-firewall"
  network = google_compute_network.myvpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "server" {
  name         = "tfdemo1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-11-bullseye-v20250123"  
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.sub1.name

    access_config {
      # Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "tfdemo1:${file("C:/Users/saida/.ssh/id_rsa.pub")}"  
  }

  tags = ["web"]

  provisioner "file" {
    source      = "C:/Users/saida/terraform_1.10.3_windows_amd64/GCP_TF_project/app.py"
    destination = "/home/tfdemo1/app.py"

    connection {
      type        = "ssh"
      user        = "tfdemo1"
      private_key = file("C:/Users/saida/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/tfdemo1",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]

    connection {
      type        = "ssh"
      user        = "tfdemo1"
      private_key = file("C:/Users/saida/.ssh/id_rsa")
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}
