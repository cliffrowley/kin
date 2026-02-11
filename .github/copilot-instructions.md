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
- **Authentication:** Google OAuth2 via OmniAuth (`omniauth-google-oauth2`)
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
- **Songs** — a single creative intent or variation; if two versions differ meaningfully in composition, tempo, lyrics, or feel, they are separate Songs
- **Artefacts** — audio files associated with a song, forming a directed tree:
  - Each Song has a single **root artefact**
  - New artefacts attach to existing ones (parent/child), forming branches for revisions, alternatives, or parallel exploration
  - Artefacts are **untyped** — meaning emerges from position in the tree, recency, naming, and discussion
  - All artefacts are treated uniformly: they can be listened to, commented on, and have children attached
- **Current artefact** — the artefact designated as authoritative for listening; what pressing Play defaults to; can move freely through the tree
- **Collections** — lightweight virtual groupings of songs (personal or shared)
- **Share Links** — capability-based unguessable URLs for external sharing of a single artefact

## Workflow

- **Approach each section of a roadmap phase as a separate unit of work** — plan, test, implement, and complete one section before moving on to the next
- Do not attempt an entire phase in one go
- **Plan before implementing** — at the start of each unit of work, present a clear plan to the user describing what will be built, the key design decisions, and the steps involved. Wait for the user to approve or adjust the plan before writing any code.

## Engineering Principles

- **KISS** — Keep it simple; prefer straightforward solutions over clever ones
- **YAGNI** — Don't build what isn't needed yet; stick to what the current task requires
- Do not pre-empt future requirements or add speculative features, fields, or abstractions

## Code Conventions

### Rails

- Follow Rails 8 conventions and defaults
- Use Rails Omakase RuboCop style (see `rubocop-rails-omakase`)
- Use `config.load_defaults 8.0` conventions
- Use `:unprocessable_content` (status 422) instead of `:unprocessable_entity`, which is deprecated by Rack
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
- External listening does not affect internal attention signals

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

### Mandatory Branch Procedure

**Before making any code changes**, you MUST:

1. Check the current branch (`git branch --show-current`)
2. If on `main`, create and switch to a descriptive feature branch (e.g. `git checkout -b feature/authentication`)
3. Only then begin making changes

Branch naming convention: `feature/<short-description>` for new work, `fix/<short-description>` for bug fixes.

Commit early and often with clear, concise commit messages. Do not batch all changes into a single commit at the end.

## Living Documentation

This file, `CONCEPT.md`, `ROADMAP.md`, and `README.md` are living documents. When development work changes the domain model, introduces new conventions, or shifts the product's scope, propose updates to the relevant documents as part of the work. Mark tasks as complete in `ROADMAP.md` as they are finished.
