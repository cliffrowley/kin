# KIN Roadmap

Each phase is independently deployable and delivers real value. Phases 1–4 are the core product; 5–7 are extensions that can be prioritised based on the collective's needs.

---

## Phase 1 — Foundation & Core Domain

Auth, songs, audio upload & playback.

- [x] **Authentication (Users)**
  - [x] `User` model (email, name, provider, uid)
  - [x] Google OAuth2 via OmniAuth (`omniauth-google-oauth2`)
  - [x] Session controller handling OAuth callback and logout
  - [x] Authentication concern for controllers
  - [x] Basic Tailwind/DaisyUI layout shell (navbar, content area)

- [x] **Songs**
  - [x] `Song` model (title, notes, timestamps)
  - [x] Songs CRUD controller & views (index, show, new/edit)

- [x] **Artefacts & Audio Upload**
  - [x] `Artefact` model (belongs_to :song, type enum: mix/contribution/master, title, notes)
  - [x] Active Storage attachment for audio files
  - [x] Upload UI on the song show page
  - [x] Inline audio player for playback

- [x] **Main Mix Designation**
  - [x] Song `has_one :main_mix` reference to an artefact
  - [x] UI to set/change the main mix on the song page

---

## Phase 2 — Relationships & Structure

Artefact hierarchy, comments, and song metadata.

- [x] **Artefact Attachments (parent/child)**
  - [x] Self-referential `parent_id` on Artefact
  - [x] Song show page shows top-level mixes by default, reveals attached artefacts on expand

- [x] **Feedback (Comments)**
  - [x] `Comment` model (polymorphic `commentable`, belongs_to :user, body)
  - [x] Comment thread UI on song and artefact detail
  - [x] Turbo Streams for live comment updates

- [ ] **Song Metadata**
  - [ ] Add key, tempo (BPM), and lyrics fields to Song
  - [ ] Editable on song detail page

---

## Phase 3 — Collections & Navigation

Grouping songs and improving the browsing experience.

- [ ] **Collections**
  - [ ] `Collection` model (title, description, personal flag, belongs_to :user for personal)
  - [ ] `CollectionSong` join model
  - [ ] Collections CRUD; add/remove songs
  - [ ] Songs can appear in multiple collections

- [ ] **Improved Navigation & Views**
  - [ ] Dashboard/home view with recent activity
  - [ ] Song search/filter
  - [ ] DaisyUI-styled responsive layout polish

---

## Phase 4 — Attention & Surfacing

Making shared attention visible.

- [ ] **Listen Tracking**
  - [ ] `Listen` model (belongs_to :artefact, belongs_to :user, timestamp)
  - [ ] Record listens via Stimulus controller on play
  - [ ] Non-blocking, Turbo-friendly

- [ ] **Attention Signals & Ordering**
  - [ ] Song-level aggregation of listen counts and recency
  - [ ] Default song index ordered by attention
  - [ ] Subtle visual indicators (heat/recency badges)

- [ ] **Reflection Views**
  - [ ] "Returning to" — songs re-listened after a gap
  - [ ] "Exploring" — recently active but new
  - [ ] "Fading" — previously active, now quiet

---

## Phase 5 — External Sharing

Controlled sharing outside the collective.

- [ ] **Share Links**
  - [ ] `ShareLink` model (belongs_to :artefact, token, expires_at, revoked_at)
  - [ ] Public controller serving a minimal listen-only page (no auth)
  - [ ] Create/revoke share links from the artefact UI

- [ ] **External Listen Tracking**
  - [ ] `ExternalListen` model (belongs_to :share_link, IP/UA, timestamp)
  - [ ] Tracked separately from internal listens
  - [ ] Simple stats visible to members on the share link

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

- [ ] **Unrecognised File Visibility**
  - [ ] Job to scan Dropbox for files not matching known artefacts
  - [ ] Surface unrecognised files in a UI panel (never delete)

---

## Phase 7 — AI Suggestions

Optional, on-demand AI assistance for metadata.

- [ ] **AI Suggestion Service**
  - [ ] Service object abstracting the AI provider
  - [ ] Methods: suggest key, suggest tempo, suggest lyrics

- [ ] **UI Integration**
  - [ ] "Suggest" buttons on song/artefact edit forms
  - [ ] Results shown as proposals — user accepts, edits, or dismisses
  - [ ] Never written automatically
