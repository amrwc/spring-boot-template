FROM gradle:jdk11 AS build_container
WORKDIR /home/gradle/project/src/main
# Equivalent to `cp -r ./src/main/* /home/gradle/project/src/main`
COPY --chown=gradle:gradle src/main .
WORKDIR /home/gradle/project
COPY --chown=gradle:gradle build.gradle .
COPY --chown=gradle:gradle settings.gradle .
RUN gradle build -x test

FROM openjdk:11-jre-buster
EXPOSE 8080
COPY --from=build_container /home/gradle/project/build/libs/*.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
