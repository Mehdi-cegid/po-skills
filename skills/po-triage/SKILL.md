---
name: po-triage
description: Triage which of the PO's PRDs need work, pick one to resume, or drop a draft. Use when a PO asks where they stand on their PRDs (« où j'en suis ? », « sur quoi je travaille ? »), which PRD to pick up, or wants to abandon a draft.
---

List the PRDs that need the PO's attention and let them pick one or drop a draft. Then **hand off**: `/po-grill` is user-invoked, so the PO types it.

The PO databases live under the **PO hub** page named in `~/.po-skills/config.md`; when the file is missing, stop and tell the user to run `/setup-po-skills`.

Write in French: every message to the user and everything written to Notion.

## Process

### 1. List the PRDs

Read the `PRD` database. Default scope: rows whose `Propriétaire` is the Notion user you're connected as, with `Statut` `En attente PO` or `Brouillon`. When the PO asks for the team's PRDs, use the same statuses with any owner.

For each row, one line: name, `Statut`, how many questions sit in `Questions pour le PO` (zero when it reads « Aucune » or holds nothing), and how long ago it was last edited.

Order: `En attente PO` first, then `Brouillon`. Within each group, oldest last edit first. End the list on « Nouveau PRD ».

After a list scoped to the PO's own PRDs, offer to also show the team's (any owner).

Empty list → say so and offer `/po-grill` for a new idea.

Done when the list is shown or reported empty.

### 2. Act on the pick

- A PRD → end on the exact command `/po-grill <nom du PRD>` for the PO to type in this same conversation.
- « Nouveau PRD » → end on `/po-grill`.
- Drop a `Brouillon` → confirm with the PO, then set `Statut: Abandonné`.

Done when the PO has the next command to type, or the dropped draft reads `Abandonné` in Notion.
