provider "dns" {
  update {
    server        = var.dns_server
    key_name      = var.key_name
    key_algorithm = var.key_algorithm
    key_secret    = var.key_secret
  }
}

resource "dns_a_record_set" "cluster" {
  for_each = var.hostnames_ip_addresses

  zone = "${var.dns_domain}."
  name = format("%s.%s", element(split(".", each.key), 0), var.cluster_name)
  addresses = [
    each.value
  ]
  ttl = 300
}

resource "dns_ptr_record" "cluster" {
  for_each = var.hostnames_ip_addresses
  
  zone = "16.172.in-addr.arpa."
  name = format("%s.%s", element(split(".", each.value), 3), element(split(".", each.value), 2))
  ptr  = format("%s.", each.key)
  ttl  = 300
}

resource "dns_a_record_set" "api" {
  zone = "${var.dns_domain}."
  name = format("api.%s", var.cluster_name)
  addresses = [
    var.api_vip
  ]
  ttl = 300
}

resource "dns_a_record_set" "api_int" {
  zone = "${var.dns_domain}."
  name = format("api-int.%s", var.cluster_name)
  addresses = [
    var.api_vip
  ]
  ttl = 300
}

resource "dns_a_record_set" "apps" {
  zone = "${var.dns_domain}."
  name = format("*.apps.%s", var.cluster_name)
  addresses = [
    var.ingress_vip
  ]
  ttl = 300
}

