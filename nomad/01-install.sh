#!/bin/bash

# nomad client list
# - 3.34.127.59
# - 3.35.217.19
# - 3.35.236.42

####################################################################
## 설치 - CentOS 8 Stream
####################################################################
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install nomad-enterprise
sudo nomad -v

####################################################################
## 설정
####################################################################
export NOMAD_ADDR="http://192.168.0.10:4646"

export NOMAD_LICENSE="02MV4UU43BK5HGYYTOJZWFQMTMNNEWU33JLFVGW52ZKRATITLKM52E46SBPFMXSMBVJYZFK6SMKRTTGTTNLF2E2MSZPBGVIUJRJZ5GGM2PIRGTGSLJO5UVSM2WPJSEOOLULJMEUZTBK5IWST3JJEZU2V2JGVGVOTJTLFUTAM2ZK5IXQTCUM54E43KNORHFOSTLJZUTAMCNIRRXOWKULF3VUR2KNJGTERLJJRBUU4DCNZHDAWKXPBZVSWCSOBRDENLGMFLVC2KPNFEXCSLJO5UWCWCOPJSFOVTGMRDWY5C2KNETMSLKJF3U22SNORGVIRLUJVCEUVKNIRRTMTKUJE3E4VCFOVHUIZ3XJ5KFSMCOIRMTGV3JJFZUS3SOGBMVQSRQLAZVE4DCK5KWST3JJF4U2RCJPJGFIRLYJRKEC6KWIRAXOT3KIF3U62SBO5LWSSLTJFWVMNDDI5WHSWKYKJYGEMRVMZSEO3DULJJUSNSJNJEXOTLKKF2E2RCJORGWU2CVJVCECNSNIRATMTKEIJQUS2LXNFSEOVTZMJLWY5KZLBJHAYRSGVTGIR3MORNFGSJWJFVES52NNJIXITKEJF2E22TIKVGUIQJWJVCECNSNIRBGCSLJO5UWGSCKOZNEQVTKMRBUSNSJNU2XMYSXIZVUS2LXNFNG26DILIZU22KPNZZWSYSXHFVWIV3YNRRXSSJWK54UU5DEK54DAYKXJZZWIWCOGBNFQSLULFLTK22MK5LG2WTNNRVGCV2WOVMTG23JJRBUU3TCGNNGYY3NGVUGE3KONRGFQQTWMJDWY2TFKNFGIZSYGA6S4MTYN5UGO3S2GNXTEKZQGZKGOQRYPFGHM2LDMVAWMRSVIY3XS3RVOJBFEYKJNBRDQ6KUGBXWC5LKGNRHMOCCNBMVUNLCKBWWE6SIPBUUY5LYKNBXOUCCOVLTA4LSNFWE443TKZSEISRRMRAWWY3BGRSFMMBTGM4FA53NKZWGC5SKKA2HASTYJFETSRBWKVDEYVLBKZIGU22XJJ2GGRBWOBQWYNTPJ5TEO3SLGJ5FAS2KKJWUOSCWGNSVU53RIZSSW3ZXNMXXGK2BKRHGQUC2M5JS6S2WLFTS6SZLNRDVA52MG5VEE6CJG5DU6YLLGZKWC2LBJBXWK2ZQKJKG6NZSIRIT2PI"
export NOMAD_LICENSE_PATH="/etc/nomad.d/license.hclic"

echo $NOMAD_LICENSE > $NOMAD_LICENSE_PATH
chown nomad:nomad  $NOMAD_LICENSE_PATH
sudo nomad license inspect $NOMAD_LICENSE_PATH

####################################################################
## 서버 파일생성
####################################################################
export NOMAD_HCL_PATH="/etc/nomad.d/nomad.hcl"

cat <<EOF > $NOMAD_HCL_PATH
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
EOF

chown nomad:nomad $NOMAD_HCL_PATH


####################################################################
## 클라이언트 파일생성
####################################################################

export NOMAD_HCL_PATH="/etc/nomad.d/nomad.hcl"

cat <<EOF > $NOMAD_HCL_PATH
## client Config

datacenter = "dc1"
data_dir = "/opt/nomad"
bind_addr = "0.0.0.0"
#bind_addr = "{{ GetInterfaceIP \"eth0\" }}" ## nic device name

server_join {
  retry_join = ["192.168.0.10:4647"]
}

client {
  enabled = true
  servers = ["192.168.0.10:4647"]
  
  options = {
    "driver.raw_exec.enable" = "1"
  }
}
EOF

chown nomad:nomad $NOMAD_HCL_PATH

####################################################################
## 서비스 설정
####################################################################
sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad


####################################################################
## 참고: Nomad Client - Docker Engine 설치
####################################################################
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker && sudo systemctl start docker