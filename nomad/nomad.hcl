## Server Config

datacenter = "dc1"
data_dir = "/opt/nomad"
bind_addr = "0.0.0.0"
#bind_addr = "{{ GetInterfaceIP \"eth0\" }}" ## nic device name

server {
  enabled = true
  license_path = "/etc/nomad.d/license.hclic"
  bootstrap_expect = 1
}