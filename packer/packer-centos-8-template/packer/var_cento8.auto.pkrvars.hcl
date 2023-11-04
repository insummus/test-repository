# Assign values to override their default values (default values are found in the vsphere_centos8.pkr.hcl file).
# All values are automatically used and persist through the entire Packer process.

vsphere_user     = "Administrator@vsphere.local"
vsphere_password = "!QAZxsw2"

ssh_username = "root"
ssh_password = "!QAZxsw2"

vsphere_template_name = "centos8_x64_packer_template"
vsphere_folder        = "templates"

cpu_num     = 1
mem_size    = 1024
disk_size   = 10000

vsphere_server          = "10.167.10.162"
vsphere_dc_name         = "datacenter"
vsphere_compute_cluster = "cs1"
vsphere_host            = "10.167.10.161"
vsphere_datastore       = "datastore1"
vsphere_portgroup_name  = "VM Network"

os_iso_path = "[datastore1] iso/centos-stream-8-x86_64-latest-boot.iso"