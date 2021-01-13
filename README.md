# Spring Boot Template

In this template:

- Spring Boot,
- PostgreSQL, and
- Docker.

## Generate using Spring Initializr

This template has been bootstrapped using
[this Spring Initializr configuration][1].

## Setup

1. Rename the group and package name.
   1. Directory structure:
      - `src/main/java/me/rename/renameme`,
      - `src/test/java/me/rename/renameme`.
   1. Class names:
      - `src/main/java/me/rename/RenamemeApplication`,
      - `src/test/java/me/rename/RenamemeApplicationTest`.
   1. `src/main/resources/application.properties`:
      - `spring.datasource.url=jdbc:postgresql://postgresql-database:5432/renameme`,
      - `logging.level.me.rename=DEBUG`,
      - `logging.file.name=${logging.file.path}/renameme.log`.
   1. `build.gradle`:
      - `group: 'me.rename'`
   1. `settings.gradle`:
      - `rootProject.name = 'renameme'`

[1]: https://start.spring.io/#!type=gradle-project&language=java&platformVersion=2.4.1.RELEASE&packaging=jar&jvmVersion=11&groupId=me.rename&artifactId=renameme&name=renameme&description=&packageName=me.rename.renameme&dependencies=devtools,lombok,web,data-jpa,liquibase,postgresql
