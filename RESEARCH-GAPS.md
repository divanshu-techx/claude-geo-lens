# Research Gaps Identified — April 2026

Cross-referenced 5 deep research tracks (GEO fundamentals, measurement/analytics, technical implementation, competitive strategy, query intelligence) against the current v0.2.0 rubric. Below are the gaps, ranked by impact.

## NEW SIGNALS (Not Currently Measured)

### 1. Table Detection for Citability — HIGH IMPACT
- **Research:** Tables increase citation rates by 2.5x versus the same information in prose (multiple GEO studies)
- **Current:** Not measured anywhere in the rubric
- **Add to:** Content Citability category (+2 pts)
- **Detection:** Count `<table>` elements with `<thead>`/`<th>` in indexed HTML

### 2. Front-Loading Score (Kevin Indig "Ski Ramp") — HIGH IMPACT
- **Research:** 44% of ChatGPT citations come from the first 30% of content (analysis of 3M responses, 30M citations)
- **Current:** Answer-first ratio exists (checks H2 sections) but doesn't measure stat/citation/fact concentration in first 30%
- **Add to:** Content Citability category (+1 pt)
- **Detection:** % of statistics, citations, and key claims that appear in the first 30% of body word count

### 3. SpeakableSpecification Schema — MEDIUM IMPACT
- **Research:** Improves Perplexity citation likelihood, voice search positioning
- **Current:** Not in schema checklist
- **Add to:** Schema & Structured Data (+1 pt)
- **Detection:** Grep for `"@type": "SpeakableSpecification"` in JSON-LD blocks

### 4. HowTo Schema — MEDIUM IMPACT
- **Research:** Maps step-by-step instructions to AI Overview citations; currently only noted in Google AIO platform lane but not scored
- **Current:** Mentioned but not scored
- **Add to:** Schema & Structured Data (+1 pt) or fold into existing FAQPage signal
- **Detection:** Grep for `"@type": "HowTo"` in JSON-LD blocks

### 5. Video Transcript Detection — MEDIUM IMPACT
- **Research:** LLMs read transcripts, NOT video content. Pages with embedded videos but no transcript are citation-dead for that content
- **Current:** Not checked
- **Add to:** Technical Foundations (+1 pt)
- **Detection:** Pages with `<video>`, `<iframe[youtube/vimeo]>` — check for `<track>` element or transcript text nearby

### 6. Reddit + YouTube Weighted Presence — HIGH IMPACT
- **Research:** Reddit is Perplexity's #1 content source (6.6% of all citations). YouTube is the strongest single correlating factor for Google AI Overview visibility
- **Current:** 11-platform scan treats all platforms equally (≥3 mentions = +2)
- **Upgrade:** Split into: Reddit OR YouTube present = +1 bonus, on top of existing 11-platform score
- **Add to:** Entity Strength

### 7. Entity Density — MEDIUM IMPACT
- **Research:** Pages with 15+ recognized entities show 4.8x higher selection probability
- **Current:** Not measured
- **Hard to measure** without NLP; could approximate by counting proper nouns, branded terms, linked entities
- **Consider for future version**

## UPGRADED EXISTING SIGNALS

### 8. Expanded Prober Query Matrix (8 → 12 queries)
- **Research:** 20-30 prompts minimum recommended; current 8 misses important query types
- **Add 4 new queries:**
  - `{category} for {use_case}` — use-case query (e.g., "CRM for startups")
  - `is {brand} worth it` — purchase intent
  - `{brand} vs {competitor_2}` — second competitor comparison
  - `problems with {brand}` — negative sentiment test
- **Impact:** Better citation rate accuracy, catches more hallucinations

### 9. Training vs Search Bot Hybrid Recommendation
- **Research:** Clear 3-tier classification: training bots (block), search bots (allow), user-agent bots (allow). Blocking training does NOT affect search citations.
- **Current:** 27-bot matrix exists but the remediation template allows ALL bots uniformly
- **Fix:** Update robots.txt template to show hybrid approach (block GPTBot/ClaudeBot training, allow OAI-SearchBot/Claude-SearchBot/PerplexityBot search)

### 10. Platform Lane Scoring Updates
- **Research provides specific platform preferences:**
  - ChatGPT: Wikipedia accounts for 47.9% of top-10 citations; Bing indexation critical
  - Perplexity: Reddit is #1 source (6.6%); processes 780M-1.4B monthly queries
  - Google AIO: Citations from top-10 pages dropped from 76% to 38% in 2026 (Gemini 3 query fan-out)
  - Only 11% of domains cited by both ChatGPT and Perplexity
- **Update lane scoring** with these specific weights

## NEW REPORT SECTIONS

### 11. Dark Traffic Advisory — HIGH VALUE
- **Research:** 60-70% of ChatGPT traffic hides in GA4 "Direct" bucket. Mobile apps strip referrer headers. Dark AI traffic converts at 10.2% vs 2.5% non-AI.
- **Current:** Not mentioned anywhere in the report
- **Add to:** Reporter as advisory section after main scorecard
- **Content:** Warning about hidden AI traffic, GA4 custom channel setup instructions, regex pattern for AI source matching

### 12. GA4 + Bing Webmaster Setup as Remediation Item
- **Research:** Specific GA4 custom channel regex, Bing Webmaster Tools AI Performance Report (Feb 2026) shows grounding queries and citations
- **Current:** No analytics setup recommendations
- **Add to:** Remediation as QUICK_WIN
- **Include:** GA4 regex pattern, Bing WMT registration, CDN log monitoring setup

### 13. AI Traffic Conversion Context
- **Research:** Claude 16.8%, ChatGPT 14.2%, Perplexity 12.4% vs Google organic 2.8% (5x advantage)
- **Add to:** Report methodology section to contextualize why GEO matters

### 14. Agentic Commerce Readiness Advisory
- **Research:** Google Universal Commerce Protocol (Jan 2026), OpenAI Agent Commerce Protocol, Mastercard Verifiable Intent, Morgan Stanley predicts 25% of spending via AI agents by 2030
- **Current:** Not mentioned
- **Add to:** Report as future-looking advisory section
- **Detection:** Check for MCP endpoints, API documentation, machine-readable product catalogs

## NEW RESEARCH CITATIONS TO ADD

Current: arXiv:2311.09735 (Princeton KDD 2024), AutoGEO ICLR'26

Add:
- Kevin Indig: "The Science of How AI Picks Its Sources" (3M ChatGPT responses, 30M citations)
- Cloudflare: "From Googlebot to GPTBot" (crawl-to-click ratios, bot traffic statistics)
- Cloudflare: "The Crawl-to-Click Gap" (38,000:1 ratio data)
- Relixir July 2025: FAQPage schema 41% vs 15% citation rate study
- Digital Bloom: 2025 AI Visibility Report (brand authority 0.334 correlation)
- Bing Webmaster Blog: AI Performance Report (Feb 2026)
- Adobe Analytics: AI traffic to US retail +1,200% YoY
- a16z: "How GEO Rewrites the Rules of Search"

## NEW REMEDIATION TEMPLATES

### HowTo Schema Template
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "{title}",
  "step": [
    {"@type": "HowToStep", "name": "{step1}", "text": "{detail1}"},
    {"@type": "HowToStep", "name": "{step2}", "text": "{detail2}"}
  ]
}
</script>
```

### SpeakableSpecification Template
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "speakable": {
    "@type": "SpeakableSpecification",
    "cssSelector": [".article-summary", ".faq-answer"]
  }
}
</script>
```

### GA4 Custom Channel Setup (remediation QUICK_WIN)
```
GA4 → Admin → Data Display → Channel Groups → New
Name: "AI / LLM Traffic"
Condition: Source matches regex:
(chatgpt|openai|anthropic|deepseek|grok)\.com|(gemini|bard)\.google\.com|(perplexity|claude)\.ai|(copilot\.microsoft|edgeservices\.bing)\.com|meta\.ai|you\.com|poe\.com|phind\.com|kagi\.com

CRITICAL: Drag ABOVE "Referral" channel (GA4 uses waterfall matching)
```

### Hybrid robots.txt Template (replaces current "allow all" template)
```
# TRAINING CRAWLERS — block (bulk data collection, no traffic back)
User-agent: GPTBot
Disallow: /

User-agent: ClaudeBot
Disallow: /

User-agent: Google-Extended
Disallow: /

User-agent: CCBot
Disallow: /

User-agent: Bytespider
Disallow: /

User-agent: Applebot-Extended
Disallow: /

User-agent: Meta-ExternalAgent
Disallow: /

# SEARCH/RETRIEVAL CRAWLERS — allow (cite and link back to you)
User-agent: OAI-SearchBot
Allow: /

User-agent: Claude-SearchBot
Allow: /

User-agent: PerplexityBot
Allow: /

# USER-FACING AGENTS — allow (browsing on behalf of users)
User-agent: ChatGPT-User
Allow: /

User-agent: Claude-User
Allow: /

User-agent: Perplexity-User
Allow: /
```

## POINT REDISTRIBUTION

Current total: 100 points
Proposed additions: +6 points (table +2, front-loading +1, speakable +1, howto +1, video transcript +1)

**New total: 106 points**

Updated grade bands:
- A: 90-106 (was 86-100)
- B: 72-89 (was 68-85)
- C: 54-71 (was 51-67)
- D: 38-53 (was 36-50)
- F: 0-37 (was 0-35)

Veto gate cap: 42 (was 39, proportional)
