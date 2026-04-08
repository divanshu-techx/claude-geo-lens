# Contributing to geo-lens

Thanks for wanting to help. geo-lens is a single skill + single agent — contributions are small and focused by design.

## How to propose a change

1. **Open an issue first** for anything larger than a typo. Describe the problem, the measurable signal you want to add/change, and any research citation.
2. **Fork + branch** from `main`.
3. **Keep changes surgical**. One signal, one check, one fix at a time.
4. **Update `CHANGELOG.md`** under Unreleased.
5. **Open a PR** with before/after evidence — ideally a re-audit of `examples/cox.com` showing the delta.

## Signal-contribution checklist

When adding or changing a measurable signal in `skills/geo-lens/SKILL.md`:

- [ ] **Research citation** — arXiv / KDD / ICLR / reputable blog (no vibes)
- [ ] **Deterministic check** — can be computed from WebFetch output, not subjective
- [ ] **Point weight** — justified relative to existing signals
- [ ] **Calculator entry** — add to the Opportunities table with `data-score` / `data-cite` / `data-hours`
- [ ] **Threshold** — explicit numeric threshold where applicable
- [ ] **Failure mode** — documented in the "Failure modes" section if nontrivial

## Style

- Skill file: markdown with YAML frontmatter. Keep under 400 lines.
- Agent file: markdown with YAML frontmatter. Keep under 100 lines.
- No external dependencies in install or report. Single-file HTML output only.
- No emojis in code or outputs unless the user explicitly asks.

## Testing

There's no CI. Before submitting a PR:

1. Install your branch via `./install.sh`
2. Run the skill against **three** live sites (pick one large brand, one SaaS, one long-tail)
3. Open each HTML report and confirm the Citation Calculator updates correctly
4. Attach screenshots to the PR

## What we'll reject

- Keyword-stuffing recommendations
- Backlink-building recommendations
- Schema-gaming tactics (fake Person bios, cloaked FAQ)
- Signals without a citation
- Changes that turn the single-file HTML into a multi-file build

## Code of conduct

Be kind. Be specific. Cite your sources.
