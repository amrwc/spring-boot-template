# Spring Boot Template

[![Docker](https://github.com/amrwc/spring-boot-template/workflows/Docker/badge.svg)](https://github.com/amrwc/spring-boot-template/actions)
[![Unit and Integration Tests](https://github.com/amrwc/spring-boot-template/workflows/Unit%20and%20Integration%20Tests/badge.svg)](https://github.com/amrwc/spring-boot-template/actions)

In this template:

- Spring Boot,
- PostgreSQL,
- Docker,
- GitHub workflows:
  - Docker setup, and
  - unit and integration tests of the Spring Boot application.

This template has been bootstrapped using [this Spring Initializr
configuration][spring_initializr].

## Setup

### Migrations

See the [Database Migrations][db_migrations] document.

### Docker

```console
./bin/run.sh [--apply-migrations --cache-from <cache_image_tag> --debug --detach --no-cache --suspend]
```

The application is now listening at `http://localhost:8080`. If the `--debug`
option has been used, the debugger is listening on port `8000`.

#### Clean

```console
./bin/teardown.sh [--include-cache --include-db]
```

## Test

### Unit tests

```console
./gradlew build && ./gradlew test
```

### Integration tests

```console
./gradlew build && ./bin/integration_tests.sh
```

## API

### `/api/welcome`

#### GET `[/<id>]`

Returns a welcome message with the given ID.

Path variables:

- `id` – primary key of the `WELCOME_MESSAGES` table. Default: `1`

##### Example

```console
# {"id":2,"content":"Foo"}
curl http://localhost:8080/api/welcome/2
```

#### POST

Stores a new welcome message in the database.

Request body:

- `content` – welcome message content.

##### Example

```console
curl \
    --request POST \
    --header 'Content-Type: application/json' \
    --data '{"content": "Bar"}' \
    http://localhost:8080/api/welcome
```

## Caveats

- The `--suspend` option in `setup.sh` doesn't seem to work – something's wrong
  with the `8000` port when the application is suspended, and the debugger
  fails to connect.
- There are two Dockerfiles. It's to improve caching the layers of the build
  image. It's difficult to support proper caching of the build image in a
  multi-stage Dockerfile setup without mounting the root directory as a volume,
  or at least the `.gradle/` and `build/` directories.
  - This approach _vastly_ improves building times during local development.
    The build image layers are cached, and combining it with storing Gradle
    cache in a Docker volume, compilation times are reduced.
  - Another approach is to use `docker build --target build_img_alias.`, but it
    causes the subsequent `docker build .` to rebuild the layers of the build
    image, though they'd be cached. Look up previous solutions in the Docker
    workflow to see how it worked using this method.
   - No support for Docker Compose. It's hard to support a Docker Compose setup
     without mounting the root directory as a volume in both the build and main
     image to pass the JAR file between them. There's no `docker cp` equivalent
     at the time of this writing.

## White-label clean-up

Places around the project that need renaming.

<details>

<summary>
Click here to expand
</summary>

1. .github/workflows/docker.yml:
   - `MAIN_IMAGE: 'renameme'`
   - `url='http://localhost:8080/api/welcome/1'`
1. bin/:
   1. integration_tests.sh:
      - `MAIN_IMAGE='renameme'`
   1. pgadmin.sh:
      - `MAIN_IMAGE='renameme'`
   1. run.sh:
      - `MAIN_IMAGE='renameme'`
   1. teardown.sh:
      - `MAIN_IMAGE='renameme'`
1. docker/:
   1. Dockerfile:
      - `FROM openjdk:11-jre-buster AS renameme`
   1. postgres-envars.list:
      - `POSTGRES_DB=renameme`
1. src/:
   1. Package name:
      - `src/main/java/me/rename/renameme`
      - `src/test/java/me/rename/renameme`
   1. main/resources/:
      1. application.yml:
         - `url: 'jdbc:postgresql://renameme-database:5432/renameme'`
      1. liquibase.properties:
         - `url=jdbc:postgresql://localhost:5432/renameme`
      1. log4j2.xml:
         - `fileName="log/renameme.log"`
         - `filePattern="log/renameme-%d{yyyy-MM-dd}-%i.log.gz"`
         - `<IfFileName glob="log/renameme-*.log.gz"/>`
   1. test/resources/:
      1. application.yml:
         - `url: 'jdbc:postgresql://127.0.0.1:5432/renameme'`
      1. log4j2.xml:
         - `fileName="log/test/renameme.log"`
         - `filePattern="log/test/renameme-%d{yyyy-MM-dd}-%i.log.gz"`
         - `<IfFileName glob="log/test/renameme-*.log.gz"/>`
1. build.gradle:
   - `group: 'me.rename'`
1. settings.gradle:
   - `rootProject.name = 'renameme'`

</details>

[spring_initializr]: https://start.spring.io/#!type=gradle-project&language=java&platformVersion=2.4.2.RELEASE&packaging=jar&jvmVersion=11&groupId=me.rename&artifactId=renameme&name=renameme&description=&packageName=me.rename.renameme&dependencies=devtools,lombok,web,data-jpa,liquibase,postgresql,validation
[db_migrations]: ./docs/database-migrations.md
