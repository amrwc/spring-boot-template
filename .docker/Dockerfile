FROM openjdk:11-jre-buster
ARG JAR_FILE=build/libs/*.jar
VOLUME /tmp
EXPOSE 8080
COPY ${JAR_FILE} /app.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]
