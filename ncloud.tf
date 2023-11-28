# Terraform 초기화
terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"  # 네이버 클라우드 공급자 정보 지정
    }
  }
  required_version = ">= 0.13"  # Terraform 버전 0.13 이상이 필요
}

# 네이버 클라우드 프로바이더 설정
provider "ncloud" {
  access_key = "엑세스키 입력"              # 네이버 클라우드 접근을 위한 엑세스 키
  secret_key = "시크릿 키입력"              #네이버 클라우드 접근을 위한 시크릿 키
  region     = "KR"                         # 지역 설정 (한국: KR)
  site       = "public"                     # 사이트 설정 (public)
  support_vpc = "true"                      # VPC 지원 여부 설정
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


# 네이버 클라우드 공인 IP 생성
resource "ncloud_public_ip" "public-ip" {
  server_instance_no = ncloud_server.public-server.id  # 서버 인스턴스에 할당할 공인 IP의 서버 ID
}

# 네이버 클라우드 액세스 컨트롤 그룹 생성
resource "ncloud_access_control_group" "test-acg" {
  name   = "test-acg"               # 액세스 컨트롤 그룹의 이름
  vpc_no = ncloud_vpc.vpc.id        # 액세스 컨트롤 그룹이 속한 VPC의 ID
}

# 네이버 클라우드 액세스 컨트롤 그룹 규칙 생성
resource "ncloud_access_control_group_rule" "test-acg-rule" {
  access_control_group_no = ncloud_access_control_group.test-acg.id  # 규칙이 속한 액세스 컨트롤 그룹의 ID

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
  route_table_no = ncloud_vpc.vpc.default_public_route_table_no  # 연결할 공용 라우팅 테이블의 ID
  subnet_no      = ncloud_subnet.public-subnet.id               # 연결할 서브넷의 ID
}