# Spring Boot Template

In this template:

- Spring Boot,
- PostgreSQL, and
- Docker.

This template has been bootstrapped using
[this Spring Initializr configuration][1].

## Setup

### Migrations

The migrations from `src/main/resources/db/changelog-main.xml` are applied
automatically by default by Spring Boot under the hood.

### `docker run`

```console
./bin/setup.sh [--debug|--suspend, --no-cache]
./bin/start.sh
```

The application is now listening at `http://localhost:8080`. If the `--debug`
option has been used, the debugger is listening on port `8000` as should be
confirmed in the logs.

#### Clean

```console
./bin/teardown.sh [--include-cache, --exclude-db]
```

### `docker-compose`

```console
docker-compose --file docker/docker-compose.yml up --build
```

The application is now listening at `http://localhost:8080`.

#### Debug

```console
docker-compose --file docker/docker-compose.yml build --build-arg debug=true [--build-arg suspend=true]
docker-compose --file docker/docker-compose.yml up
```

The debug port can be accessed at `http://localhost:8000`.

#### Clean

```console
docker-compose --file docker/docker-compose.yml down
```

### Gradle cache

To speed up the builds, reuse Gradle cache between runs.

It's included in the `setup.sh` script, but not when running `docker-compose`.

```console
docker volume create --name gradle-cache
```

Prune the cache:

```console
docker volume rm gradle-cache
```

## White-label clean-up

Places around the project that need renaming.

<details>

<summary>
Click here to expand
</summary>

1. `.github/workflows/docker.yml`:
   - This string appears twice: `URL: 'http://localhost:8080/api/welcome/1'`
1. `docker-compose.yml`:
   - `renameme-service`
   - `container_name: renameme`
   - `image: renameme`
   - `- renameme-network`
   - `container_name: renameme-database`
   - `- POSTGRES_DB=renameme`
   - `renameme-network:`
1. `docker/postgres-envars.list`:
   - `POSTGRES_DB=renameme`
1. Directory structure:
   - `src/main/java/me/rename/renameme`
   - `src/test/java/me/rename/renameme`
1. `src/main/resources/application.properties`:
   - `spring.datasource.url=jdbc:postgresql://renameme-database:5432/renameme`
1. `src/main/resourcees/log4j2.xml`:
   - `fileName="log/renameme.log"`
   - `filePattern="log/renameme-%d{yyyy-MM-dd}-%i.log.gz"`
   - `<IfFileName glob="log/renameme-*.log.gz"/>`
1. `src/test/resourcees/log4j2.xml`:
   - `fileName="log/test/renameme.log"`
   - `filePattern="log/test/renameme-%d{yyyy-MM-dd}-%i.log.gz"`
   - `<IfFileName glob="log/test/renameme-*.log.gz"/>`
1. `build.gradle`:
   - `group: 'me.rename'`
1. `settings.gradle`:
   - `rootProject.name = 'renameme'`

</details>

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
  with the `8000` port when the application is suspended.

[1]: https://start.spring.io/#!type=gradle-project&language=java&platformVersion=2.4.1.RELEASE&packaging=jar&jvmVersion=11&groupId=me.rename&artifactId=renameme&name=renameme&description=&packageName=me.rename.renameme&dependencies=devtools,lombok,web,data-jpa,liquibase,postgresql
