# Repository Guidelines

## Project Structure & Module Organization
This repository is a Rails 8 admin app (ActiveAdmin + Devise).
- `app/`: core application code (`models/`, `controllers/`, `views/`, `jobs/`, `helpers/`), admin screens in `app/admin/`.
- `app/javascript/`: Stimulus/importmap JavaScript entrypoints and controllers.
- `app/assets/`: stylesheets and JS assets for Rails/ActiveAdmin.
- `config/`: environment, routes, initializers, and deployment settings.
- `db/`: migrations, schema files, and seeds.
- `test/`: Minitest suite (`models/`, `fixtures/`, and shared setup in `test_helper.rb`).

## Build, Test, and Development Commands
Use project binstubs to ensure consistent versions.
- `bin/setup`: install gems and prepare local app state.
- `bin/dev`: run the app in development.
- `bin/rails server`: start Rails server directly.
- `bin/rails db:prepare`: create/migrate database.
- `bin/rails test`: run all tests.
- `bin/rails test test/models/admin_user_test.rb`: run a single test file.
- `bin/rubocop`: run style/lint checks.
- `bin/brakeman`: run Rails security static analysis.
- `bin/bundler-audit`: check gem vulnerability advisories.
- `bin/ci`: run CI pipeline config (`config/ci.rb`).

## Coding Style & Naming Conventions
- Follow RuboCop Rails Omakase rules (`.rubocop.yml`); run `bin/rubocop` before opening a PR.
- Use 2-space indentation in Ruby files.
- Classes/modules: `CamelCase`; files, methods, variables: `snake_case`.
- Rails conventions apply: singular model class (`AdminUser`) with plural table name (`admin_users`).
- Keep admin configuration in `app/admin/*.rb`; avoid putting domain logic there.

## Testing Guidelines
- Framework: Minitest (with Capybara/Selenium for system tests).
- Place tests under `test/` mirroring app paths (for example, `app/models/admin_user.rb` -> `test/models/admin_user_test.rb`).
- Prefer focused unit/model tests first; add system tests for UI/admin flows.
- Keep fixtures in `test/fixtures/*.yml` minimal and readable.

## Commit & Pull Request Guidelines
No commit history exists yet, so use this convention going forward:
- Commit format: imperative, concise subject (e.g., `Add validation for admin email`).
- Keep commits small and logically scoped.
- PRs should include: purpose, key changes, test evidence (`bin/rails test`, `bin/rubocop`), and screenshots for admin UI changes.
- Link related issues/tasks when available and call out migrations or config changes explicitly.
