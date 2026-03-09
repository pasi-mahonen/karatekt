# Karate Template

This repository contains a Karate knowledge-transfer flow that implements the same task API business flow 7 different ways, from the most direct example to a more reusable CRUD-style test design.

## Task API Spec

The KT targets the authenticated Task API exposed here:

- [Swagger UI - V2 Authenticated API (JWT)](https://api.testauto.app/swagger-ui/index.html?urls.primaryName=V2%20-%20Authenticated%20API%20(JWT))

## KT Structure

The KT is organized under `src/test/java/examples/kt`:

- Part A: `01-task-crud-basic.feature` - minimal inline auth, payload, and assertions
- Part B: `02-task-crud-outline.feature` - `Scenario Outline` with example rows
- Part C: `03-task-crud-background.feature` - shared setup moved into `Background`
- Part D: `04-task-crud-json-payload.feature` - payload moved to JSON template file
- Part E: `05-task-crud-csv-data.feature` - test data loaded from CSV with filtering
- Part F: `06-task-crud-java-utils.feature` - Java utility generates dynamic data
- Part G: `07-task-crud-final.feature` - helper-based auth and verification with full CRUD

## KT Summary Table

| Part | File name | What it demonstrates | Auth location | Test data source(s) | Payload handling | Verification style | CRUD coverage |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A | `01-task-crud-basic.feature` | Minimal working Karate test, everything visible | Inline in scenario | Hardcoded | Inline JSON | Inline match | CREATE |
| B | `02-task-crud-outline.feature` | Data-driven execution via Scenario Outline and Examples | Inline in scenario | Examples table | Inline JSON | Inline match | CREATE (multiple rows) |
| C | `03-task-crud-background.feature` | Structure via Background and reduced repetition | Background | Examples or inline | Inline JSON | Inline match | CREATE |
| D | `04-task-crud-json-payload.feature` | Read JSON payload from file and inject variables | Background | Examples or inline | `read(payload.json)` plus variable injection | Inline match | CREATE |
| E | `05-task-crud-csv-data.feature` | CSV-driven tests and filtering by env and run flag | Background | CSV (filtered) | `read(payload.json)` plus variable injection | Inline match | CREATE |
| F | `06-task-crud-java-utils.feature` | Extensibility via custom Java utility for random data | Background | CSV or Examples plus Java-generated values | Payload file plus randomization | Inline match | CREATE |
| G | `07-task-crud-final.feature` | Final reusable framework-style example with helpers and full lifecycle | Helper called from Background via `callonce` | CSV filtered plus Examples plus Java | Payload files plus parameterization | Helper feature for verification | CREATE -> READ -> UPDATE -> DELETE |

## Run The KT Suite

Run the whole KT suite with the dedicated runner:

```powershell
mvn test -Dtest=KtRunner
```

## Run One KT File By Tag

Each KT feature has a unique part tag so you can run them one by one from Maven on Windows PowerShell.

Use this pattern:

```powershell
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-a"
```

Concrete commands:

```powershell
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-a"
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-b"
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-c"
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-d"
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-e"
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-f"
mvn test -Dtest=KtRunner "-Dkarate.options=--tags @part-g"
```

You can also run the earlier sample feature by tag:

```powershell
mvn test -Dtest=ExamplesTest "-Dkarate.options=--tags @test2"
```

## Notes

- In Karate, tags must start at column 1 in the feature file.
- In PowerShell, quote the full `-Dkarate.options=...` argument when it contains spaces.
- The KT examples target `https://api.testauto.app` and use the shared credentials from `karate-config.js`.

Refer to the [Karate Documentation](https://docs.karatelabs.io/getting-started/why-karate) for additional details
