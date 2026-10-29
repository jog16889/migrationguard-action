# MigrationGuard GitHub Action

Review the SQL migrations changed in a pull request before they reach production. MigrationGuard flags
statements that can destroy data, lock tables or break rolling deployments — `DROP`/`TRUNCATE`,
`UPDATE`/`DELETE` without `WHERE`, risky type changes, PostgreSQL indexes without `CONCURRENTLY` — and
explains a safer approach for each one, as inline annotations on the pull request.

Analysis runs on the runner: no database connection, no SQL uploaded anywhere.

```yaml
name: Migrations
on: pull_request
jobs:
  migrationguard:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0
      - uses: jog16889/migrationguard-action@v1
```

| Input | Default | Description |
|---|---|---|
| `fail-on` | `high` | Fail the job on `critical`, `high`, `medium`, `low` or `info` risks, or never with `none`. |
| `base` | pull request base | Git ref to compare with. On `push`, every SQL file is checked. |
| `paths` | `.` | Space-separated files or directories to check. |
| `sarif` | `false` | Also upload results to GitHub code scanning (needs `security-events: write`). |
| `version` | `1.4.1` | MigrationGuard CLI version. |

A `.migrationguard.yml` at the repository root sets the dialect, minimum severity, disabled rules and
ignored paths. In-source suppressions (`-- migrationguard:disable RULE_ID`) work as in the IDE.

## Free and Pro

The action runs MigrationGuard's Free rules. It also tells you how many more risks
[MigrationGuard Pro](https://plugins.jetbrains.com/plugin/34107-migrationguard) would flag — unsafe
`NOT NULL`, volatile defaults, renames during rolling deploys, constraint changes and MySQL table rebuilds —
which you review in IntelliJ IDEA Ultimate or DataGrip. Pro includes a 7-day free trial.

## Other CI systems

Any runner with Java 21 can use the CLI directly:

```bash
curl -fsSL https://technofystore-legal.jog16889.workers.dev/cli/migrationguard-cli-1.4.1.jar -o migrationguard-cli.jar
java -jar migrationguard-cli.jar check --base origin/main
```

The CLI is provided under the [MigrationGuard EULA](https://technofystore-legal.jog16889.workers.dev/eula).
Support: support@callsiq.com
