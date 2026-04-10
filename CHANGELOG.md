# Changelog

## [0.3.0] — 2026-04-11

### Added — New Signals (Research-Backed)
- **Table detection** (+2 pts Content Citability): HTML `<table>` with `<thead>`/`<th>` — tables increase citation rate 2.5x vs prose (multiple GEO studies)
- **Front-loading score** (+1 pt Content Citability): % of stats/citations in first 30% of body — Kevin Indig analysis: 44% of ChatGPT citations come from first 30% of content (3M responses, 30M citations)
- **SpeakableSpecification schema** (+1 pt Schema): improves Perplexity/voice citation likelihood (Relixir 2025)
- **HowTo schema** (+1 pt Schema): maps step-by-step instructions to AIO citations
- **Video transcript detection** (+1 pt Technical): pages with video embeds but no `<track>`/transcript are citation-dead (LLMs can't watch video)
- **Reddit + YouTube weighted presence** (+1 pt Entity): Reddit is Perplexity's #1 source (6.6% of citations), YouTube strongest AIO correlation (Digital Bloom 2025)

### Added — Expanded Prober (8 → 12 queries)
- `{category} for {use_case}` — use-case intent query
- `is {brand} worth it` — purchase intent query
- `{brand} vs {competitor_2}` — second competitor comparison
- `problems with {brand}` — negative sentiment/hallucination test

### Added — New Report Sections
- **Dark AI Traffic Advisory**: warns about 60-70% of ChatGPT traffic hiding in GA4 "Direct", includes GA4 regex for custom channel setup, Bing WMT recommendation
- **Agentic Commerce Readiness Advisory**: Google Universal Commerce Protocol, OpenAI Agent Commerce Protocol, machine-readable product data checklist

### Added — New Remediation Templates
- HowTo JSON-LD template
- SpeakableSpecification JSON-LD template
- **Hybrid robots.txt** (replaces old "allow all"): blocks training crawlers (GPTBot, ClaudeBot), allows search/retrieval (OAI-SearchBot, Claude-SearchBot, PerplexityBot)
- GA4 Custom Channel setup as QUICK_WIN remediation item
- Bing Webmaster Tools registration recommendation

### Added — New Research Citations
- Kevin Indig: "The Science of How AI Picks Its Sources" (3M ChatGPT responses, 30M citations)
- Cloudflare: "From Googlebot to GPTBot" + "The Crawl-to-Click Gap"
- Relixir: FAQPage schema 41% vs 15% citation rate (July 2025)
- Digital Bloom: 2025 AI Visibility Report (brand authority 0.334 correlation)
- Bing Webmaster Blog: AI Performance Report (Feb 2026)
- a16z: "How GEO Rewrites the Rules of Search"

### Changed
- **Rubric total: 100 → 110 points** (6 new signals added)
- **Grade bands updated**: A 90–110, B 72–89, C 54–71, D 38–53, F 0–37
- **Veto gate cap: 39 → 42** (proportional to new total)
- **Platform lane scoring enriched** with platform-specific research findings (Wikipedia 47.9% of ChatGPT citations, Reddit #1 for Perplexity, AIO query fan-out)
- **Robots.txt template** now recommends hybrid strategy (block training, allow search) instead of blanket allow

### Added — RESEARCH-GAPS.md
- Full research gap analysis document comparing 5 deep research tracks against v0.2.0 rubric

## [0.2.0] — 2026-04-08

### Added
- Research-backed scoring model (Princeton KDD 2024 + AutoGEO ICLR'26)
- 100-point rubric across 8 categories, 60+ measurable signals
- 27-bot robots.txt matrix with training/search/UA tier classification
- AI Discovery endpoint checks (`.well-known/ai.txt`, `/ai/summary.json`, `/ai/faq.json`)
- Content citability signals: citation density (+30–40% lift), quotation presence (+30–35%), statistic density (+30–37%)
- Passage citability window check (134–167 word self-contained chunks)
- Answer-first ratio (≥30% of H2s with 5–60w direct answer)
- TL;DR first-60-words check, voice-answer ≤29 words
- Flesch-Kincaid readability band 6–8
- Keyword stuffing NEGATIVE signal (-3 pts, KDD'24 finding)
- Credentialed-author detector with Person schema (+40% lift signal)
- Freshness tiers (<30d = 3.2x multiplier)
- 11-platform brand mention scan (3x backlinks correlation)
- Per-platform lanes: ChatGPT, Perplexity, Claude, Gemini, Google AIO
- Veto gates that cap score at 39
- Interactive HTML report with Citation Calculator
- Code templates: llms.txt, Organization JSON-LD, FAQPage, robots.txt AI-bot block
- Example audit: `examples/cox.com.html`

### Changed
- Renamed from `geo-audit` to `geo-lens` (name collision with existing Smithery skill)
- Report format: markdown → interactive single-file HTML
- Output directory: `~/geo-audits/`

## [0.1.0] — 2026-04-08
- Initial release: 5-axis rubric (Crawlability, Extractability, Citeability, Entity strength, Live citation)
- Markdown report format
- 8-probe live LLM testing
