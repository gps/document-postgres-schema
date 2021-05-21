# Document Postgres Schema

This GitHub Action generates database schema documentation for a PostgreSQL Database in Markdown.

This action assumes that you have a fully migrated database running as a service in your GitHub Actions Workflow.

## How To Use

Create a file in your repo in which you hand-write documentation for your schema. 

For example, `docs/db-schema.md`:

```

# Database tables

# Users table
The `Users` table stores user records.

<<<-Users->>>
```

This action will replace all occurrences of `<<<-Users->>>` with a markdown table that describes the structure of the database table identified by what is in between `<<<-` and `->>>`. In the above example, the generated documentation would look like this:


```markdown
# Database tables

## Users table

The `Users` table stores user records.

| Name              | Type                     | Default | Nullable | Children        | Parents         | Comment |
| ----------------- | ------------------------ | ------- | -------- | --------------- | --------------- | ------- |
| id                | uuid                     |         | false    | public.Accounts |                 |         |
| firstName         | varchar(255)             |         | false    |                 |                 |         |
| lastName          | varchar(255)             |         | true     |                 |                 |         |
| otherNames        | varchar(255)             |         | true     |                 |                 |         |
| phoneNumber       | varchar(100)             |         | true     |                 |                 |         |
| emailId           | varchar(255)             |         | true     |                 |                 |         |
| dateOfBirth       | date                     |         | true     |                 |                 |         |
| modifiedAt        | timestamp with time zone | now()   | false    |                 |                 |         |
| selectedAccountId | uuid                     |         | true     |                 | public.Accounts |         |
| profileImageURL   | varchar(255)             |         | true     |                 |                 |         |

### Constraints

| Name                 | Type        | Definition                                                  |
| -------------------- | ----------- | ----------------------------------------------------------- |
| fk_selectedaccountid | FOREIGN KEY | FOREIGN KEY ("selectedAccountId") REFERENCES "Accounts"(id) |
| Users_pkey           | PRIMARY KEY | PRIMARY KEY (id)                                            |

### Indexes

| Name       | Definition                                                          |
| ---------- | ------------------------------------------------------------------- |
| Users_pkey | CREATE UNIQUE INDEX "Users_pkey" ON public."Users" USING btree (id) |

## Undocumented Tables

The following tables have not been documented. Please document them if needed.

- Projects
- Notes
```

## Inputs

### PATH_TO_DB_SCHEMA_FILE

Path to hand written db schema documentation file relative the project root directory.

**Required**

### PATH_TO_GENERATED_DB_SCHEMA_FILE

Path where the generated db schema documentation file has to be written to relative the project root directory.

**Required**

### DATABASE_USER_NAME

PostgreSQL database username.

**Required**

### DATABASE_PASSWORD

PostgreSQL database password.

**Required**

### DATABASE_HOST

PostgreSQL database hostname.

### DATABASE_PORT

PostgreSQL database port.

**Required**

### DATABASE_NAME

PostgreSQL database name.

**Required**

## Example Usage

```yml
name: Document DB Schema

on: [pull_request]

jobs:
  Document-DB-Schema:

    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:12.4
        env:
          POSTGRES_USER: bcn
          POSTGRES_PASSWORD: Bcn@1234
          POSTGRES_DB: bcn
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 54322:5432

    steps:

      # Note: The next two steps assume you’re using a Java gradle project & flyway to migrate.
      # This need not be the case - as long as you have a migrated database, the action should work.

      - name: Set up JDK 1.8
        uses: actions/setup-java@v1.4.3
        with:
          java-version: 1.8

      - name: Flyway migrate
        run: ./gradlew -Dflyway.configFiles=postgresql/flyway/local.conf flywayMigrate -i

      - name: Generate database schema
        uses:  gps/document-postgres-schema@master
        with:
          PATH_TO_DB_SCHEMA_FILE: "docs/db-schema.md"
          PATH_TO_GENERATED_DB_SCHEMA_FILE: "docs/generated-db-schema.md"
          DATABASE_USER_NAME: "foobar"
          DATABASE_PASSWORD: "foobar@1234"
          DATABASE_HOST: "postgres"
          DATABASE_PORT: 5432
          DATABASE_NAME: foobar

      - name: Commit Changes
        uses: EndBug/add-and-commit@v6
        with:
          message: 'Generated db schema documentation'
          token: ${{ secrets.CUSTOM_GH_TOKEN }}
```

## Gratitude

This project uses the wonderful [tbls](https://github.com/k1LoW/tbls) and [prettier](https://github.com/prettier/prettier) projects.
