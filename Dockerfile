# Base image로 openjdk 17을 사용
FROM openjdk:17-ea-slim-buster

# JAR 파일을 컨테이너로 복사
COPY ./build/libs/test-0.0.1-SNAPSHOT.jar /app.jar

# 8080 포트 열기 (스프링 부트 기본 포트)
EXPOSE 8080

# 컨테이너에서 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]