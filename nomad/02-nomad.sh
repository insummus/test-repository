#!/bin/bash

####################################################################
## nodepool 구성
####################################################################

cat <<EOF > node_pool.app-test.hcl
## nodepool config 
node_pool "app-test" {

  description = "test pool"

  meta {
    environment = "aws"
    owner       = "sungtae"
  }

  # scheduler_config {
  #   scheduler_algorithm = "spread"
  # }
}
EOF

nomad node pool apply ./node_pool.app-test.hcl


####################################################################
## job example
## https://github.com/angrycub/nomad_example_jobs
####################################################################
job "nginx-install" {
  datacenters = ["dc1"]

  group "nginx-group" {
    count = 1
    
    task "install-nginx" {
      driver = "exec"
      config {
        command = "/bin/bash"
        args = ["-c", "yum -y install nginx"]
      }
    }
  }
}


job deploy_httpd {
  datacenters = ["dc1"]
  #namespace = 
  node_pool = "app-test"
  type = "system"

  group "group" {
    task "deploy_and_sleep" {
      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args = ["-c", "yum install -y httpd; echo \"Deployment Complete\"; while true; do echo -n \".\"; sleep 5; done"]
      }

      resources {
        memory = 10
        cpu = 50
      }
    }
  }
}