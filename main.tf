resource "google_compute_firewall" "firewall" {
  name    = "default-allow-http-fw"
  project = var.project_id
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sympl-server"]
}

resource "google_compute_address" "static" {
  name       = "vm-public-address"
  project    = var.project_id
  region     = var.region
  depends_on = [google_compute_firewall.firewall]
}

resource "google_compute_instance" "sympl-server" {
  name         = "sympl-server"
  zone         = "${var.region}-b"
  machine_type = var.machine_type
  tags         = ["sympl-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  labels = {
    name = "sympl-server"
  }
  connection {
    host        = google_compute_address.static.address
    type        = "ssh"
    user        = "ubuntu"
    timeout     = "500s"
    private_key = file(var.private_keypath)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt install wget",
      "wget https://gitlab.com/sympl.io/install/-/raw/master/install.sh",
      "sudo bash install.sh --noninteractive"
    ]
  }

  provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static.address
      type        = "ssh"
      user        = "ubuntu"
      timeout     = "500s"
      private_key = file(var.private_keypath)
    }

    inline = [
      "sudo echo -e 'sympl\nsympl' | sudo passwd sympl",
      "sudo chown -R sympl:sympl /etc/sympl/",
      "sudo chown -R sympl:sympl /srv/",
      "sudo chown -R sympl:sympl /etc/mysql/",
    ]

  }

  depends_on = [google_compute_firewall.firewall]

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_keypath)}"
  }
}
