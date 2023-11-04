## client Config

datacenter = "dc1"
data_dir = "/opt/nomad"
bind_addr = "0.0.0.0"
#bind_addr = "{{ GetInterfaceIP \"eth0\" }}" ## nic device name

server_join {
  retry_join = ["3.36.98.22:4647"]
}

client {
  enabled = true
  servers = ["3.36.98.22:4647"]
  
  options = {
    "driver.raw_exec.enable" = "1"
  }
}