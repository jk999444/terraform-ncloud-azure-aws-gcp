# Azure Provider 설정
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # 사용할 Terraform Azure Provider의 공급자 소스
      version = "~>2.0"              # 사용할 Terraform Azure Provider의 버전, "~>2.0"은 2.0 이상의 버전을 사용하겠다는 의미
    }
  }
}

# Azure Provider 구성
provider "azurerm" {
  features {} # 특별한 기능은 지정되지 않았지만 필요한 경우 추가할 수 있습니다.
}

# 리소스 그룹 생성 (존재하지 않을 경우)
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "myResourceGroup"      # 리소스 그룹의 이름
    location = "koreacentral"         # 리소스 그룹의 위치 (Azure 지역)

    tags = {
        environment = "Terraform Demo"  # 리소스 그룹에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}

# 가상 네트워크 생성
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"                                     # 가상 네트워크의 이름
    address_space       = ["10.0.0.0/16"]                              # 가상 네트워크의 주소 공간
    location            = "koreacentral"                              # 가상 네트워크의 위치 (Azure 지역)
    resource_group_name = azurerm_resource_group.myterraformgroup.name # 가상 네트워크가 속한 리소스 그룹의 이름에 대한 참조

    tags = {
        environment = "Terraform Demo"  # 가상 네트워크에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}

# 서브넷 생성
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"                                  # 서브넷의 이름
    resource_group_name  = azurerm_resource_group.myterraformgroup.name # 서브넷이 속한 리소스 그룹의 이름에 대한 참조
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name # 서브넷이 속한 가상 네트워크의 이름에 대한 참조
    address_prefixes     = ["10.0.0.0/24"]                           # 서브넷의 주소 공간

    # 다양한 설정 및 옵션을 추가할 수 있음
}

# 공용 IP 생성
resource "azurerm_public_ip" "myterraformpublicip" {
    name                = "myPublicIP"                                  # 공용 IP의 이름
    location            = "koreacentral"                                # 공용 IP의 위치 (Azure 지역)
    resource_group_name = azurerm_resource_group.myterraformgroup.name  # 공용 IP가 속한 리소스 그룹의 이름에 대한 참조
    allocation_method   = "Dynamic"                                     # 공용 IP의 동적 할당

    tags = {
        environment = "Terraform Demo"  # 공용 IP에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}

# 출력: 가상 머신의 공용 IP 주소
output "vm_public_ip" {
    value = "${azurerm_public_ip.myterraformpublicip.*.ip_address}"  # 가상 머신의 공용 IP 주소를 출력
}

# 네트워크 보안 그룹 및 규칙 생성
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"                     # 네트워크 보안 그룹의 이름
    location            = "koreacentral"                            # 네트워크 보안 그룹의 위치 (Azure 지역)
    resource_group_name = azurerm_resource_group.myterraformgroup.name # 네트워크 보안 그룹이 속한 리소스 그룹의 이름에 대한 참조

    security_rule {
        name                       = "SSH"                             # 보안 규칙의 이름
        priority                   = 1001                              # 보안 규칙의 우선 순위
        direction                  = "Inbound"                         # 트래픽 방향 (이 경우 인바운드)
        access                     = "Allow"                           # 트래픽 허용
        protocol                   = "Tcp"                             # 프로토콜 (이 경우 TCP)
        source_port_range          = "*"                               # 출발지 포트 범위 (모든 포트 허용)
        destination_port_range     = "22"                              # 목적지 포트 범위 (SSH 허용)
        source_address_prefix      = "*"                               # 출발지 주소 범위 (모든 주소 허용)
        destination_address_prefix = "*"                               # 목적지 주소 범위 (모든 주소 허용)
    }

    tags = {
        environment = "Terraform Demo"  # 네트워크 보안 그룹에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}

# 네트워크 인터페이스 생성
resource "azurerm_network_interface" "myterraformnic" {
    name                    = "myNIC"                                  # 네트워크 인터페이스의 이름
    location                = "koreacentral"                          # 네트워크 인터페이스의 위치 (Azure 지역)
    resource_group_name     = azurerm_resource_group.myterraformgroup.name # 네트워크 인터페이스가 속한 리소스 그룹의 이름에 대한 참조

    ip_configuration {
        name                          = "myNicConfiguration"          # IP 구성의 이름
        subnet_id                     = azurerm_subnet.myterraformsubnet.id # 서브넷 ID에 대한 참조
        private_ip_address_allocation = "Dynamic"                      # 개인 IP의 동적 할당
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id # 공용 IP ID에 대한 참조
    }

    tags = {
        environment = "Terraform Demo"  # 네트워크 인터페이스에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}

# 보안 그룹을 네트워크 인터페이스에 연결
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id        # 연결할 네트워크 인터페이스의 ID
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id  # 연결할 네트워크 보안 그룹의 ID
}

# 고유한 저장소 계정 이름 생성
resource "random_id" "randomId" {
    keepers = {
        resource_group = azurerm_resource_group.myterraformgroup.name  # 저장소 계정 이름을 고유하게 만들기 위한 기준 (리소스 그룹 이름)
    }

    byte_length = 8  # 무작위로 생성될 ID의 길이
}

# 부팅 진단을 위한 저장소 계정 생성
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"                # 저장소 계정의 이름 (고유한 무작위 ID 포함)
    resource_group_name         = azurerm_resource_group.myterraformgroup.name   # 저장소 계정이 속한 리소스 그룹의 이름에 대한 참조
    location                    = "koreacentral"                                # 저장소 계정의 위치 (Azure 지역)
    account_tier                = "Standard"                                    # 저장소 계정의 티어 (표준)
    account_replication_type    = "LRS"                                         # 저장소 계정의 복제 유형 (로컬 복제)

    tags = {
        environment = "Terraform Demo"  # 저장소 계정에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}

# SSH 키 생성
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"    # RSA 알고리즘 사용
  rsa_bits = 4096      # 4096 비트로 SSH 키 생성
}

# 출력: 생성된 SSH 키 (민감 정보로 표시)
output "tls_private_key" { 
    value     = tls_private_key.example_ssh.private_key_pem  # 생성된 SSH 개인 키를 출력
    sensitive = true  # 출력을 민감 정보로 표시하여 보안에 유의
}
# 가상 머신 생성
resource "azurerm_linux_virtual_machine" "myterraformvm" {
    name                  = "myVM"                                             # 가상 머신의 이름
    location              = "koreacentral"                                   # 가상 머신의 위치 (Azure 지역)
    resource_group_name   = azurerm_resource_group.myterraformgroup.name      # 가상 머신이 속한 리소스 그룹의 이름에 대한 참조
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]     # 가상 머신의 네트워크 인터페이스 ID
    size                  = "Standard_DS1_v2"                                # 가상 머신의 크기 및 성능 SKU

    os_disk {
        name              = "myOsDisk"                                       # 운영 체제 디스크의 이름
        caching           = "ReadWrite"                                      # 디스크 캐싱 유형
        storage_account_type = "Premium_LRS"                                 # 디스크의 저장소 계정 유형
    }

    source_image_reference {
        publisher = "Canonical"                                              # 이미지 발행자
        offer     = "UbuntuServer"                                          # 이미지 제공
        sku       = "18.04-LTS"                                              # 이미지 SKU (버전)
        version   = "latest"                                                 # 이미지의 최신 버전
    }

    computer_name  = "myvm"                                                  # 가상 머신의 컴퓨터 이름
    admin_username = "azureuser"                                             # 가상 머신 관리자 사용자 이름
    disable_password_authentication = true                                 # 패스워드 인증 비활성화 (SSH 키 인증 사용)

    admin_ssh_key {
        username       = "azureuser"                                        # SSH 키로 로그인할 사용자 이름
        public_key     = tls_private_key.example_ssh.public_key_openssh    # 사용자의 공개 SSH 키
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint  # 부팅 진단을 위한 저장소 계정 URI
    }

    tags = {
        environment = "Terraform Demo"                                       # 가상 머신에 대한 태그, 식별 및 구성을 위해 사용됨
    }
}