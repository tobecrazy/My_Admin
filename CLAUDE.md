# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

Rails 8 admin app: ActiveAdmin + Devise on Ruby 3.4.8, SQLite3, Importmap + Stimulus + Turbo. There is no separate JS bundler (no webpack/esbuild) — JS is delivered via importmap.

## Common commands

Use the project binstubs — they pin to the bundled gem versions.

```bash
bin/setup                                    # install gems, prep app
bin/dev                                      # run dev server (currently just `rails server`)
bin/rails db:prepare                         # create + migrate
bin/rails db:seed                            # seeds default admin: admin@example.com / password
bin/rails test                               # full Minitest suite
bin/rails test test/models/admin_user_test.rb        # single file
bin/rails test test/models/admin_user_test.rb:42     # single test by line
bin/rubocop                                  # Rails Omakase style
bin/brakeman                                 # security static analysis
bin/bundler-audit                            # gem CVE check
bin/ci                                       # local CI pipeline (config/ci.rb)
```

## Architecture notes

- **Routing is almost entirely ActiveAdmin.** `config/routes.rb` mounts `devise_for :admin_users` and `ActiveAdmin.routes(self)`; the only hand-written route is `/up` (Rails health check). New admin screens are added by creating files under `app/admin/`, not by editing `routes.rb`.
- **Single user model: `AdminUser`** (`app/models/admin_user.rb`). There is no end-user `User` model — Devise authenticates only admins, scoped to the ActiveAdmin mount point.
- **`app/admin/` is the UI layer for CRUD.** Keep domain logic in `app/models/` (or service objects), not in ActiveAdmin DSL files. `dashboard.rb` is the landing page; per-resource files (e.g. `admin_users.rb`) declare permitted params, filters, and index/show/form blocks.
- **Multi-database in production.** `config/database.yml` defines four SQLite databases in production: `primary`, `cache`, `queue`, `cable`, each with its own migrations path (`db/migrate`, `db/cache_migrate`, `db/queue_migrate`, `db/cable_migrate`). Solid Queue / Solid Cache / Solid Cable run on these. Development and test use a single SQLite file in `storage/`.
- **Styling has two ActiveAdmin entry points** — `app/assets/stylesheets/active_admin.scss` (Sprockets/Propshaft) and `app/javascript/stylesheets/active_admin.scss`. When tweaking admin styles, check which one is actually being served before editing.
- **Deployment via Kamal.** `config/deploy.yml` and `.kamal/` drive container deploys; `Dockerfile` is the production image. The `storage/` directory is the persistent volume (holds all SQLite DBs).

## Conventions

- RuboCop Rails Omakase (`.rubocop.yml`) — run `bin/rubocop` before committing.
- Tests are Minitest; system tests use Capybara/Selenium. Mirror app paths under `test/`.
- `db/mock/` is gitignored scratch space, not part of the schema.
