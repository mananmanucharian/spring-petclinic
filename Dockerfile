# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Spring Petclinic JAR file into the container
COPY target/spring-petclinic-*.jar /app/spring-petclinic.jar

# Expose the port the application runs on
EXPOSE 8080

# Run the Spring Petclinic application
ENTRYPOINT ["java", "-jar", "/app/spring-petclinic.jar"]
