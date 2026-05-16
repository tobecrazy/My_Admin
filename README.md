# My Admin

Rails 8 admin application built with ActiveAdmin and Devise.

## Tech Stack

- Ruby `3.4.8`
- Rails `~> 8.1.3`
- ActiveAdmin + Devise
- SQLite3
- Importmap + Stimulus + Turbo

## Project Structure

- `app/`: application code (`models/`, `controllers/`, `views/`, `jobs/`, `helpers/`)
- `app/admin/`: ActiveAdmin resources and dashboards
- `app/javascript/`: Stimulus/importmap JavaScript code
- `app/assets/`: stylesheets and JavaScript assets
- `config/`: routes, environments, initializers, deploy config
- `db/`: migrations, schemas, seeds
- `test/`: Minitest suite and fixtures

## Prerequisites

- Ruby `3.4.8` (see `.ruby-version`)
- Bundler
- SQLite3

## Local Setup

1. Install dependencies and prepare the app:

```bash
bin/setup
```

2. Create/migrate the database (if needed):

```bash
bin/rails db:prepare
```

3. Seed initial data:

```bash
bin/rails db:seed
```

A default admin user is created:

- Email: `admin@example.com`
- Password: `password`

Report rows are also seeded from `db/mock/reports.json`.

## Run the App

Start development services:

```bash
bin/dev
```

Or run Rails server directly:

```bash
bin/rails server
```

## Routes

- Admin login and pages are mounted by ActiveAdmin/Devise
- Health check endpoint: `GET /up`

## Testing

Run the full test suite:

```bash
bin/rails test
```

Run one test file:

```bash
bin/rails test test/models/admin_user_test.rb
```

## Linting and Security Checks

Run style checks:

```bash
bin/rubocop
```

Run security static analysis:

```bash
bin/brakeman
```

Check gem vulnerabilities:

```bash
bin/bundler-audit
```

Run the local CI pipeline config:

```bash
bin/ci
```

## Deployment

This app includes Docker/Kamal configuration:

- `Dockerfile`
- `config/deploy.yml`

Review deployment settings before first release.

## Docker

Build and run with Docker Compose:

```bash
docker compose up -d --build
```

Or use the helper script:

```bash
./runMe.sh
```

`runMe.sh` builds/starts Docker Compose and opens `http://localhost:3300/admin` in your default browser.
You can override the URL:

```bash
APP_URL=http://localhost:3300 ./runMe.sh
```

On container start, `bin/docker-entrypoint` runs:

- `bin/rails db:prepare`
- `bin/rails db:seed`

So the default admin user and mock report data are loaded automatically in the container database.

## Contributing

- Follow RuboCop Rails Omakase style (`.rubocop.yml`)
- Keep changes small and logically scoped
- Add/update tests for behavior changes
- For UI/admin changes, include screenshots in PRs
