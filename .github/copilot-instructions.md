# Copilot Instructions for KIN

## Project Overview

KIN is a shared hub for a music collective — a calm external memory and attention space where the group's music lives, remembers itself, and reflects what people collectively return to. It reduces coordination overhead and decision fatigue for an AuDHD group by making shared musical attention visible and easy to re-engage with.

Refer to `CONCEPT.md` for the full product vision, design principles, and conceptual model.

Refer to `ROADMAP.md` for the phased delivery plan. Mark tasks as complete in the roadmap as work is finished.

## Tech Stack

- **Framework:** Ruby on Rails 8.0 (module name: `Kin`)
- **Ruby version:** Check `.ruby-version` or Gemfile
- **Database:** SQLite3 (via `sqlite3` gem; stored in `storage/`)
- **Frontend:** Hotwire (Turbo + Stimulus), Importmap (no Node.js/bundler), Tailwind CSS (via `tailwindcss-rails`), DaisyUI (component library)
- **Asset pipeline:** Propshaft
- **Background jobs:** Solid Queue
- **Caching:** Solid Cache
- **WebSockets:** Solid Cable
- **Deployment:** Kamal (Docker-based), Thruster
- **Testing:** RSpec, Capybara, Selenium
- **Linting:** RuboCop (Rails Omakase style), Brakeman (security)

## Design Principles

These principles from `CONCEPT.md` should guide all implementation decisions:

- **Convention over enforcement** — features guide behaviour, they don't mandate it
- **Affordances, not authority** — the system suggests, never prescribes
- **Reflection over optimisation** — surface patterns, don't push agendas
- **Low friction beats cleverness** — simplicity wins over sophistication
- **Nothing breaks if ignored for months** — the system must be resilient to disuse

## Domain Model

The core domain concepts are:

- **Users** — members of the collective; all interaction is internal by default
- **Songs** — the identity of a piece of music; an anchor for related creative work
- **Artefacts** — audio files associated with a song, typed as:
  - **Mix** — a listenable representation at a point in time
  - **Contribution** — an isolated or partial part supporting a mix
  - **Master** — a release-oriented render
- **Collections** — lightweight virtual groupings of songs (personal or shared)
- **Share Links** — capability-based unguessable URLs for external sharing of a single artefact

Artefacts may be **attached** to other artefacts (derivation/support relationships). A song may have a designated **main mix**.

## Code Conventions

### Rails

- Follow Rails 8 conventions and defaults
- Use Rails Omakase RuboCop style (see `rubocop-rails-omakase`)
- Use `config.load_defaults 8.0` conventions
- Place application code under standard Rails directories
- Use `lib/` for non-autoloaded code (tasks, etc.); autoloaded via `config.autoload_lib`

### Frontend

- Use Hotwire (Turbo Frames, Turbo Streams) for dynamic UI — avoid custom JavaScript where Turbo suffices
- Use Stimulus controllers sparingly for client-side behaviour
- Use Importmap for JavaScript dependencies (no npm/yarn)
- Style with Tailwind CSS utility classes and DaisyUI components
- Prefer DaisyUI semantic component classes (e.g. `btn`, `card`, `modal`) over raw Tailwind where a suitable component exists
- Keep the UI calm, minimal, and low-friction — reflecting the product's design ethos

### Testing — TDD, Always

**Test-driven development is mandatory.** No production code is written without tests.

- **Write the test first**, then write the minimum code to make it pass, then refactor
- Every model, controller, job, mailer, and service must have corresponding test coverage
- Write tests using RSpec (not Minitest)
- Place specs in the standard `spec/` directory structure
- Use system specs (Capybara + Selenium) for integration/UI testing
- Use fixtures (or factories) for test data
- When adding a feature: start with a failing spec that describes the desired behaviour
- When fixing a bug: start with a failing spec that reproduces it
- When refactoring: ensure existing specs pass before and after

### Database

- SQLite3 for all environments
- Database files live in `storage/`
- Use standard Rails migrations

## AI Features

KIN treats musical metadata as **human-owned**, not machine-owned. AI is only a helper:

- AI suggestions (key, tempo, lyrics) are **optional and on-demand**
- Suggestions may be accepted, modified, or ignored
- AI never writes data automatically or authoritatively
- Implement AI features as explicit user-triggered actions, never background processes

## External Integrations

### Dropbox

- Purpose: durable off-site redundancy with independent access
- KIN mirrors its structure to Dropbox (songs, mixes, artefacts)
- Dropbox is a faithful readable mirror, not a source of intent
- Unrecognised files in Dropbox are left untouched, shown as "unrecognised" in KIN, never deleted

### External Sharing

- Share links are capability-based (unguessable URLs) pointing to a single artefact
- External viewers can listen only — no browsing, commenting, or collection access
- External listens are tracked separately from internal attention signals

## Development

- Run the dev server: `bin/dev` (starts Rails server + Tailwind watcher via `Procfile.dev`)
- Run tests: `bundle exec rspec`
- Run system tests: `bundle exec rspec spec/system`
- Run linter: `bin/rubocop`
- Run security scan: `bin/brakeman`
- Database setup: `bin/rails db:setup`

## Git Workflow

- All feature and bug fix work is done in branches off `main`
- Branches are merged into `main` via GitHub pull requests
- Do not commit directly to `main`

## Living Documentation

This file, `CONCEPT.md`, `ROADMAP.md`, and `README.md` are living documents. When development work changes the domain model, introduces new conventions, or shifts the product's scope, propose updates to the relevant documents as part of the work. Mark tasks as complete in `ROADMAP.md` as they are finished.
