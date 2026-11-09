# Notion schemas

Five databases under the PO hub page. Names and property names are exact: the other skills find each database by name among the hub's children and read properties by name.

Create them in this order so every relation has a target: **Domaines**, **Glossaire**, **Sources**, **Projets**, **PRD**.

## Domaines

The glossary map: one row per domain, plus one row named `Transverse` for sources that span every domain.

| Property | Type | Notes |
|---|---|---|
| Nom | title | e.g. `Cartes`, `Paiements`, `KYC` |
| Description | text | One or two sentences: what this domain covers |
| Relations | text | How it relates to other domains, e.g. `Cartes → Paiements : une Opération carte devient un Paiement au règlement` |
| Domaines liés | relation → Domaines | Self-relation |

## Glossaire

Terms only. A rule about a term belongs in Sources or a PRD.

| Property | Type | Notes |
|---|---|---|
| Terme | title | The one word to use, singular |
| Définition | text | One or two sentences: what it is |
| À éviter | text | Synonyms to retire, comma-separated |
| Termes liés | relation → Glossaire | Self-relation |
| Domaine | relation → Domaines | |
| PRD | relation → PRD | Back-reference of `PRD.Termes` |

## Sources

The business-rules registry.

| Property | Type | Notes |
|---|---|---|
| Nom | title | |
| URL | url | Internal doc or Notion page |
| Description | text | What the source covers; `po-research` picks sources from this |
| Domaine | relation → Domaines | `Transverse` for cross-domain sources |
| Autorité | select | `Canonique`, `Informatif` |
| Propriétaire | person | Who to ask when the source is unclear or wrong |
| Dernière revue | date | |
| Sources liées | relation → Sources | Self-relation: sources covering the same topic, or one restating another |
| PRD | relation → PRD | Back-reference of `PRD.Sources` |

## Projets

The git repos that implement the product. The PO skills read them through local read-only mirrors (see `po-repos`) to answer how the product behaves today.

| Property | Type | Notes |
|---|---|---|
| Nom | title | e.g. `shine-api`; also the mirror's folder name |
| Dépôt | url | The repo's clone URL, on any git host |
| Branche de référence | text | The branch that matches production, e.g. `main` or `production` |
| Description | text | What the project does; `po-research` picks projects from this |
| Domaine | relation → Domaines | The domains it implements |
| Glossaire projet | text | Path to the repo's `GLOSSARY.md` or `GLOSSARY-MAP.md`, when it has one |
| PRD | relation → PRD | Back-reference of `PRD.Projets` |

## PRD

| Property | Type | Notes |
|---|---|---|
| Nom | title | |
| Statut | select | `Brouillon`, `Prêt pour dev`, `En attente PO`, `Ticketé`, `Abandonné` |
| Propriétaire | person | The PO |
| Domaine | relation → Domaines | |
| Projets | relation → Projets | Two-way, shown on Projets as `PRD` |
| Termes | relation → Glossaire | Two-way, shown on Glossaire as `PRD` |
| Sources | relation → Sources | Two-way, shown on Sources as `PRD` |
| Ticket Linear | url | Filled by the dev side |

Statut lifecycle: `Brouillon` while grilling → `Prêt pour dev` from `to-prd` once the body's `Questions pour le PO` lists no question → `En attente PO` when the dev side adds questions there → `Prêt pour dev` again once the PO has answered them (`po-grill`, then `to-prd`) → `Ticketé` once Linear issues exist. A `Brouillon` the PO drops becomes `Abandonné` (`po-triage`); taking it up again in `po-grill` sets it back to `Brouillon`.
