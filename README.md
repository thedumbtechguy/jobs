# Dev Registry

A catalogue of our developers, what they've built, who they know, and where
they can work next. It grew out of the DevCongress Jobs app.

Built on [Plutonium](https://github.com/radioactive-labs/plutonium-core),
Rails 8.1 and SQLite, and deployed with Kamal. See [docs/DESIGN.md](docs/DESIGN.md)
for the domain model and roadmap.

## Requirements

- Ruby 3.3+ (see `.ruby-version`)
- Node 22.22.3+ or 24.15+, and Yarn 1.x

## Setup

```sh
bin/setup      # installs gems and JS packages, prepares the databases
bin/dev        # web server plus JS/CSS watchers, at http://localhost:3000
bin/rails test
bundle exec standardrb
```

## Where things are

| Path | What |
|---|---|
| `/` | Public pages (main app) |
| `/users/login`, `/users/create-account` | User accounts |
| `/onboarding` | First step after signup: creates a developer profile, a company, or both |
| `/setup/developer/new`, `/setup/company/new` | Create whichever was skipped, or another company |
| `/dashboard` | Signed-in user's home (`packages/dashboard_portal`) |
| `/developer/:handle` | Developer portal, scoped to the user's own profile (`packages/developer_portal`); models in `packages/developers` |
| `/company/:slug` | Company portal, scoped to one company (`packages/company_portal`) |
| `/admins/login`, `/admin` | Admin accounts (TOTP required) and admin portal (`packages/admin_portal`) |
| `/devs`, `/@handle` | Public developer directory and profile pages |
| `/jobs`, `/jobs/:id`, `/companies/:slug` | Public jobs board, job and company pages |
| `/manage/*` | Jobs, errors, Litestream and performance dashboards (admins only) |

Admins can't sign up. Create the first one with:

```sh
EMAIL=you@example.com bin/rails rodauth:admin
```

In development, emails open in the browser through letter_opener.

## Deploy

Kamal, configured in `config/deploy.yml`. All configuration comes from
environment variables; Rails credentials are not used. Export these on the
machine that runs `kamal deploy`; `.kamal/secrets` passes the secret ones through.

| Variable | Required | Purpose |
|---|---|---|
| `DEPLOY_HOST` | yes | Server to deploy to |
| `APP_HOST` | yes | Public hostname, for TLS and `RAILS_DEFAULT_URL` |
| `SECRET_KEY_BASE` | yes | `bin/rails secret` |
| `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY` | yes | From `bin/rails db:encryption:init`. Encrypts invite tokens |
| `ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY` | yes | As above |
| `ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT` | yes | As above |
| `SMTP_ADDRESS`, `SMTP_USERNAME`, `SMTP_PASSWORD` | for email | Outgoing mail (`SMTP_PORT` defaults to 587) |
| `MAIL_FROM` | for email | Sender for app emails, e.g. `Dev Registry <no-reply@devcongress.org>` |
| `LITESTREAM_REPLICA_BUCKET`, `LITESTREAM_ACCESS_KEY_ID`, `LITESTREAM_SECRET_ACCESS_KEY` | for backups | Litestream S3 replica |

The app refuses to boot in production if a required variable is missing.

## Working with Claude

The Plutonium skills are synced into `.claude/skills`. Refresh them after
upgrading the gem with `bin/rails g pu:skills:sync`.
