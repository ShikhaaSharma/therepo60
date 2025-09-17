FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
COPY target/demo-app-0.0.1-SNAPSHOT.jar /app/app.jar
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
