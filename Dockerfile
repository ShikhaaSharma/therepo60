FROM eclipse-temurin:17-jre-alpine
ARG JAR_FILE=target/demo-app-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
