# Architecture

## Spring Boot application

```text
+-------------+            +----------+            +--------------+            +----------+
|             |   Models   |          |   Models   |              |  Entities  |          |
| Controllers | <--------> | Services | <--------> | Repositories | <--------> | Database |
|             |            |          |            |              |            |          |
+-------------+            +----------+            +--------------+            +----------+
```

### Controllers

They expose REST endpoints to be called by external applications.

### Services

They implement the logic for processing incoming and outgoing data.

### Repositories

Persistence layer for communicating with the database.

### Database

Relational database to store the application data.

## Docker

```text
                                +----------------------------+
                                |       Docker Network       |
                                |                            |
+----------------------+        |  +----------------------+  |
|                      |    JAR |  |                      |  |
|   Build Container    | -------+> |    Main Container    |  |
|                      |        |  |                      |  |
+----------------------+        |  +----------------------+  |
           ^                    |             ^              |
     Gradle|cache               |     Entities|              |
           v                    |             v              |
+----------------------+        |  +----------------------+  |
|                      |        |  |                      |  |
|  Build Cache Volume  |        |  |  Database Container  |  |
|                      |        |  |                      |  |
+----------------------+        |  +----------------------+  |
                                |                            |
                                +----------------------------+
```

### Build container

Container for building and packaging the application.

### Build cache volume

Volume for storing build cache. It speeds up each subsequent build, even if the
build container has been destroyed.

### Main container

Container for running the application. It's enclosed in a Docker network along
with the database container.

### Database container

Container running the relational database server.
