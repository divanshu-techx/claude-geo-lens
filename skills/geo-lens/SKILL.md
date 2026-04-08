---
name: geo-lens
description: Multi-agent Lighthouse-style Generative Engine Optimisation (GEO) auditor. Given any URL, orchestrates 5 parallel sub-agents (crawler, measurer, prober, opportunities, reporter) to audit how a brand surfaces in ChatGPT, Perplexity, Claude, Gemini, and Google AI Overviews. Scores a research-backed 100-point rubric (Princeton KDD 2024 + CORE-EEAT + CITE), live-probes LLMs for actual citations, and outputs an interactive HTML report plus a copy-paste remediation.md file. Use when the user asks to "audit GEO", "check AI search visibility", "run llms.txt audit", or supplies a URL with GEO/LLM-visibility intent.
---

# geo-lens — multi-agent GEO audit orchestrator

Lighthouse for LLM search, architected as a multi-agent workflow. You are the **orchestrator** — your job is to dispatch sub-agents in parallel, then assemble their outputs into a single audit bundle.

## Architecture

```
geo-lens (you, orchestrator)
├── Phase 1 — geo-crawler       → indexes site HTML to raw/
├── Phase 2 — geo-measurer      ┐
│             geo-prober        ├── run in parallel
│             (read raw/ + score, probe LLMs)
├── Phase 3 — geo-opportunities → generates remediation.md
└── Phase 4 — geo-reporter      → assembles interactive HTML + summary.md
```

## Output bundle

Every audit writes a directory at `~/geo-audits/{domain}-{YYYYMMDD}/` containing:

| File | Purpose | Produced by |
|---|---|---|
| `index.html` | Interactive Lighthouse-style report with Citation Calculator | geo-reporter |
| `summary.md` | Short exec summary for terminal viewing | geo-reporter |
| `remediation.md` | **Copy-paste ready fix file** with code snippets, file paths, effort | geo-opportunities |
| `signals.json` | Machine-readable scorecard (all 60+ signals) | geo-measurer |
| `probes.json` | Raw LLM probe results | geo-prober |
| `raw/{slug}.html` | Indexed HTML per crawled page | geo-crawler |
| `raw/_manifest.json` | Map of URL → local file + metadata | geo-crawler |

## Inputs

Required: **URL**
Auto-derive: brand name, category, top competitors
Defaults: crawl 20 pages, 8 live probes, full output bundle

## Orchestrator pipeline

### Step 0 — Setup

```bash
DOMAIN=$(echo "$URL" | sed -E 's#https?://##;s#/.*##;s#^www\.##')
DATE=$(date +%Y%m%d)
BUNDLE="$HOME/geo-audits/$DOMAIN-$DATE"
mkdir -p "$BUNDLE/raw"
```

Confirm the URL and brand with the user (one line, not a question unless ambiguous), then proceed.

### Step 1 — Dispatch geo-crawler (sequential, blocking)

Must complete before measurement because measurer reads indexed HTML. Use the `Agent` tool with `subagent_type: "geo-crawler"` and pass: URL, bundle path, page cap.

**geo-crawler returns**: manifest path + list of indexed pages + discovery findings (robots.txt, llms.txt, sitemap, AI discovery endpoints).

### Step 2 — Dispatch geo-measurer + geo-prober **IN PARALLEL**

Single message, two `Agent` tool calls:

- **geo-measurer** — reads `raw/` HTML, scores 100-pt rubric, writes `signals.json`
- **geo-prober** — runs 8 live LLM queries, writes `probes.json`, flags hallucinations

They're independent: parallel dispatch is mandatory.

### Step 3 — Dispatch geo-opportunities

Reads `signals.json` + `probes.json` + crawler manifest → writes `remediation.md` with:
- Problem description (evidence-cited)
- Why it matters (research-backed lift %)
- Effort (S/M/L + hours)
- **Exact code snippet** to paste
- **Target file path** (where to apply)
- Verification command (how to test the fix worked)
- Impact score (+score / +citation)

### Step 4 — Dispatch geo-reporter

Reads everything → writes `index.html` (interactive) + `summary.md`.

### Step 5 — Return

Print to user:
- Bundle path
- Headline score + grade
- Top 3 fixes (one line each)
- "Open the report: `open ~/geo-audits/{dir}/index.html`"
- "Ship-ready fixes: `~/geo-audits/{dir}/remediation.md`"

## Rubric — 100 points (all sub-agents must align with this)

### 1. Crawlability (18) — AI-bot access + SSR
### 2. llms.txt & AI Discovery (12) — discovery files
### 3. Schema & Structured Data (14) — JSON-LD allowlist
### 4. Content Citability (18) — Princeton KDD 2024 signals (cite/quote/stat density, 134–167w windows, TL;DR, voice chunks, Flesch-Kincaid, keyword-stuff penalty)
### 5. E-E-A-T / Credibility (12) — author credentials, freshness, primary sources
### 6. Entity Strength (10) — Org schema + 11-platform brand mention scan
### 7. Technical Foundations (8) — canonical, OG, alt, linking, RSS
### 8. Live LLM Citation (8) — 8 probes

**Veto gates** (cap at 39): all AI bots blocked, site-wide noai headers, ≥3 hallucinations, zero structured data + no Wikipedia.

**Grade bands**: A 86–100 · B 68–85 · C 51–67 · D 36–50 · F 0–35

Research citations: Aggarwal et al. 2024 (arXiv 2311.09735), AutoGEO ICLR'26, llmstxt.org, schema.org.

(Sub-agent files in `~/.claude/agents/geo-*.md` hold the full rubric detail.)

## Quality bar for the orchestrator

- **Parallelise whenever possible.** Step 2 MUST be parallel. Sub-steps inside crawler/measurer/prober should also parallelise internally.
- **Fail-open.** If a sub-agent partially fails, continue with what you have and flag gaps in the report.
- **No synthesis leakage.** Each sub-agent owns its output file; don't rewrite their content in the orchestrator.
- **Confirm bundle exists** before printing the summary. `ls -la $BUNDLE`.

## Platform-specific lanes

Scored on top of the base rubric, because only ~11% of domains are cited by both ChatGPT and Google AIO for the same query:

| Lane | Priority signals |
|---|---|
| **ChatGPT** | long-form 1500–2500w, credentialed authors, citation density, Article schema |
| **Perplexity** | weekly dateModified, inline citations, primary sources, sameAs |
| **Claude** | methodology, limitations/tradeoff sections, Q&A structure, FAQPage |
| **Gemini** | local NAP, LocalBusiness schema, Google Business Profile |
| **Google AIO** | tables, FAQPage + HowTo, featured-snippet passages, BreadcrumbList |

## Failure modes

- Site behind auth / paywall → stop and report
- robots.txt blocks WebFetch user-agent → stop and report with alternative suggestions
- Sub-agent returns empty → retry once, then continue with degraded bundle
- Crawl returns 0 pages → likely hostile site, stop
- Live probing blocked (no WebSearch) → skip Phase 5, mark citation score as "unmeasured"
