##############################################################################
############################# Build the project ##############################
##############################################################################
FROM gradle:jdk11 AS gradle_container

WORKDIR /home/gradle/project
COPY build.gradle gradle.properties settings.gradle ./

ENV GRADLE_USER_CACHE /gradle-cache
RUN gradle build --no-daemon --stacktrace

RUN mkdir -p /home/gradle/project/src/main
COPY src/main /home/gradle/project/src/main
RUN gradle build --no-daemon --stacktrace --exclude-task test

##############################################################################
############################## Run the project ###############################
##############################################################################
FROM openjdk:11-jre-buster AS renameme

EXPOSE 8000
EXPOSE 8080
RUN addgroup --system spring && adduser --system --no-create-home --ingroup spring spring

WORKDIR /home/project
COPY docker/entrypoint.sh entrypoint.sh
COPY --from=gradle_container /home/gradle/project/build/libs/*.jar app.jar
RUN chown spring:spring --recursive .
RUN chmod 0554 entrypoint.sh

ARG debug="false"
ARG suspend="false"
ENV DEBUG="${debug}"
ENV SUSPEND="${suspend}"

USER spring
ENTRYPOINT ["./entrypoint.sh"]
