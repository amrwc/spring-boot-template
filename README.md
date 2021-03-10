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

## Documentation

- [Architecture](./docs/architecture.md)
- [Database Inspection](./docs/database-inspection.md)
- [Database Migrations](./docs/database-migrations.md)
- [Design Decisions](./docs/design-decisions.md)
- [Working with `bin` Scripts](./docs/working-with-bin-scripts.md)

## Setup

### GitHub Workflows

Add `CR_PAT` secret to the repository to be able to sign into container
registry. Read more on this in [GitHub's
documentation][github_auth_container_registry].

### Docker

```console
export SPRING_DATASOURCE_URL='jdbc:postgresql://database-container:5432/dbname'
export SPRING_DATASOURCE_USERNAME='spring_user'
export SPRING_DATASOURCE_PASSWORD='SpringUserPassword'

export POSTGRES_URL='jdbc:postgresql://localhost:5432'
export POSTGRES_DB='dbname'
export POSTGRES_USER='postgres'
export POSTGRES_PASSWORD='SuperuserPassword'

./bin/run.py --apply-migrations [--debug]
```

The application is now listening at `http://localhost:8080`. If the `--debug`
option has been used, the debugger is listening on port `8000`.

Defaults such as database and Spring ports, and volume, network, image,
container names can be adjusted inside `./bin/config.ini`.

#### Clean

```console
./bin/teardown.py [--cache --db --network --tmp]
```

### Change `spring_user` database password

```sql
ALTER USER spring_user WITH PASSWORD '<new_password>';
```

## Test

### Unit tests

```console
./gradlew test
```

### Integration tests

```console
./bin/integration_tests.py
```

## API

### `/api/welcome`

#### GET

Returns all welcome messages.

##### Example

```console
# {"id":"c3f7bfa4-fac9-46bd-b139-866e34b1f83f","content":"Foo"}
curl http://localhost:8080/api/welcome
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

## White-label clean-up

Places around the project that need renaming.

<details>

<summary>
Click here to expand
</summary>

1. .github/workflows/docker.yml:
   - `MAIN_IMAGE: 'renameme'`
   - `export POSTGRES_DB='renameme'`
   - `export SPRING_DATASOURCE_URL='jdbc:postgresql://renameme-database:5432/renameme'`
1. bin/:
   1. config.ini:
      - `database_container = renameme-database`
      - `database_test_container = renameme-test-database`
      - `network = renameme-network`
      - `test_network = renameme-test-network`
      - `main_image = renameme`
      - `build_image = renameme-gradle-build`
1. src/:
   1. Package name:
      - `src/main/java/me/rename/renameme`
      - `src/test/java/me/rename/renameme`
   1. main/resources/:
      1. db/changelog/20210310-03--create-readwrite-role.sql:
         - `REVOKE ALL ON DATABASE renameme FROM PUBLIC;`
         - `GRANT CONNECT ON DATABASE renameme TO readwrite;`
         - `--rollback REVOKE CONNECT ON DATABASE renameme FROM readwrite;`
         - `--rollback GRANT ALL ON DATABASE renameme TO PUBLIC;`
      1. log4j2.xml:
         - `fileName="log/renameme.log"`
         - `filePattern="log/renameme-%d{yyyy-MM-dd}-%i.log.gz"`
         - `<IfFileName glob="log/renameme-*.log.gz"/>`
   1. test/resources/:
      1. log4j2.xml:
         - `fileName="log/test/renameme.log"`
         - `filePattern="log/test/renameme-%d{yyyy-MM-dd}-%i.log.gz"`
         - `<IfFileName glob="log/test/renameme-*.log.gz"/>`
1. build.gradle:
   - `group: 'me.rename'`
1. settings.gradle:
   - `rootProject.name = 'renameme'`

</details>

[spring_initializr]:
  https://start.spring.io/#!type=gradle-project&language=java&platformVersion=2.4.2.RELEASE&packaging=jar&jvmVersion=11&groupId=me.rename&artifactId=renameme&name=renameme&description=&packageName=me.rename.renameme&dependencies=devtools,lombok,web,data-jpa,liquibase,postgresql,validation
[github_auth_container_registry]:
  https://docs.github.com/en/packages/guides/migrating-to-github-container-registry-for-docker-images#authenticating-with-the-container-registry
