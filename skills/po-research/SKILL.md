---
name: po-research
description: Research a product fact in the Sources registry and the team's repos, and attach a cited note to the PRD in Notion. Use for a business rule, a regulation, what a provider supports, or how the product behaves today.
---

Run this in a **background sub-agent** so the grill keeps going; where the harness has no background agents, run it inline. The caller passes the question, what the PO said on the subject, and the PRD draft URL.

The PO databases live under the **PO hub** page named in `~/.po-skills/config.md`; when the file is missing, report that to the caller and stop.

Write in French: every message to the user and everything written to Notion.

### 1. Pick the sources

Query the `Sources` database for rows whose `Domaine` is the PRD's domain or `Transverse`, and keep those whose `Description` bears on the question, plus their `Sources liées` that do. When the question touches how the product behaves today, do the same with the `Projets` database, and invoke `po-repos` for each kept project's mirror. Done when every kept source and project is either opened or recorded as **inaccessible** with the reason (no access, 404, login required, unreadable format, git sign-in missing).

### 2. Answer from them

Answer from the opened sources only, citing each claim with its URL and section. When a source summarises another, follow the claim back to the source that owns it.

- **Autorité**: a `Canonique` source wins over an `Informatif` one. Still report the disagreement.
- **Conflict**: two `Canonique` sources disagree, or a source contradicts what the PO said. Record both sides with their citations and leave the decision to the PO.
- **Stale**: a source whose `Dernière revue` is over a year old. Use it, and flag it.
- **Code**: before searching a mirror, read the project's glossary: the `Glossaire projet` path, or else a `GLOSSARY-MAP.md` or `GLOSSARY.md` at the mirror's root. With a map, open the context whose description matches the question. Search the code under the term the glossary gives for the concept; with no project glossary, under the likely code names of the Glossaire `Terme`. Cite project, file, line, and the mirror's commit. Mirrors are read-only (see `po-repos`): read and search, nothing more. The code shows what the product *can* do, so mark each claim **Implémenté**, or **Implémenté (à confirmer)** when a feature flag, configuration, or stored setting could change the answer in production.
- **Rule/code gap**: the code does something other than a `Canonique` source says. Record both sides and check the ADRs; it is a bug, an outdated rule, or an **écart documenté**, and the PO decides which.
- **ADR**: the project's decision records, in `docs/adr/` at the mirror's root and in the `docs/adr/` of each context its `GLOSSARY-MAP.md` lists. Open them for a rule/code gap, and for a question about whether something is possible or why it can't be done; open only the ADRs whose title or content matches the concept. An ADR that explains a gap makes it an **écart documenté**: the code differs on purpose, for the reason the ADR gives. Cite each as **Décision technique (ADR-NNNN)**. It explains why and leaves a `Canonique` rule standing, so a conflict stays the PO's decision, now with the reason. Follow `superseded by` to the replacing ADR; skip `deprecated` ones.
- **Outside the registry**: when the registry leaves the question open, go to external primary sources (official regulation texts, a provider's own documentation), mark each such claim `Hors registre`, and suggest the source for the registry.

Done when every part of the question is answered, a conflict, a rule/code gap, or explicitly unanswered.

### 3. Write the note

Create the note as a child page of the PRD draft, titled `Recherche : <question>`, using the template below. Add every registry source you cited to the draft's `Sources` relation, and every project to its `Projets` relation. With no draft, return the note in the conversation.

```md
**Question** : <la question>

**Réponse courte** : <une ou deux phrases, ou « Pas de réponse dans les sources »>

## Constats
- <affirmation> — [<Nom de la source>](<url>), <section>

## Conflits
- <source A> dit … ; <source B> (ou le PO) dit … — décision PO requise

## Implémenté
- <comportement> — <projet>, `<fichier>:<ligne>` @ <commit> — Implémenté / Implémenté (à confirmer)

## Écarts règle / code
- <source> dit … ; le code fait … — bug, règle obsolète, ou écart documenté (Décision technique ADR-NNNN : <raison>) ? décision PO requise

## Décisions techniques
- <contrainte> — <projet>, Décision technique ADR-NNNN `<fichier>` @ <commit> — <raison>

## Sources et projets inaccessibles
- [<Nom>](<url>) — <raison>
- <projet> (<Dépôt>) — <raison>

## Sources à revoir
- [<Nom>](<url>) — dernière revue le <date>

## Hors registre
- <affirmation> — [<source externe>](<url>) — à ajouter au registre ?
```

Leave out the sections with nothing in them, except `Sources et projets inaccessibles`: write « Aucun » there so the reader knows every kept source and project was opened.

### 4. Report back

Return to the caller: the short answer, every conflict and rule/code gap, every inaccessible source or project, and the note URL.
