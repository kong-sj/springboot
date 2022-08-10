FROM adoptopenjdk/openjdk8

#ARG HOST_JAR_FILE_PATH=./hello-spring-0.0.1-SNAPSHOT.jar # Jar 경로 환경변수 설정.
COPY ROOT.jar /ROOT.jar

# 해당 Docker image로 Container를 생성/실행하는 시점에 아래의 커맨드가 수행되도록한다.
CMD ["java",  "-jar", "/ROOT.jar"]
