# # Terraform 초기 설정
# terraform {
#     # 필요한 공급자 명시
#     required_providers {
#         google = {
#             source  = "hashicorp/google"
#             version = "4.51.0"
#         }
#     }
# }

# Google Cloud Platform (GCP) 프로바이더 설정
provider "google" {
    credentials = file("multi-cloud-406002-88bcf6b25331.json")  # GCP 서비스 계정 키 파일 경로

    project = "multi-cloud-406002"    # GCP 프로젝트 ID
    region  = "us-central1"           # 지역 설정
    zone    = "us-central1-a"         # 존 설정
}

# GCP 가상 머신 인스턴스 생성
resource "google_compute_instance" "vm_instance" {
    name         = "terraform-instance2"    # 인스턴스 이름
    machine_type = "f1-micro"               # 머신 타입
    metadata = {
        ssh-keys = "sjk1364:${file("KEY/multi-cloud-406002.pub")}"  # SSH 키 설정
    }

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"  # 부팅 디스크 이미지
        }
    }

    network_interface {
        network = "default"        # 기본 네트워크 사용
        access_config {
        }
    }
}

# GCP 가상 머신 인스턴스의 공용 IP 주소 출력
output "gcp_vm_public_ip" {
    value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}