# PO skills

Skills that let product owners grill a product idea and turn it into a French PRD in Notion, building the product glossary along the way. Works in any agent that supports skills and remote MCP servers, such as Claude Code, Cursor, or Codex, on macOS, Windows, or Linux.

## Prerequisites

- a Notion account in the team's workspace
- git access to this repo and the team's repos, on any git host
- git and Node.js: the installing agent installs them when missing, which may ask for your computer's admin password

## Install

Paste this repo's link into your agent and ask: « Installe les PO skills en suivant la section Install du README de ce repo. » The agent runs steps 1 to 3, then hands you step 4.

**For the installing agent**: meet each step's « Done when » before starting the next.

### 1. Check the tools, the repo, and the agents

1. Run `git --version` and `node --version`, and install what is missing:
   - **macOS**: `brew install git node` when `brew` exists. Otherwise, for git, `xcode-select --install`, and ask the user to confirm the dialog that opens; for Node.js, ask the user to run the LTS installer from [nodejs.org](https://nodejs.org).
   - **Windows**: `winget install --id Git.Git -e --source winget` and `winget install --id OpenJS.NodeJS.LTS -e --source winget`, then open a new shell so both are on the PATH.
   - **Linux**: the distribution's package manager, for example `sudo apt install git nodejs npm`.

   When an install needs a password or a click, give the user the exact command or action and wait for them.
2. Run `GIT_TERMINAL_PROMPT=0 git ls-remote <repo-url> HEAD` (in PowerShell, set `$env:GIT_TERMINAL_PROMPT=0` first), where `<repo-url>` is the link the user gave you. On failure, have the user sign git in (see [Git sign-in](#git-sign-in)) and retry.
3. List the agents the user has: you, plus every other agent whose user folder is in the home folder (`~/.claude/`, `~/.cursor/`, `~/.codex/`…). Ask the user to confirm the list, in plain words, for example: « J'installe les skills pour Claude Code et Cursor. Tu utilises d'autres outils d'IA, comme Codex ou Copilot ? »

Done when both tools print a version, `git ls-remote` lists a ref, and the user has confirmed the list of agents.

### 2. Install the skills

```sh
npx -y skills add <source> -g -a <agent> -s '*' -y
```

- `<source>` is `<repo-url>` when it is a github.com or gitlab.com link, or a clone URL ending in `.git` or in SSH form (`git@host:path`). Any other link: `git clone --depth 1 <repo-url>` into a temporary folder and pass that folder's path.
- Repeat `-a` once per agent of the user's, by its `skills` ID (`claude-code`, `cursor`, `codex`, `gemini-cli`, `github-copilot`…). An unknown ID makes `skills` list the valid ones and install nothing.
- For an agent with no ID, add `-a universal`, which fills `~/.agents/skills/`. When that agent doesn't read `~/.agents/skills/`, link each skill folder from there into the user-wide skills folder its documentation names.

Done when every skill that `npx -y skills add <source> -l` lists is installed for each of the user's agents: listed with that agent in `npx -y skills ls -g --json`, or linked into its folder. When `add` reports a skipped skill, stop and tell the user the repo has a broken skill for its maintainers to fix.

### 3. Add the Notion MCP server

The server is remote, over HTTP, at `https://mcp.notion.com/mcp`, with OAuth sign-in. For each of the user's agents, list its MCP servers first: one whose URL contains `mcp.notion.com` or whose name contains `notion`, in any case, means that agent already has Notion. For the others, add the server user-wide under the name `notion`, the way the agent's documentation says, merging into any existing config file. For example:

- **Claude Code**: `claude mcp add --transport http --scope user notion https://mcp.notion.com/mcp`
- **Cursor**: merge `"notion": { "url": "https://mcp.notion.com/mcp" }` into `mcpServers` in `~/.cursor/mcp.json`

Done when each of the user's agents lists a Notion server, and every config file you edited still parses. Signing in to Notion happens in the browser, in step 4.

### 4. Hand over to the user

Only the user can finish: Notion sign-in is an OAuth page, and `setup-po-skills` starts only when the user invokes it. Give them these steps in French, with each agent's own way of doing them, then the install is done:

1. Quit and reopen each agent, so it loads the skills and the Notion server.
2. Sign in to Notion from the agent's MCP settings or command (`/mcp` in Claude Code; the MCP section of Cursor Settings).
3. Run the `setup-po-skills` skill (`/setup-po-skills` in most agents), once, in any one agent: every agent on the machine shares its result. It asks for the link of the **PO hub**, the Notion page holding the team's five databases: paste the one another PO shares, or, when no PO has one yet, the skill creates it with you. It then mirrors the team's repos and names any it can't read, with the fix (usually [Git sign-in](#git-sign-in)).

### Git sign-in

The user runs these in their own terminal, then reruns the failed command. Either:

- install [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager), then run `git ls-remote <url>` once and sign in in the browser; it covers GitHub, GitLab, Bitbucket, and Azure Repos, among others; or
- sign in with the host's own CLI when it has one (`gh auth login` for GitHub, `glab auth login` for GitLab), or add an SSH key to the host account and use the repo's SSH URL.

### Update

`npx -y skills update -g`. Skills installed from a local folder or copied by hand don't update this way: rerun step 2 instead.

## Flow

```
/setup-po-skills ──► PO hub in Notion + repo mirrors (po-repos)
/po-add-source ───► Sources / Projets (discovery + short grill)

/po-triage ──► PRDs needing work → /po-grill [nom] (or Nouveau PRD → /po-grill)
/po-grill ──► design-tree grilling + po-glossary (Glossaire in Notion, scoped by Domaines)
   │            ├─ po-research (background) ──► cited notes under the PRD draft
   │            │     └─ reads repo mirrors and ADRs (po-repos, read-only)
   │            └─ po-add-source for « Hors registre » sources
   └─► /to-prd ──► PRD page in Notion, Statut: Prêt pour dev
```

| Skill | Invoked by | Does |
|---|---|---|
| `setup-po-skills` | Each PO, once; again to update an outdated hub | Joins the PO hub in Notion, or creates it with the `Domaines`, `Glossaire`, `Sources`, `Projets`, `PRD` databases; mirrors the repos ([schemas](skills/setup-po-skills/SCHEMAS.md)) |
| `po-triage` | PO (or the model) | Lists the PRDs that need work, lets the PO pick one or drop a draft (`Abandonné`) |
| `po-grill` | PO | Grilling session in French, anchored to a PRD draft |
| `po-glossary` | `po-grill` (or the model) | Challenges terms and writes them to the Glossaire |
| `po-research` | `po-grill` (or the model) | Answers facts from the Sources registry and the repo mirrors; reports conflicts, rule/code gaps, and inaccessible sources |
| `to-prd` | PO, after `po-grill` | Writes the PRD body and sets its properties |
| `po-add-source` | PO, `po-grill`, `setup-po-skills` | Adds business-rules docs (Sources) or repos (Projets), mapping domains and overlaps |
| `po-repos` | Other skills | Clones and updates the read-only repo mirrors in `~/.po-skills/repos/` |
| `po-ask` | PO (or the model) | Answers which skill to run, when, and in what order |

## Read-only code

The PO skills never change code. They read the team's repos through local mirrors in `~/.po-skills/repos/`, which only ever get cloned and reset to the remote's reference branch: no edits, commits, pushes, branches, scripts, or dependency installs.

## Language

Skill instructions are in English for the developers who maintain them. Everything a PO reads or writes (questions, templates, Notion properties, PRDs) is in French.

## Maintainers

Skills install separately and can't share files, and the hub guide is written for humans, so a few values live in more than one place. Change each one everywhere at once, then run `scripts/check-sync.sh`: it fails on a status, question section, hub pointer line, or French rule line that has drifted from its source.

- the hub pointer line and the French rule line: every skill that reads the hub
- the staleness threshold (one year): `po-research`, `HUB-PAGE.md`
- the PRD statuses: `SCHEMAS.md`, `HUB-PAGE.md`, `po-grill`, `to-prd`, `po-ask`, `po-triage`
- the PRD question sections (`Questions pour le PO`, `Questions pour les devs`, `Réponses du PO`): `to-prd`, `po-grill`, `po-ask`, `po-triage`, `SCHEMAS.md`, `HUB-PAGE.md`
- the skill map and situations in `po-ask`: whenever a skill is added, renamed, or changes when it runs or what it produces
- new-domain creation: `po-glossary`, `po-add-source`
- the Notion MCP URL: `README.md`, `po-ask`

## Credits

`po-grill` adapts Matt Pocock's [`grilling`](https://github.com/mattpocock/skills) skill (MIT). See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
