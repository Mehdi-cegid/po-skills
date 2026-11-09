---
name: po-grill
description: Grill a PO on a product idea in French, building the Notion Glossaire and a PRD draft as you go.
disable-model-invocation: true
---

Interview the PO relentlessly until you reach a shared understanding of the product idea, building the Glossaire and a PRD draft as you go. Call the Skill tool for "po-glossary" before the first round and apply it throughout.

The PO databases live under the **PO hub** page named in `~/.po-skills/config.md`; when the file is missing, stop and tell the user to run `/setup-po-skills`.

Write in French: every message to the user and everything written to Notion.

## The design tree

Map the idea as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the PO's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<titre de la question>** : <corps de la question, éventuellement sur plusieurs paragraphes, avec des choix multiples>

➡️ <ta recommandation>

---

❓ **Q2** - **<titre de la question>** : <corps de la question>

➡️ <ta recommandation>
```

Word each question so « oui » accepts your recommended answer.

Each round the PO answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round.

## The PRD

Anchor the session to a page in the `PRD` database. The glossary links and research notes attach to it while you grill, and `to-prd` writes or edits its body at the end.

- If the PO names an existing PRD, read it before the first round. When its `Statut` is `Abandonné`, tell the PO and ask whether to take it up again; on « oui », set `Statut: Brouillon` and continue. Its `Questions pour le PO` open the frontier (on an older PRD, the PO-side questions in `Questions ouvertes`).
- Otherwise, the first round settles the PRD name and its `Domaine`. Create the **draft** as soon as both are answered, with `Statut: Brouillon` and `Propriétaire` set to the Notion user you're connected as.

## Facts and decisions

The _decisions_ are the PO's: put each to them and wait. Finding _facts_ is your job; ask the PO only for what you can't look up.

A question about a business rule, a regulation, what a provider supports, or how the product behaves today is a **fact**. Invoke `po-research` in the background with the question, what the PO has said on the subject, and the draft URL. A running research is an unsettled prerequisite: only the questions downstream of it wait, so ask the rest of the frontier now.

When it reports back:

- **Answered**: use the finding in your recommendation and cite its note.
- **Conflict** (between sources, or a source against the PO) or **rule/code gap**: put it to the PO in the next round, quoting each side with its source. The PO decides; a gap the PO calls a bug goes to the PRD's `Questions pour les devs`, and an **écart documenté** comes with its ADR's reason, so the PO decides knowing why the code differs.
- **Inaccessible source**: tell the PO right away, naming the source and the reason, and ask whether to continue without it or who can grant access.
- **Hors registre** source: ask the PO in the next round whether to add it to the registry; on « oui », invoke `po-add-source` with its URL, what the research found in it, and the draft URL.

How the product behaves today, when neither the PO, the Sources, nor the code settles it (no project covers it, or the finding stays « à confirmer »), becomes an **assumption to verify**: note it for the PRD and move on. The dev grill checks it against the code.

## Done

Done when the frontier is empty (every branch of the design tree visited, nothing left silently assumed), every question from the PRD's `Questions pour le PO` is answered or kept open by the PO with who to ask, every resolved term is in the Glossaire, and every `po-research` run has reported back. Confirm with the PO that you've reached a shared understanding, then tell them to run `/to-prd` in this same conversation.
