#!/usr/bin/env bash
# Checks the values the README "Maintainers" section says live in more than one place.
# Run from anywhere: scripts/check-sync.sh. Exits non-zero on any mismatch.

set -u
export LC_ALL=en_US.UTF-8

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root" || exit 2

schemas=skills/setup-po-skills/SCHEMAS.md
hub=skills/setup-po-skills/HUB-PAGE.md
po_ask=skills/po-ask/SKILL.md
to_prd=skills/to-prd/SKILL.md
docs=(README.md skills/*/*.md)

fail=0
err() { echo "✗ $*"; fail=1; }

# --- PRD statuses: SCHEMAS.md is the source of truth ------------------------

statut_row=$(grep -E '^\| Statut \| select \|' "$schemas")
[ -n "$statut_row" ] || { echo "✗ no 'Statut | select' row in $schemas"; exit 2; }
statuses=()
while IFS= read -r s; do statuses+=("$s"); done < <(
  echo "$statut_row" | awk -F'|' '{print $4}' | grep -oE '`[^`]+`' | tr -d '`')

# Every status is named where POs and the router read the lifecycle.
for s in "${statuses[@]}"; do
  for f in "$hub" "$po_ask"; do
    grep -qF "\`$s\`" "$f" || err "status \`$s\` (from SCHEMAS.md) missing in $f"
  done
done

# Every `Statut: X` a skill sets or reads is a known status.
while IFS= read -r hit; do
  file=${hit%%:*}; rest=${hit#*:}; line=${rest%%:*}; value=${rest#*:}
  value=${value#\`Statut: }; value=${value%\`}
  known=0
  for s in "${statuses[@]}"; do [ "$value" = "$s" ] && known=1; done
  [ $known = 1 ] || err "$file:$line: unknown status \`Statut: $value\`"
done < <(grep -noE '`Statut: [^`]+`' "${docs[@]}")

# --- PRD question sections: to-prd's template is the source of truth --------

sections=()
while IFS= read -r s; do sections+=("$s"); done < <(
  grep -E '^## (Questions|Réponses) ' "$to_prd" | sed 's/^## //')
[ ${#sections[@]} -gt 0 ] || { echo "✗ no question sections in $to_prd's template"; exit 2; }

legacy='Questions ouvertes'   # pre-split name, read on older PRDs only
while IFS= read -r hit; do
  file=${hit%%:*}; rest=${hit#*:}; line=${rest%%:*}; value=${rest#*:}
  value=${value#\`}; value=${value%\`}
  known=0
  for s in "${sections[@]}"; do [ "$value" = "$s" ] && known=1; done
  [ "$value" = "$legacy" ] && case $file in
    skills/po-grill/*|skills/to-prd/*) known=1 ;;
  esac
  [ $known = 1 ] || err "$file:$line: unknown section \`$value\`"
done < <(grep -noE '`(Questions?|Réponses?) [^`]+`' "${docs[@]}")

# --- Hub pointer and French rule: identical in every skill ------------------

hub_prefix='The PO databases live under the **PO hub** page named in `~/.po-skills/config.md`;'
french='Write in French: every message to the user and everything written to Notion.'

for f in skills/*/SKILL.md; do
  grep -qxF "$french" "$f" || err "$f: French rule line missing or reworded"
  while IFS= read -r line; do
    case $line in
      "$hub_prefix"*) ;;
      *) err "$f: hub pointer line reworded: $line" ;;
    esac
  done < <(grep -E '^The PO databases live' "$f")
done

# ---------------------------------------------------------------------------

if [ $fail = 0 ]; then
  echo "✓ statuses (${#statuses[@]}), question sections (${#sections[@]}), hub pointer and French rule are in sync"
fi
exit $fail
