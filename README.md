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
| `/dashboard` | Signed-in user's portal (`packages/dashboard_portal`) |
| `/company/:slug` | Company portal, scoped to one company (`packages/company_portal`) |
| `/admins/login`, `/admin` | Admin accounts (TOTP required) and admin portal (`packages/admin_portal`) |
| `/manage/*` | Jobs, errors, Litestream and performance dashboards (admins only) |

Admins can't sign up. Create the first one with:

```sh
EMAIL=you@example.com bin/rails rodauth:admin
```

In development, emails open in the browser through letter_opener.

## Deploy

Kamal, configured in `config/deploy.yml`. Set these before deploying:
- `DEPLOY_HOST`: the server.
- `APP_HOST`: the public hostname, used for TLS.
- `RAILS_MASTER_KEY`: in `.kamal/secrets`.

Create credentials with `bin/rails credentials:edit`. This writes
`config/master.key`, which is not committed. Production credentials need:
- `active_record_encryption` keys, from `bin/rails db:encryption:init`. Invite
  tokens are encrypted with them.
- `litestream` bucket credentials, for backups.

## Working with Claude

The Plutonium skills are synced into `.claude/skills`. Refresh them after
upgrading the gem with `bin/rails g pu:skills:sync`.
