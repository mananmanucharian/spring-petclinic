FROM openjdk:11-jre-slim


WORKDIR /app


COPY target/spring-petclinic-*.jar spring-petclinic.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "spring-petclinic.jar"]

