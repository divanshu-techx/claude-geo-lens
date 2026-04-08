# Changelog

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
