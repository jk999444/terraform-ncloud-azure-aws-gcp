# Terraform 초기화
terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

# 네이버 클라우드 프로바이더 설정
provider "ncloud" {
  access_key = "엑세스키 입력"
  secret_key = "시크릿 키입력"
  region     = "KR"
  site       = "public"
  support_vpc = "true"
}

# 네이버 클라우드 VPC 생성
resource "ncloud_vpc" "vpc" {
  ipv4_cidr_block = "172.16.0.0/16"  # VPC의 IP 대역 설정
  name            = "test-vpc"
}

# 네이버 클라우드 서브넷 생성
resource "ncloud_subnet" "public-subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = "172.16.10.0/24"  # 서브넷의 IP 대역 설정
  zone           = "KR-2"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  name           = "public-a-subnet"
  usage_type     = "GEN"
}

# 네이버 클라우드 서버 생성
resource "ncloud_server" "public-server" {
  subnet_no                 = ncloud_subnet.public-subnet.id
  name                      = "test-web01"
  server_image_product_code = "SW.VSVR.OS.LNX64.CNTOS.0708.B050"  # CentOS 이미지 사용
  server_product_code       = "SVR.VSVR.HICPU.C002.M004.NET.HDD.B050.G002"  # 기본 성능 서버 사용
  login_key_name            = "ncp20231116"
}

# # 네이버 클라우드 로그인 키 생성
# resource "ncloud_login_key" "loginkey" {
#   #key_name = "test-key"
#   key_name = "ncp20231116"
# }

# 네이버 클라우드 공인 IP 생성
resource "ncloud_public_ip" "public-ip" {
  server_instance_no = ncloud_server.public-server.id
}

# 네이버 클라우드 액세스 컨트롤 그룹 생성
resource "ncloud_access_control_group" "test-acg" {
  name   = "test-acg"
  vpc_no = ncloud_vpc.vpc.id
}

# 네이버 클라우드 액세스 컨트롤 그룹 규칙 생성
resource "ncloud_access_control_group_rule" "test-acg-rule" {
  access_control_group_no = ncloud_access_control_group.test-acg.id

  # SSH 트래픽만 허용
  inbound {
    protocol    = "TCP"
    ip_block    = "0.0.0.0/0"
    port_range  = "22"
    description = "SSH"
  }
}

# 네이버 클라우드 라우팅 테이블 연결
resource "ncloud_route_table_association" "route_ass_public" {
  route_table_no = ncloud_vpc.vpc.default_public_route_table_no
  subnet_no      = ncloud_subnet.public-subnet.id
}

  