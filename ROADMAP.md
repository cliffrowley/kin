# KIN Roadmap

Each phase is independently deployable and delivers real value. Phases 1–4 are the core product; 5–7 are extensions that can be prioritised based on the collective's needs.

---

## Phase 1 — Foundation & Core Domain

Auth, songs, audio upload & playback.

- [ ] **Authentication (People)**
  - [ ] `Person` model with email, name, `has_secure_password`
  - [ ] Session controller with login/logout
  - [ ] Authentication concern for controllers
  - [ ] Tests for all auth functionality

- [ ] **Songs**
  - [ ] `Song` model (title, notes, timestamps)
  - [ ] Songs CRUD controller & views (index, show, new/edit)
  - [ ] Basic Tailwind/DaisyUI layout shell (navbar, content area)
  - [ ] Songs index as the root route
  - [ ] Tests for songs CRUD

- [ ] **Artefacts & Audio Upload**
  - [ ] `Artefact` model (belongs_to :song, type enum: mix/contribution/master, title, notes)
  - [ ] Active Storage attachment for audio files
  - [ ] Upload UI on the song show page
  - [ ] Inline audio player for playback
  - [ ] Tests for artefact creation and association

- [ ] **Main Mix Designation**
  - [ ] Song `has_one :main_mix` reference to an artefact
  - [ ] UI to set/change the main mix on the song page
  - [ ] Tests for main mix assignment

---

## Phase 2 — Relationships & Structure

Artefact hierarchy, comments, and song metadata.

- [ ] **Artefact Attachments (parent/child)**
  - [ ] Self-referential `parent_id` on Artefact
  - [ ] Song show page shows top-level mixes by default, reveals attached artefacts on expand
  - [ ] Tests for attachment relationships and scoping

- [ ] **Feedback (Comments)**
  - [ ] `Comment` model (belongs_to :artefact, belongs_to :person, body)
  - [ ] Comment thread UI on artefact detail
  - [ ] Turbo Streams for live comment updates
  - [ ] Tests for commenting

- [ ] **Song Metadata**
  - [ ] Add key, tempo (BPM), and lyrics fields to Song
  - [ ] Editable on song detail page
  - [ ] Tests for metadata editing

---

## Phase 3 — Collections & Navigation

Grouping songs and improving the browsing experience.

- [ ] **Collections**
  - [ ] `Collection` model (title, description, personal flag, belongs_to :person for personal)
  - [ ] `CollectionSong` join model
  - [ ] Collections CRUD; add/remove songs
  - [ ] Songs can appear in multiple collections
  - [ ] Tests for collections

- [ ] **Improved Navigation & Views**
  - [ ] Dashboard/home view with recent activity
  - [ ] Song search/filter
  - [ ] DaisyUI-styled responsive layout polish
  - [ ] Tests for navigation and filtering

---

## Phase 4 — Attention & Surfacing

Making shared attention visible.

- [ ] **Listen Tracking**
  - [ ] `Listen` model (belongs_to :artefact, belongs_to :person, timestamp)
  - [ ] Record listens via Stimulus controller on play
  - [ ] Non-blocking, Turbo-friendly
  - [ ] Tests for listen recording

- [ ] **Attention Signals & Ordering**
  - [ ] Song-level aggregation of listen counts and recency
  - [ ] Default song index ordered by attention
  - [ ] Subtle visual indicators (heat/recency badges)
  - [ ] Tests for attention ordering

- [ ] **Reflection Views**
  - [ ] "Returning to" — songs re-listened after a gap
  - [ ] "Exploring" — recently active but new
  - [ ] "Fading" — previously active, now quiet
  - [ ] Tests for reflection view logic

---

## Phase 5 — External Sharing

Controlled sharing outside the collective.

- [ ] **Share Links**
  - [ ] `ShareLink` model (belongs_to :artefact, token, expires_at, revoked_at)
  - [ ] Public controller serving a minimal listen-only page (no auth)
  - [ ] Create/revoke share links from the artefact UI
  - [ ] Tests for share link lifecycle

- [ ] **External Listen Tracking**
  - [ ] `ExternalListen` model (belongs_to :share_link, IP/UA, timestamp)
  - [ ] Tracked separately from internal listens
  - [ ] Simple stats visible to members on the share link
  - [ ] Tests for external listen tracking

---

## Phase 6 — Dropbox Integration

Automated off-site mirror for durable redundancy.

- [ ] **Dropbox API Client**
  - [ ] Service object wrapping the Dropbox API
  - [ ] Configuration via Rails credentials

- [ ] **Mirror Sync**
  - [ ] Background job (Solid Queue) to mirror uploads to Dropbox
  - [ ] Folder structure: `/<Song Title>/<Artefact Type>/<filename>`
  - [ ] Sync on artefact create/update/delete
  - [ ] Tests for sync jobs

- [ ] **Unrecognised File Visibility**
  - [ ] Job to scan Dropbox for files not matching known artefacts
  - [ ] Surface unrecognised files in a UI panel (never delete)
  - [ ] Tests for unrecognised file detection

---

## Phase 7 — AI Suggestions

Optional, on-demand AI assistance for metadata.

- [ ] **AI Suggestion Service**
  - [ ] Service object abstracting the AI provider
  - [ ] Methods: suggest key, suggest tempo, suggest lyrics
  - [ ] Tests for suggestion service

- [ ] **UI Integration**
  - [ ] "Suggest" buttons on song/artefact edit forms
  - [ ] Results shown as proposals — user accepts, edits, or dismisses
  - [ ] Never written automatically
  - [ ] Tests for suggestion UI flow
