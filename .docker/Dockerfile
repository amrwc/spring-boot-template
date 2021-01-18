##############################################################################
############################# Build the project ##############################
##############################################################################
FROM gradle:jdk11 AS build_container

# Mount the cache from the previous builds. If the cache volume doesn't exist,
# create it before running `docker build`:
# docker volume create --name gradle-cache
VOLUME gradle-cache /home/gradle/.gradle

# The following two lines are equivalent to:
# mkdir -p /home/gradle/project/src/main
# cp -r ./src/main/* /home/gradle/project/src/main
WORKDIR /home/gradle/project/src/main
COPY src/main .

WORKDIR /home/gradle/project
COPY build.gradle .
COPY settings.gradle .
RUN chown gradle:gradle --recursive .

USER gradle
RUN gradle build -x test

##############################################################################
############################## Run the project ###############################
##############################################################################
FROM openjdk:11-jre-buster

EXPOSE 8000
EXPOSE 8080
RUN addgroup --system spring && adduser --system --no-create-home --ingroup spring spring

WORKDIR /home/project
COPY --from=build_container /home/gradle/project/build/libs/*.jar app.jar
COPY .docker/entrypoint.sh entrypoint.sh
RUN chown spring:spring --recursive .
RUN chmod 0554 entrypoint.sh

ARG debug="false"
ENV DEBUG="${debug}"
ARG suspend="false"
ENV SUSPEND="${suspend}"

USER spring
ENTRYPOINT ["./entrypoint.sh"]
