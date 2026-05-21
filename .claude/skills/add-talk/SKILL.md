---
name: add-talk
description: Add a new talk to the JSSPT Hugo site from an email blurb. Handles bio fetching, frontmatter, weight ordering, and rotating past upcoming talks into past_talks/. Use when the user provides speaker details (name, date, title, abstract, optional bio URL) and asks to "add a talk", "upload a talk", "put this on the site", etc.
---

# Add a talk

This site lives at `/Users/crathkopf/Websites/philtechtalks` and is a Hugo site. Talks are individual markdown files under `content/`.

## Directory contract

- `content/upcoming/` — scheduled talks. Listed in ascending date order via the `weight` frontmatter field.
- `content/past_talks/` — talks that have already happened. **No `weight` field.**
- File name: lowercase first name, e.g. `christophe.md`. If a collision exists, use `firstname_lastinitial.md` (see `charlotte_u.md`, `julia_b.md`, `guidoc.md`).

## Frontmatter contract

Upcoming talk frontmatter:

```toml
+++
title = 'Month DD: Firstname Lastname (Institution)'
date = YYYY-MM-DDT10:00:10+01:00
draft = false
hideMeta = true
summary = "Short one-line teaser of the abstract"
weight = NN
+++
```

Past talks: same fields **minus `weight`**.

### Title conventions

- Format: `'Month DD: <Honorific?> Firstname Lastname (Institution)'`
- Honorifics (Dr., Professor) appear inconsistently across the corpus — match what the user wrote; if unspecified, omit.
- Institution is the speaker's primary affiliation (where the doctorate or current job is). If ambiguous, ask the user.

### Date

Use the talk date at 10:00:10. Timezone is usually `+01:00` (most files) but some use `+02:00` — match what's already in `upcoming/` or use `+01:00`.

### Weight

`weight` controls ordering within `upcoming/`. Values are not strict — they're roughly spaced so new talks can be inserted between existing ones. Before assigning, read all files in `upcoming/`, sort by date, and pick a number that sits between neighbors. Common spacing is 5–10.

### Summary

One line (≤ ~90 chars) that captures the abstract. Used in list views and meta tags. Write fresh; don't copy the first sentence of the abstract.

## Body structure

```markdown
#### Title
<Full title>

#### Abstract
<Verbatim abstract from the email — preserve paragraph breaks>


#### About [Firstname](<bio URL>)
<One-paragraph bio.>
```

- If a bio URL was provided, use `#### About [Firstname](url)`. Otherwise just `#### About Firstname`.
- If no bio is available yet, write `Forthcoming` (see `alessia.md`).
- For in-person talks, add a bold line above the abstract: `**Note: This talk will be held in-person in Jülich.**` (see `gunter.md`).

## Language

Match the language of the abstract. The corpus is mixed — German abstracts get German section headers? **No** — section headers (`#### Title`, `#### Abstract`, `#### About`) stay in English across all files. Only the body content language varies.

## Bio fetching

If the user provides a URL (commonly a university or lab profile), WebFetch it and ask for a one-paragraph bio covering: position, affiliation, research interests, education. Polish lightly — fix anglicizations of institution names (e.g., "University of Montreal" → "Université de Montréal" when the link confirms the French form).

## Rotate past upcoming talks (do this every time)

Before finishing, check `content/upcoming/` for any talk whose date is now in the past (today's date is in the system context). For each:

1. `mv content/upcoming/<file>.md content/past_talks/<file>.md`
2. Remove the `weight = NN` line from frontmatter
3. Leave everything else intact

Mention any moves in the end-of-turn summary so the user knows.

## Verification

After writing the file, optionally start the dev server:

```bash
hugo server
```

Then visit `http://localhost:1313/upcoming/<filename-without-md>/` to confirm rendering. Only do this if the user asks for verification — don't auto-start the server.

## Inputs to extract from the user's email

When the user pastes a talk announcement (often forwarded from a coordinator like Dilara, often in German), extract:

- **Speaker name** (and which is the first name — for non-anglophone names, ask if unclear)
- **Date** — German emails will say e.g. "28. Juli"; convert to ISO
- **Title** — sometimes given in quotes
- **Abstract** — usually a multi-paragraph block
- **Bio URL** — usually a single link near the end
- **Institution** — may need to infer from the bio URL's domain

If anything is ambiguous, ask one focused question before writing the file (e.g., "I see both McGill and Montréal in the bio — which should appear in the title?"). Do not ask about things you can derive from the existing corpus.

## After writing

End-of-turn summary should include:

- Path of the new file
- Weight chosen and why (which neighbors it sits between)
- Any judgment calls worth flagging (institution name, language choice, honorific)
- Any past-talk rotations performed
