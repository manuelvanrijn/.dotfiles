---
name: bear-notes
description: "Search, read, create, and update notes in Bear using bcli only. Use when the user asks about their notes, wants to search Bear, save something to Bear, or reference their personal knowledge base."
---

# Bear Notes Assistant

You have access to the user's Bear notes via `bcli` (`better-bear-cli`), which reads and writes through Bear's CloudKit API. Use the Bash tool to run commands.

## Setup

Install bcli (one-time):
```bash
curl -L https://github.com/mreider/better-bear-cli/releases/latest/download/bcli-macos-universal.tar.gz \
  -o /tmp/bcli.tar.gz && tar xzf /tmp/bcli.tar.gz -C /tmp && mv /tmp/bcli ~/.local/bin/bcli
```

Authenticate (opens browser for Apple Sign-In):
```bash
bcli auth
```

Token is stored at `~/.config/bear-cli/auth.json`.

bcli also maintains a cache at `~/.config/bear-cli/cache.json`. If results appear stale, run:
```bash
bcli sync
```

For a full refresh:
```bash
bcli sync --full -v
```

## Available Commands

### Search Notes
```bash
bcli search "query" --json
bcli search "query" --limit 20 --json
bcli ls --tag "tagname" --json
bcli ls --all --json
```

Important:
- `bcli search` returns summary results only, typically including fields like `id`, `title`, `tags`, and `match`
- it does **not** return the full note body
- to inspect note contents, fetch the note with `bcli get NOTE_ID --json`

### Read a Note
```bash
bcli get NOTE_ID --json    # full metadata + body
bcli get NOTE_ID --raw     # markdown body only
```

### Create a Note
```bash
bcli create "Title" --body "Content" --tags "tag1,tag2"
NEW_ID=$(bcli create "Title" --body "Content" --tags "tag1" --quiet)
```

### Update a Note
Append text:
```bash
bcli edit NOTE_ID --append "text to append"
```

Replace full body from stdin:
```bash
printf '%s' "replacement body" | bcli edit NOTE_ID --stdin
```

Open in editor:
```bash
bcli edit NOTE_ID --editor
```

Important:
- `bcli` has no `--prepend`
- to prepend content, first read the body, construct the new markdown, then replace via `--stdin`

Example prepend flow:
```bash
BODY=$(bcli get NOTE_ID --raw)
printf '%s' "Prepended text

$BODY" | bcli edit NOTE_ID --stdin
```

### List Tags
```bash
bcli tags --flat --json
```

### Trash a Note
```bash
bcli trash NOTE_ID --force
```

### Open a Note in Bear

`bcli` has no `open` command. The note ID from `bcli` can be used directly with Bear's URL scheme:

```bash
open "bear://x-callback-url/open-note?id=NOTE_ID"
```

Or open by title:
```bash
TITLE=$(bcli get NOTE_ID --json | python3 -c "import json,sys; print(json.load(sys.stdin)['title'])")
open "bear://x-callback-url/open-note?title=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$TITLE")"
```

## Workflow

### When answering questions about notes
1. Search first
2. Read the relevant notes in full
3. Synthesize across notes if needed
4. Mention which note titles were used

### When creating or updating notes
1. Determine whether to create a new note or update an existing one
2. Reuse existing tags where sensible
3. Use `bcli tags --flat --json` to inspect tag naming if needed
4. Trigger `bcli sync` after creation or update

## Date Filtering

`bcli` does **not** support Bear query operators like:
- `@today`
- `@last7days`
- `@date(>...)`

For date-based filtering, use:
```bash
bcli ls --all --json
```

Then filter in Python using the note metadata date fields, typically `modificationDate`.

Example:
```bash
bcli ls --all --json | python3 -c "
import json, sys
from datetime import datetime, timedelta, timezone

notes = json.load(sys.stdin)
cutoff = datetime.now(timezone.utc) - timedelta(days=7)

def parse_dt(s):
    return datetime.fromisoformat(s.replace('Z', '+00:00'))

filtered = [
    n for n in notes
    if n.get('modificationDate') and parse_dt(n['modificationDate']) >= cutoff
]

print(json.dumps(filtered, indent=2))
"
```

## Enrich Saved Tweets Workflow

Use this when the user asks to enrich, process, or title saved tweet notes using **bcli only**.

### Step 1 — Find candidate tweet notes
```bash
bcli ls --all --json | python3 -c "
import json, sys, subprocess, re
notes = json.load(sys.stdin)
results = []
for note in notes:
    title = note.get('title', '')
    if not title.startswith('https://x.com/'):
        continue
    detail = json.loads(subprocess.check_output(['bcli', 'get', note['id'], '--json']))
    body = detail.get('text', '')
    links = re.findall(r'https?://(?:www\.)?x\.com/\S+', body)
    if len(links) == 1:
        url = re.sub(r'[\)\]>]+$', '', links[0])
        results.append({'id': note['id'], 'url': url})
print(json.dumps(results))
" > /tmp/tweet_notes.json
```

### Step 2 — Fetch tweet content via browser automation
Use the browser tool to visit each URL and extract tweet text.

Example browser logic:
```js
async (page) => {
  const fs = require('fs');
  const notes = JSON.parse(fs.readFileSync('/tmp/tweet_notes.json', 'utf8'));
  const results = [];
  for (const {url} of notes) {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 15000 });
    await page.waitForTimeout(2500);
    const title = await page.title();
    const match = title.match(/^(.+?) on X: "(.+?)"(?:\s*\/\s*X)?$/s);
    if (match) results.push({ url, author: match[1], tweet: match[2].trim() });
    else results.push({ url, author: null, tweet: title });
  }
  return JSON.stringify(results);
}
```

Save the result to `/tmp/tweet_data.json`.

### Step 3 — Update notes via bcli
```bash
python3 -c "
import json, subprocess, re

with open('/tmp/tweet_data.json') as f:
    tweets = json.load(f)
with open('/tmp/tweet_notes.json') as f:
    notes = json.load(f)

url_to_id = {n['url']: n['id'] for n in notes}

for t in tweets:
    url = t['url']
    tweet_text = t.get('tweet', '').strip()
    author = t.get('author', '')
    note_id = url_to_id.get(url)
    if not note_id or not tweet_text:
        continue

    m = re.match(r'https?://(?:www\.)?x\.com/([^/]+)/status/', url)
    handle = f'@{m.group(1)}' if m else ''
    short = tweet_text[:60] + ('…' if len(tweet_text) > 60 else '')
    title = f'{author}: {short}' if author else short

    new_body = f'# {title}\n\n> {tweet_text}\n\n**{handle}** · [View on X]({url})\n\n#inbox/saved-tweets'

    result = subprocess.run(
        ['bcli', 'edit', note_id, '--stdin'],
        input=new_body,
        text=True,
        capture_output=True
    )
    if result.returncode != 0:
        print(f'Error {note_id}: {result.stderr.strip()}')
    else:
        print(f'Updated: {title[:50]}')
print('Done')
"
```

Notes:
- no local Bear internals are used
- no restart of Bear is needed
- CloudKit rate limits may still happen; retry with spacing between edits if necessary

## Notes

- `bcli` uses Bear's CloudKit-backed API path
- `bcli` note IDs can be used directly in Bear URL scheme calls with `?id=...`
- `bcli` maintains a local cache; run `bcli sync` if needed
- Bear-style wiki links can be written as:
  - `[[note title]]`
  - `[[note title|alias]]`
- hierarchical tags are supported, for example:
  - `work/projects/2025`
  - `inbox/saved-tweets`
- always search before claiming a note does not exist
