Content for the hub page body, written above the five databases. Copy it as-is, in French; replace `<url du repo po-skills>` with the repo the user installed the skills from, when known.

---

## Les bases

Cette page est le **hub PO** : elle regroupe les bases que les skills PO (`/po-grill`, `/to-prd`, `/po-add-source`, `/po-triage`) lisent et écrivent. Ne renomme pas les bases ni leurs propriétés : les skills les retrouvent par leur nom. Une question sur quel skill lancer, et quand ? Lance `/po-ask`. Pour voir les PRD qui t'attendent sans ouvrir Notion, lance `/po-triage`.

### Domaines

Les grandes zones du produit (Comptes, Paiements…), avec ce que chacune couvre et comment elles se relient. Elles servent à ranger le Glossaire, les Sources, les Projets et les PRD : l'agent ne charge que les termes et les règles du domaine concerné. La liste reste courte et change rarement. Le domaine `Transverse` regroupe ce qui s'applique partout.

### Glossaire

Le vocabulaire du produit : **un terme par ligne**, avec une définition courte et les mots à éviter. Il dit ce qu'une chose *est* ; une règle sur cette chose (un plafond, un délai, qui a le droit de quoi) va dans les Sources ou dans un PRD. L'agent l'enrichit pendant chaque `/po-grill` et te signale quand tu utilises un mot différent de celui du Glossaire.

### Sources

Le registre des règles métier : un lien par document de référence (doc interne, page Notion). L'agent n'y répond qu'à partir de ces sources et les cite.

- `Autorité` : `Canonique` (la règle officielle) l'emporte sur `Informatif` (FAQ, résumé, support).
- `Dernière revue` : une source revue il y a plus d'un an est signalée comme à revoir.
- `Propriétaire` : la personne à contacter quand une source est floue ou fausse.
- `Sources liées` : les sources qui couvrent le même sujet, ou dont l'une résume l'autre.

Pour ajouter une ou plusieurs sources, lance `/po-add-source` avec leurs liens : l'agent les compare aux sources existantes, propose leurs domaines et leurs liens, et te pose quelques questions pour trancher. Pendant un `/po-grill`, l'agent te propose aussi d'ajouter les sources trouvées hors du registre.

### Projets

Les dépôts git du produit, quel que soit leur hébergeur. Chaque PO en a une copie locale, mise à jour automatiquement, que l'agent lit pour répondre à « comment ça marche aujourd'hui ? » en citant le fichier concerné. Ces copies sont en **lecture seule** : les skills PO ne modifient jamais le code. Quand le code fait autre chose qu'une source `Canonique`, l'agent te le signale : c'est un bug, une règle obsolète, ou un écart voulu qu'une décision technique (ADR) du dépôt explique, et c'est à toi de trancher.

- `Branche de référence` : la branche qui correspond à la production.

Pour ajouter un dépôt, lance `/po-add-source` avec son lien.

### PRD

Un PRD par fonctionnalité. Le `Statut` suit le cycle :

`Brouillon` (grilling en cours) → `Prêt pour dev` (rédigé par `/to-prd`) → `En attente PO` (les devs ont des questions) → `Prêt pour dev` (le PO a répondu) → `Ticketé` (tickets Linear créés)

Un `Brouillon` que tu abandonnes passe en `Abandonné` (via `/po-triage`). Pour le reprendre, lance `/po-grill` en le nommant : l'agent te demande confirmation avant de le repasser en `Brouillon`.

Les devs écrivent leurs questions dans la section `Questions pour le PO` du PRD. Pour y répondre, lance `/po-grill` en nommant le PRD : l'agent te pose ces questions en premier. Lance ensuite `/to-prd` dans la même conversation : il reporte tes réponses dans `Réponses du PO` et repasse le PRD en `Prêt pour dev` quand il ne reste plus de question.

#### Pour les devs (et leur agent)

Chaque PRD se termine par trois sections. Une section sans question contient « Aucune ».

- `Questions pour les devs` : ce que le PO te laisse trancher ou vérifier dans le code, avec les `Hypothèses à vérifier`.
- `Questions pour le PO` : pour poser une question au PO, ajoute-la ici, une par ligne, en supprimant « Aucune », puis passe le `Statut` à `En attente PO`. Laisse le reste du PRD tel quel : le PO y reporte ses réponses avec `/to-prd`.
- `Réponses du PO` : les questions déjà tranchées, avec les récits ou sections qu'elles ont modifiés.

Les recherches faites pendant le grilling sont des sous-pages du PRD, et ses relations `Termes`, `Sources` et `Projets` montrent ce qu'il utilise.

## Rejoindre ce hub

Installe les skills (voir <url du repo po-skills>), lance `/setup-po-skills` et colle le lien de cette page quand l'agent le demande.
