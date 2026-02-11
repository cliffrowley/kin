# KIN

## Purpose

**KIN** is a shared hub for a music collective.

It exists to act as a **shared external memory and attention space** — a calm place where the group’s music:

* lives
* remembers itself
* reflects what users collectively return to

KIN reduces coordination overhead, decision fatigue, and rediscovery cost for an AuDHD group by making shared musical attention visible and easy to re‑engage with.

---

## Core Vision

> A shared external brain for the collective.

KIN should:

* contain all music in one place
* make it easy to listen and leave contextual feedback
* gently surface which pieces are attracting attention
* support convergence on rehearsal, finishing, or release decisions

KIN adapts to behaviour rather than prescribing roles or workflows.

---

## Design Principles

* **Convention over enforcement** — structure guides without policing
* **Affordances, not authority** — the system suggests, never instructs
* **Reflection over optimisation** — behaviour is observed, not gamed
* **Low friction beats cleverness** — clarity over clever models
* **Nothing breaks if ignored for months** — the system remains safe to return to

Features exist to reduce cognitive load, not to define how users must work.

---

## Conceptual Model

### Users

* Members of the collective
* All interaction is internal by default

---

### Songs

A **Song** represents a single creative intent or variation.

Examples:

* the original arrangement of a song
* a slow or alternate version
* a rewrite with different structure or lyrics

If two versions differ meaningfully in composition, tempo, lyrics, or feel, they are treated as **separate Songs**.

A Song:

* is the primary unit of identity and browsing
* hosts the main discussion about that creative intent
* contains its own metadata (lyrics, key, tempo, notes)

There is no requirement to formally link related Songs. Naming conventions may imply lineage where useful.

---

### Artefacts

Artefacts are audio files associated with a Song.

A Song’s artefacts collectively form a **directed tree**, representing the creative evolution of that Song over time.

* Each Song has a single **root artefact** (the initial or base mix)
* New artefacts are created by attaching them to an existing artefact
* Branches naturally represent revisions, alternatives, or parallel exploration

All artefacts are treated uniformly by the system:

* they can be listened to
* they can be commented on
* they can have child artefacts attached

No artefact types are enforced.

Meaning emerges through:

* position within the tree
* relative recency
* naming and discussion context

The system preserves the full tree but does not require users to manage or curate it explicitly.

---

## Relationships Between Artefacts

Artefacts are related by **derivation**, forming a tree structure:

**Song → Root Artefact → Derived Artefacts**

* Each artefact may have zero or more child artefacts
* Child artefacts represent work done *from* their parent
* Branching is encouraged when exploring alternatives

There is no fixed semantic meaning attached to depth or branch shape; these reflect how the group worked at the time.

---

## Current Artefact

At any given time, one artefact may be designated as the **current artefact**.

The current artefact:

* represents the mix considered authoritative for listening
* is what pressing *Play* defaults to
* acts as the natural reference point for new contributions

As work progresses, the current designation may move freely through the tree.

---

## Visibility & Focus

Although the full artefact tree is always preserved, the UI prioritises **situational awareness** rather than structure.

By default, a Song page emphasises:

* the current artefact
* its immediate child artefacts (recent contributions or branches)

Artefacts further from the current position recede visually.

This allows deep structure to exist without overwhelming day‑to‑day use.

For deliberate exploration, the tree may be navigated explicitly via:

* previous / next artefact links
* a dedicated tree or branch visualisation

---

## Listening & Attention

* Members can browse and listen to Songs and artefacts
* Listening is a lightweight, repeatable signal of attention

Listening exists to:

* reflect genuine interest without requiring decisions
* surface what the group naturally returns to

---

## Feedback

* Comments may be attached to Songs or specific artefacts
* Song‑level comments host primary discussion
* Artefact‑level comments capture tactical or contextual feedback

Comments do not influence attention or importance.

---

## Assistive Suggestions (On Demand)

KIN treats musical metadata as **human‑owned**, not machine‑owned.

Song‑level metadata includes:

* lyrics
* starting key
* tempo (BPM)

These values are set and edited by users.

When editing, users may optionally ask the system to **suggest values** using AI, for example:

* estimating starting key or tempo
* drafting lyrics with timestamps

Suggestions:

* are optional
* may be accepted, modified, or ignored
* can be re‑run or overridden at any time

AI acts only as a helper at the point of editing, never as an automatic or authoritative process.

---

## Collections

KIN supports **collections** — lightweight, virtual groupings of Songs.

Collections exist to:

* group Songs around a focus or idea
* share context without explanation overhead
* support rehearsal, rewriting, or release planning

Collections may be personal or shared. Songs may appear in multiple collections.

Collections are descriptive, not prescriptive.

---

## Attention & Importance

KIN reflects what matters to the collective by observing behaviour over time.

Primary signal:

* Listening

The system may surface patterns such as:

* what is returned to repeatedly
* what is being actively explored
* what is being left behind

How importance is calculated is intentionally left open.

---

## External Sharing

KIN supports **external sharing via KIN‑issued links**.

External sharing exists to:

* share a specific artefact with someone outside the collective
* gather informal feedback or interest
* do so without onboarding external users or exposing the wider archive

### Share Links

* Share links point to a single artefact
* Links are capability‑based (unguessable URLs)
* Links may be time‑limited or indefinite
* Links can be revoked at any time

### Scope & Behaviour

* External viewers can listen only
* No browsing, commenting, or collection access
* External listening does not affect internal attention

---

## Dropbox Integration

Dropbox serves a single, deliberate purpose within KIN: **durable off‑site redundancy with independent access**.

Dropbox ensures that:

* audio files are not lost
* files remain accessible even if KIN is unavailable

Dropbox is not part of KIN’s coordination or decision‑making model.

### Mirrored Structure

The Dropbox folder mirrors KIN’s internal structure.

* Songs and artefacts are reflected into Dropbox
* The structure is maintained by KIN
* Dropbox remains readable and understandable without KIN

### Relationship to KIN

* KIN writes to Dropbox to maintain the mirror
* KIN may read from Dropbox for recovery or reconciliation
* Dropbox is not treated as a source of intent or organisation

KIN is the canonical home for Songs and artefacts **conceptually**; Dropbox is the canonical home for files **operationally**.

### Unrecognised Files

Files may occasionally appear in Dropbox that do not correspond to known Songs or artefacts.

Such files are:

* left untouched
* shown as **unrecognised** within KIN
* never deleted or altered automatically

Unrecognised files remain visible.

Resolution, if any, is a human decision and may occur outside KIN entirely.

KIN’s responsibility is limited to visibility and recoverability, not resolution.
