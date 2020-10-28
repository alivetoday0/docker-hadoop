## 개발 환경
 - java 11
 - hadoop 2.10.1
### Dependecncy
 - [alivetoday0/ubuntu-ssh-java11](https://github.com/alivetoday0/ubuntu-ssh-java11)

## 실행 방법
 1. docker image 생성
    이미지 이름을 변경하면 docker-compose.yml 파일에 정의한 이미지 이름을 변경해야 한다. 자세한 설명은 [설정 - docker-compose.yml]를 참고해 주세요.
```bash
docker build -t hadoop-spark:1.0 hadoop-spark/.
```

 2. hadoop 실행
 ```bash
 docker-compose up -d
 ```
 3. 로그 확인
 ```bash
 docker-compose logs -f
 ```
 4. hadoop 종료
 ```bash
 docker-compose down
 ```

## hadoop 테스트
1. master 컨테이너에 접속한다.
```bash
docker exec -it master /bin/bash
```
2. hdfs에 폴더 및 파일 업로드 한다.
```bash
hadoop fs -mkdir -p /test
hadoop fs -put /opt/hadoop/LICENSE.txt /test
hadoop fs -ls /test
```

3. 예제 프로그램 실행 (wordcount)
```bash
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.1.jar wordcount /test /test_out
hadoop fs -cat /test_out/*
```

## spark
http://localhost:28080`

### 테스트
```bash
spark-submit --deploy-mode=cluster \
--class org.apache.spark.examples.SparkPi \
$SPARK_HOME/examples/jars/spark-examples_2.11-2.4.7.jar 10
```

## 설정
### Dockerfile
 1. alivetoday0/ubuntu-ssh-java11 이미지에 정의된 환경은 다음과 같다.
    ubuntu 운영 체제에 다음 프로그램을 설치되어 있다.
     - java 11
     - openssh-server, openssh-client
     - curl    

    ssh 통신은 키를 발급하며 호스트 키를 검사하지 않도록 설정을 변경하였다.
     - 설정 파일 : /etc/ssh/ssh_config
     - 변경된 속성 : StrictHostKeyChecking no

### docker-compose.yml
 1. Docker 이미지 생성할 때에 이미지명을 변경하면 다음 속성도 같이 변경한다.
 ```shell
 x-hadoop_base: &hadoop_base
    image: [변경된 이미지명]
 ```
