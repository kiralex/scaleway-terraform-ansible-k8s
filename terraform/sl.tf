provider "scaleway" {
  organization = "${var.organisation_id}"
  token        = "${var.secret_token}"
  region       = "${var.region}"
}

resource "scaleway_ip" "ip_test" {
  count = 1
}

data "scaleway_image" "ubuntu" {
  architecture = "x86_64"
  name         = "Ubuntu Mini Xenial 25G"
}

resource "scaleway_server" "test_server" {
  name           = "test"
  image          = "${data.scaleway_image.ubuntu.id}"
  type           = "START1-XS"
  state          = "running"
  security_group = "${scaleway_security_group.http.id}"
  public_ip      = "${scaleway_ip.ip_test.0.ip}"
}

resource "scaleway_security_group" "http" {
  name                    = "http"
  description             = "allow HTTP and HTTPS traffic"
  enable_default_security = true
}

resource "scaleway_security_group_rule" "http_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 80
}

resource "scaleway_security_group_rule" "https_accept" {
  security_group = "${scaleway_security_group.http.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 443
}

output "test_output" {
  value = "${scaleway_server.test_server.private_ip}"
}
