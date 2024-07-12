FROM openjdk:11-jre-slim
COPY target/myapp.jar /usr/app/
WORKDIR /usr/app
ENTRYPOINT ["java", "-jar", "myapp.jar"]
