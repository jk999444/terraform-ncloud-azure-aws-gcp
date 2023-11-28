# AWS 프로바이더 설정 - 서울 리전
provider "aws" {
    region = "ap-northeast-2"  # AWS 지역 설정 (서울: ap-northeast-2)
}

# VPC 리소스 생성
resource "aws_vpc" "my_vpc" {
    cidr_block = "172.16.0.0/16"  # VPC의 IP 대역 설정
    tags = {
        Name = "myVPC"  # 리소스에 이름 지정
    }
}

# Subnet 리소스 생성
resource "aws_subnet" "my_subnet" {
    vpc_id            = aws_vpc.my_vpc.id  # VPC ID 참조
    cidr_block        = "172.16.10.0/24"   # 서브넷의 IP 대역 설정
    availability_zone = "ap-northeast-2a"  # 가용 영역 설정 (서울: ap-northeast-2a)
    tags = {
        Name = "mySubnet"  # 리소스에 이름 지정
    }
}

# Network Interface 리소스 생성
resource "aws_network_interface" "my_net" {
    subnet_id   = aws_subnet.my_subnet.id  # 서브넷 ID 참조
    private_ips = ["172.16.10.100"]        # 프라이빗 IP 주소 설정
    tags = {
        Name = "private_network_interface"  # 리소스에 이름 지정
    }
}

# Ubuntu Instance 생성
resource "aws_instance" "ubuntu" {
    ami           = "ami-0225bc2990c54ce9a"  # Ubuntu 20.04 AMI ID
    instance_type = "t2.micro"               # 인스턴스 유형 설정

    network_interface {
        network_interface_id = aws_network_interface.my_net.id  # 네트워크 인터페이스 ID 참조
        device_index         = 0                               # 디바이스 인덱스 설정
    }
    tags = {
        Name = "myUbuntu"  # 인스턴스에 이름 지정
    }
}