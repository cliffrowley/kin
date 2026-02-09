# KIN

## Purpose

**KIN** is a shared hub for a music collective.

It exists to act as a **shared external memory and attention space** — a calm place where the group’s music:

* lives
* remembers itself
* reflects what people collectively return to

KIN reduces coordination overhead, decision fatigue, and rediscovery cost for an AuDHD group by making shared musical attention visible and easy to re-engage with.

## Core Vision

> A shared external brain for the collective.

KIN should:

* contain all music in one place
* make it easy to listen and leave contextual feedback
* gently surface which pieces are attracting attention
* support convergence on rehearsal, finishing, or release decisions without enforcing process

The system adapts to behaviour rather than prescribing roles or workflows.

## Design Principles

* **Convention over enforcement**
* **Affordances, not authority**
* **Reflection over optimisation**
* **Low friction beats cleverness**
* **Nothing breaks if ignored for months**

Features exist to reduce cognitive load, not to define how people must work.

## Conceptual Model

### People

* Members of the collective
* All interaction is internal by default

### Songs

* Represent the identity of a piece of music
* Act as an anchor for related creative work
* Multiple interpretations may coexist under the same song

### Artefacts

Artefacts are audio files associated with a song.

Each artefact has a **type**:

* **Mix** — a listenable representation of the song at a point in time
* **Contribution** — an isolated or partial part intended to support a mix
* **Master** — a more final or release-oriented render

Artefacts exist in a single shared space per song, but may be **related to one another**.

## Relationships Between Artefacts

Artefacts may be **attached** to other artefacts.

Attachments express derivation or support:

* a mix may attach to another mix to indicate it was built from it
* a contribution may attach to the mix it supports
* multiple artefacts may attach to the same parent

Attachments are optional and descriptive. They do not imply correctness, ownership, or obligation.

At the song level, only **top-level mixes** are shown by default. Attached artefacts are revealed in context.

This keeps the listening surface calm while preserving creative history.

## Main Mix

A song may have one designated **main mix**.

The main mix represents the current shared or working intent. Selection follows group convention and trust rather than system rules.

## Interaction Model

### Listening

* Members can browse and listen to mixes
* Listening is a lightweight, repeatable signal of attention

### Feedback

* Comments are attached to artefacts
* Feedback is contextual to a specific mix or contribution

### Assistive Suggestions (On Demand)

KIN treats musical metadata as **human-owned**, not machine-owned.

Attributes such as:

* starting key
* tempo (BPM)
* lyrics

are set and edited by people.

When editing a mix, a member may optionally ask the system to **suggest values** using AI, for example:

* guessing a starting key or tempo
  n- proposing draft lyrics with timestamps

These suggestions:

* are optional
* may be accepted, modified, or ignored
* can be re-run or overridden at any time

AI exists only as a helper at the point of editing, never as an automatic or authoritative process.

### Collections

KIN supports **collections**: lightweight, virtual groupings of songs.

Collections exist to:

* group songs around an idea or focus
* share context without explanation overhead
* support rehearsal, rewriting, or release planning

Collections may be personal or shared. Songs may appear in multiple collections.

Collections are descriptive, not prescriptive.

## Attention & Importance

KIN reflects what matters to the collective by observing behaviour over time.

Signal:

* Listening

The system surfaces patterns such as:

* what is returned to repeatedly
* what is being explored
* what is being left behind

How importance is calculated is intentionally left open.

## Default Views

KIN should make it easy to answer:

* *What should we probably listen to or play next?*
* *Which pieces seem worth investing more time in?*
* *What directions are emerging organically?*

Likely default lenses:

* Songs ordered by attention
* Song detail view showing top-level mixes first
* Attached artefacts revealed in context

## External Sharing

KIN supports **external sharing via KIN-issued links**.

External sharing exists to:

* share a specific artefact with someone outside the collective
* gather informal feedback or interest
* do so without onboarding external users or exposing the wider archive

### Share Links

* Share links point to a single artefact
* Links are capability-based (unguessable URLs)
* Links may be time-limited or indefinite
* Links can be revoked at any time

### Scope & Behaviour

* External viewers can listen only
* No browsing, commenting, or collection access
* Sharing does not alter internal organisation or attention signals

### Tracking

* KIN records listens via each share link
* Link-level listening is kept distinct from internal attention

Delivery and hosting details are intentionally unspecified at this level.

## Dropbox Integration

Dropbox serves a **single, deliberate purpose** within KIN: **durable off-site redundancy with independent access**.

Dropbox ensures that:

* audio files are not lost (backup in the traditional sense)
* files remain accessible even if KIN is unavailable

Dropbox is not part of KIN’s coordination or decision-making model.

### Mirrored Structure

The Dropbox folder mirrors KIN’s internal structure.

* Songs, mixes, and attached artefacts are reflected into Dropbox
* The structure is maintained by KIN
* Dropbox is treated as a faithful, readable mirror of the system’s state

This ensures that anyone browsing Dropbox can still understand the material without KIN.

### Relationship to KIN

* KIN writes to Dropbox to maintain the mirror
* KIN may read from Dropbox for recovery or reconciliation
* Dropbox is not treated as a source of intent or organisation

KIN is the canonical home for artefacts **conceptually**; Dropbox is the canonical home for files **operationally**.

### Unrecognised Files

KIN anticipates that files may occasionally appear in Dropbox that do not correspond to known artefacts.

Such files are:

* left untouched
* shown as **unrecognised** within KIN
* never deleted or altered automatically

Unrecognised files simply remain visible.

Resolution, if any, is a human decision and may occur outside KIN entirely (for example, by removing or relocating the file in Dropbox and importing it properly later).

KIN’s responsibility is limited to visibility and recoverability, not resolution.
