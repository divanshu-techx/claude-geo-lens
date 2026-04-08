# geo-lens

**Lighthouse for LLM search.** An open-source Claude Code skill + agent that audits any website for Generative Engine Optimisation (GEO) — how well a brand surfaces in ChatGPT, Perplexity, Claude, Gemini, and Google AI Overviews.

Runs a **research-backed 100-point audit** (Princeton KDD 2024 + CORE-EEAT + CITE), live-probes LLMs for **actual brand citations**, and outputs a **single-file interactive HTML report** with a Citation Calculator that projects your post-fix score in real time.

> Think Lighthouse, but instead of scoring web performance for users, it scores AI visibility for LLMs.

---

## Why this exists

Classic SEO tools don't measure the things that matter for AI search:

- `llms.txt` / `.well-known/ai.txt` presence
- Structured data depth (`FAQPage`, `HowTo`, `Product`, `Organization` + `sameAs`)
- Citation / quotation / statistic density (Princeton KDD 2024 identified these as +30–40% visibility levers)
- Passage citability windows (134–167 word self-contained chunks)
- AI-bot robots.txt rules (GPTBot, ClaudeBot, PerplexityBot, Google-Extended, 20+ more)
- Live citation rate in actual LLM answers

And most existing GEO audit tools score structurally but **never actually probe an LLM** to see what it cites. `geo-lens` does both.

---

## What makes this different from the 10+ existing GEO skills

| Feature | geo-lens | Most others |
|---|---|---|
| Research-backed scoring (Princeton KDD 2024, AutoGEO ICLR'26) | ✅ | Partial |
| Live LLM citation probing (8 queries) | ✅ | ❌ usually static-only |
| Interactive HTML report with Citation Calculator | ✅ | ❌ markdown/PDF only |
| 60+ measurable signals, 8-category rubric | ✅ | Varies |
| Platform-specific lanes (ChatGPT/Perplexity/Claude/Gemini/AIO) | ✅ | Some |
| Hallucination detection in live answers | ✅ | ❌ |
| Single-file HTML, zero dependencies, zero build | ✅ | ❌ requires PDF pipeline / PyPI packages |
| Skill + Agent combo (not just a skill) | ✅ | Mostly skill-only |

---

## Installation

### Option A — one-line install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR-USER/geo-lens/main/install.sh | bash
```

### Option B — clone and install

```bash
git clone https://github.com/YOUR-USER/geo-lens.git
cd geo-lens
./install.sh
```

### Option C — manual

```bash
# Skill
mkdir -p ~/.claude/skills/geo-lens
cp skills/geo-lens/SKILL.md ~/.claude/skills/geo-lens/

# Agent
mkdir -p ~/.claude/agents
cp agents/geo-lens.md ~/.claude/agents/
```

**Restart Claude Code** (or open a new session) so the skill and agent are loaded.

---

## Usage

Once installed, in any Claude Code session just say:

```
audit GEO for stripe.com
```

or

```
run geo-lens on https://www.example.com
```

Claude will auto-delegate to the `geo-lens` agent, which:

1. Loads the `geo-lens` skill
2. Parallel-fetches robots.txt, llms.txt, sitemap, homepage
3. Crawls 15 key pages (About, Pricing, Products, Blog, Support, FAQ, Docs)
4. Runs 8 live LLM probes via WebSearch (1 unbranded "best-of" query + 7 branded)
5. Scores the 100-point rubric across 8 categories
6. Applies Princeton KDD 2024 lift multipliers to the Citation Calculator
7. Writes an interactive HTML report to `~/geo-audits/{domain}-{date}.html`

Open the report in any browser — no server, no dependencies.

### Example output

See [`examples/cox.com.html`](examples/cox.com.html) for a live interactive report auditing Cox Communications. Preview of what's in it:

- **Donut score** with letter grade (A–F)
- **8 category bars** (Crawlability, llms.txt/AI Discovery, Schema, Citability, E-E-A-T, Entity Strength, Technical, Live Citation)
- **Platform readiness matrix** — ChatGPT vs Perplexity vs Claude vs Gemini vs Google AI Overviews
- **Top 3 critical fixes** as prominent cards
- **Interactive Citation Calculator** — tick fixes, watch projected score + citation rate update live, see total effort in hours
- **Live LLM probe cards** — 8 queries with cited/not-cited pills, cited sources, gap analysis
- **Hallucinations callout** — factual risks detected in LLM answers
- **Per-page scorecards** — collapsible table
- **Copy-paste code templates** — llms.txt, Organization JSON-LD, FAQPage, robots.txt AI-bot block
- **Methodology footer** with research citations

---

## Scoring rubric (100 points)

| Category | Pts | What it measures |
|---|---|---|
| **1. Crawlability** | 18 | 27-bot robots.txt matrix (training/search/UA tiers), `X-Robots-Tag` noai headers, SSR on priority pages, sitemap lastmod |
| **2. llms.txt & AI Discovery** | 12 | `/llms.txt`, `/llms-full.txt`, `/.well-known/ai.txt`, `/ai/summary.json` |
| **3. Schema & Structured Data** | 14 | `Organization`+`sameAs`, `WebSite`+`SearchAction`, `FAQPage`, `HowTo`, `Article`, `Product`+`Offer`, `BreadcrumbList` |
| **4. Content Citability** | 18 | Citation density, quotation presence, statistic density, answer-first ratio, 134–167w passage window, TL;DR, voice-answer chunks, Flesch-Kincaid, keyword-stuffing NEGATIVE |
| **5. E-E-A-T / Credibility** | 12 | Author bylines with Person schema + credentials, dateModified, freshness tiers, primary-source outlinks, first-party data markers |
| **6. Entity Strength** | 10 | Organization schema depth, Wikipedia + Wikidata linkage, 11-platform brand mention scan, knowledge graph presence |
| **7. Technical Foundations** | 8 | Canonical, HTTPS+HSTS, OG tags, alt coverage, internal linking, RSS, heading hierarchy |
| **8. Live LLM Citation** | 8 | 8 probes (1 unbranded + 7 branded), hallucinations, cross-platform citation presence |

**Veto gates** (cap at 39): all AI bots blocked, site-wide noai headers, ≥3 hallucinations detected, or zero structured data AND no Wikipedia article.

**Grade bands:** A 86–100 · B 68–85 · C 51–67 · D 36–50 · F 0–35

---

## Research foundations

All scoring weights and lift multipliers are sourced from published research — no hand-wavy "best practices":

- **Aggarwal, P. et al. (2024).** *GEO: Generative Engine Optimization.* KDD 2024. [arXiv:2311.09735](https://arxiv.org/abs/2311.09735)
  - Benchmark: 10k queries, 9 domains
  - **Top levers**: Cite Sources (+30–40% visibility), Quotations (+30–35%), Statistics (+30–37%)
  - **Negative signal**: Keyword stuffing (flagged in rubric as penalty)
- **AutoGEO (ICLR'26).** [github.com/cxcscmu/AutoGEO](https://github.com/cxcscmu/AutoGEO)
  - Answer-First +25%, Passage Density +23%
- **llms.txt spec.** [llmstxt.org](https://llmstxt.org)
- **Schema.org** [schema.org](https://schema.org)

---

## What `geo-lens` does NOT do (on purpose)

- ❌ Recommend keyword density, meta keywords, backlink building — those are classic SEO, not GEO
- ❌ Generate content for you (use a content-writing skill separately)
- ❌ Game the system — no fake schema, cloaking, or cite-bait
- ❌ Replace manual verification — WebFetch returns processed HTML; the report flags signals needing `curl -A "GPTBot"` re-verification
- ❌ Work on paywalled/authenticated sites — those need a specialised MCP integration

---

## Re-audit workflow (recommended cadence)

1. Run initial audit, note baseline score
2. Use the Citation Calculator to pick a fix bundle (tick opportunities, watch projected gain)
3. Ship the fixes (use the copy-paste templates in the report)
4. Re-run `geo-lens` after deploy
5. Compare deltas — focus on live citation rate, not just structural score

Quarterly re-audits are sufficient for most brands. Run more frequently (monthly) if you're in a fast-moving category (AI, crypto, health).

---

## Contributing

PRs welcome. Areas looking for help:

- **Per-platform lane scoring depth** — ChatGPT vs Perplexity specific weight tuning
- **Hallucination detection** — better regex/heuristics for factual claims vs brand truth
- **Passage extraction** — proper client-side HTML parsing for citability window
- **More code templates** — HowTo, Dataset, Person schemas
- **Non-English audits** — rubric is currently English-biased

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## Prior art / thanks

`geo-lens` stands on the shoulders of excellent prior work:

- [Auriti-Labs/geo-optimizer-skill](https://github.com/Auriti-Labs/geo-optimizer-skill) — 100-pt rubric inspiration, 27-bot matrix
- [aaron-he-zhu/seo-geo-claude-skills](https://github.com/aaron-he-zhu/seo-geo-claude-skills) — CORE-EEAT + CITE framework
- [zubair-trabzada/geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) — platform-specific lane weighting
- [onvoyage-ai/gtm-engineer-skills](https://github.com/onvoyage-ai/gtm-engineer-skills) — framework-specific fix generation
- [199-biotechnologies/claude-skill-seo-geo-optimizer](https://github.com/199-biotechnologies/claude-skill-seo-geo-optimizer) — per-signal uplift measurements

What `geo-lens` adds: interactive single-file HTML + live Citation Calculator + integrated LLM probing in one Claude-native skill.

---

## License

MIT. See [`LICENSE`](LICENSE).
