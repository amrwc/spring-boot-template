# Spring Boot Template

In this template:

- Spring Boot,
- PostgreSQL, and
- Docker.

This template has been bootstrapped using
[this Spring Initializr configuration][1].

## Setup

### `docker run`

First time:

```console
./setup.sh
```

Subsequent runs:

```console
docker start renameme-database
docker run --rm -it renameme
```

Tear down:

```console
./teardown.sh
```

### `docker-compose`

```console
./gradlew build && docker-compose -f .docker/docker-compose.yml up --build

# Or
./gradlew build && cd .docker && docker-compose up --build
```

The migrations from `src/main/resources/db/changelog` are applied
automatically.

The application is now listening at `http://localhost:8080`.

## Clean up

Rename the group and package name.

<details>

<summary>
Click here to expand
</summary>

1. `docker-compose.yml`:
   - `renameme-service`
   - `container_name: renameme`
   - `image: renameme`
   - `- renameme-network`
   - `container_name: renameme-database`
   - `- POSTGRES_DB=renameme`
   - `renameme-network:`
1. `.docker/postgres-envars.list`:
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
2. `settings.gradle`:
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

[1]: https://start.spring.io/#!type=gradle-project&language=java&platformVersion=2.4.1.RELEASE&packaging=jar&jvmVersion=11&groupId=me.rename&artifactId=renameme&name=renameme&description=&packageName=me.rename.renameme&dependencies=devtools,lombok,web,data-jpa,liquibase,postgresql
