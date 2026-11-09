---
name: po-ask
description: "Answer a PO's questions about the PO skills: which one to run, when, and in what order. Use when a PO asks how to start, what to do next, or how to get something done with the PO hub, Glossaire, Sources, Projets, or PRDs."
---

# PO skills guide

Answer the PO's question about the PO skills, then **hand off**: end on the exact command the PO types next and what it will produce. You answer and route; the PO runs the skills.

Write in French: every message to the user and everything written to Notion.

## Process

### 1. Locate the PO

When the answer depends on where the PO stands, look before answering:

- `~/.po-skills/config.md` missing → the PO hasn't set up yet; the answer starts with `/setup-po-skills`.
- A question about which of their PRDs need work, where they stand on them, or which to pick up → hand off `/po-triage`.

Done when you know the PO's stage, or the question doesn't depend on it.

### 2. Answer

Answer from the map and the situations below. Keep it short: the command, when to run it, what it needs first, and what it produces. When several steps are needed, give them in order, numbered.

Done when the PO has the next command to type, or the question is about something no PO skill does and you've said who handles it.

## The map

Skills the PO types:

| Commande | Quand | Produit |
|---|---|---|
| `/setup-po-skills` | Once per PO, per machine, before anything else; again when the hub page is outdated | Joins the PO hub (paste a colleague's hub link) and brings it up to date, or creates it; mirrors the repos |
| `/po-triage` | To see which PRDs need work, pick one to resume, or drop a draft | The list of PRDs to act on, then the `/po-grill` command to type next |
| `/po-grill [nom du PRD]` | To design a feature, or to resume a PRD by naming it | Grilling rounds in French, a PRD draft (`Brouillon`), Glossaire entries, research notes |
| `/to-prd` | Right after `/po-grill`, **in the same conversation** | The PRD body, or edits to a resumed one; `Statut: Prêt pour dev` once no question for the PO is left |
| `/po-add-source <liens>` | Any time, to register business-rules docs or git repos | `Sources` / `Projets` rows, after a short grill on domains, authority, and overlaps |

Skills that run on their own, so the PO never types them: `po-glossary` (challenges terms during `/po-grill`; the PO can also just ask to fix a Glossaire term), `po-research` (looks up facts during `/po-grill`), `po-repos` (keeps the read-only code mirrors up to date).

The usual order: `/setup-po-skills` → `/po-add-source` (optional, to seed the registry) → `/po-grill` → `/to-prd`. `/po-triage` sits before `/po-grill` when the PO needs to pick which PRD to resume.

## Situations

- **New idea** → `/po-grill`. The first round names the PRD and its `Domaine`.
- **Which PRDs need work**, where the PO stands on them, or which to pick → `/po-triage`. It ends on the `/po-grill` command to type.
- **Grill finished, conversation still open** → `/to-prd`. It synthesizes the conversation, so it needs the grill in context.
- **Resuming a known PRD**: conversation lost, a `Brouillon`, or `En attente PO` (the devs added questions to its `Questions pour le PO`) → `/po-grill <nom du PRD>`; it reads the PRD before the first round and starts with its `Questions pour le PO`, if any. Then `/to-prd` in that conversation: it records the answers in `Réponses du PO` and sets `Prêt pour dev` once none are left.
- **Dropping a draft** → `/po-triage`, then confirm to set `Statut: Abandonné`. Taking an `Abandonné` PRD up again → `/po-grill <nom du PRD>`; it asks before setting it back to `Brouillon`.
- **`Prêt pour dev` or `Ticketé`** → the PO side is done; the devs take it from there.
- **A doc or repo to register** → `/po-add-source` with the links. During a grill, the agent proposes sources found outside the registry on its own.
- **A product fact** (business rule, regulation, provider, how the product behaves today) → ask it inside `/po-grill`: research attaches its cited note to the PRD draft.
- **A repo reported inaccessible** → fix git sign-in or repo access on its git host; the next skill that needs the code retries.
- **Notion not connected** → connect the Notion MCP server (`https://mcp.notion.com/mcp`), then rerun the skill.
- **Changing code, running a project, creating Linear tickets** → a developer's job; the PO skills read code and never change it.
