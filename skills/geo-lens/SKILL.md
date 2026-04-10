---
name: geo-lens
description: Multi-agent Lighthouse-style Generative Engine Optimisation (GEO) auditor. Given any URL, orchestrates 5 parallel sub-agents (crawler, measurer, prober, opportunities, reporter) to audit how a brand surfaces in ChatGPT, Perplexity, Claude, Gemini, and Google AI Overviews. Scores a research-backed 100-point rubric (Princeton KDD 2024 + CORE-EEAT + CITE), live-probes LLMs for actual citations, and outputs an interactive HTML report plus a copy-paste remediation.md file. Use when the user asks to "audit GEO", "check AI search visibility", "run llms.txt audit", or supplies a URL with GEO/LLM-visibility intent.
---

# geo-lens — multi-agent GEO audit orchestrator

Lighthouse for LLM search, architected as a multi-agent workflow. You are the **orchestrator** — your job is to dispatch sub-agents in parallel, then assemble their outputs into a single audit bundle.

**Rubric: 110 points across 8 categories, 70+ measurable signals, 12 live LLM probes.**

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
### 3. Schema & Structured Data (16) — JSON-LD allowlist + SpeakableSpecification + HowTo
### 4. Content Citability (20) — Princeton KDD 2024 signals + table detection (2.5x citation lift) + front-loading score (Kevin Indig: 44% of citations from first 30% of content)
### 5. E-E-A-T / Credibility (12) — author credentials, freshness, primary sources
### 6. Entity Strength (11) — Org schema + 11-platform brand mention scan + Reddit/YouTube weighted presence
### 7. Technical Foundations (9) — canonical, OG, alt, linking, RSS, video transcript detection
### 8. Live LLM Citation (10) — 12 probes (expanded from 8)

**Veto gates** (cap at 42): all AI bots blocked, site-wide noai headers, ≥3 hallucinations, zero structured data + no Wikipedia.

**Grade bands**: A 90–110 · B 72–89 · C 54–71 · D 38–53 · F 0–37

Research citations: Aggarwal et al. 2024 (arXiv 2311.09735), AutoGEO ICLR'26, llmstxt.org, schema.org, Kevin Indig citation analysis (3M ChatGPT responses), Cloudflare crawl-to-click studies, Relixir FAQPage study (July 2025), Digital Bloom AI Visibility Report 2025, a16z "How GEO Rewrites the Rules of Search".

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
| **ChatGPT** | long-form 1500–2500w, credentialed authors, citation density, Article schema, Wikipedia presence (47.9% of top-10 citations), Bing indexation |
| **Perplexity** | weekly dateModified, inline citations, primary sources, sameAs, Reddit presence (#1 source, 6.6% of citations), SpeakableSpecification |
| **Claude** | methodology, limitations/tradeoff sections, Q&A structure, FAQPage, long-form structured content |
| **Gemini** | local NAP, LocalBusiness schema, Google Business Profile, first-party content priority |
| **Google AIO** | tables (2.5x citation lift), FAQPage + HowTo, featured-snippet passages, BreadcrumbList, query fan-out awareness |

## Failure modes

- Site behind auth / paywall → stop and report
- robots.txt blocks WebFetch user-agent → stop and report with alternative suggestions
- Sub-agent returns empty → retry once, then continue with degraded bundle
- Crawl returns 0 pages → likely hostile site, stop
- Live probing blocked (no WebSearch) → skip Phase 5, mark citation score as "unmeasured"
