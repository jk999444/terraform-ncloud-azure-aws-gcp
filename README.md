# 테라폼을 이용한 aws - ncloud - azure - gcp 가상서버 생성



## terraform 설치
```
1. 리눅스 우분투 버전으로 설치를 진행 합니다
```
```
2. 터미널 창에 아래 명령어를 입력을 해줍니다
```
```   
3. 아래 명령어를 한줄씩 써주세요
$ sudo  apt-get 업데이트 &&  sudo  apt-get  install -y gnupg 소프트웨어 속성-공통
$ wget -O- https://apt.releases.hashicorp.com/gpg | \gpg --dearmor | \sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
$ gpg --no-default-keyring \--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \--fingerprint
$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \sudo tee /etc/apt/sources.list.d/hashicorp.list
$ sudo apt update
$ sudo apt-get install terraform
$

4. terraform version 명령어를 입력후 버전 정보가 나오면 설치확인을 할수 있습니다
```

5. 설치가 제대로 되지 않았다면 링크를 참조해 따라해보시길 바랍니다. <[https://developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)>   

### aws 사용법
```
1. aws 사이트에 들어가 로그인을 합니다. -> <https://ap-northeast-2.console.aws.amazon.com/console/home?region=ap-northeast-2>
```
```
2. 로그인을 한 후 보안자격증명을 들어간 뒤 엑세스 키 값을 생성 합니다
   -> <https://us-east-1.console.aws.amazon.com/iam/home#/security_credentials?section=IAM_credentials>
```
```
3.    
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
