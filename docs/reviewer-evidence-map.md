# Review Guide - EcoTide

Updated: 2026-05-30

Use this page as the short path through the repository. It keeps the review grounded in the code, docs, commands, and boundaries that are already present.

## Summary

| Field | Notes |
|---|---|
| Lane | B2C/B2B education simulation |
| Core idea | Native simulation app showing motion telemetry, scenario replay, and calm mobile craft. |
| Primary reader | Mobile product reviewers, educators, workshop creators, and SwiftUI teams. |
| Stack | Swift |

## Open First

1. Start with the README fast path and architecture section.
2. Open `docs/monetization-playbook.md` only when reviewing the product or service angle.
3. Check the commands below before making claims about quality.
4. Skim the CI workflows and fixture data before deeper implementation review.
5. Read the boundaries section before presenting the project externally.

## Checks

| Purpose | Command |
|---|---|
| Build check | `swift build` |

## CI

- .github/workflows/architecture-blueprint.yml
- .github/workflows/ci.yml
- .github/workflows/dependency-review.yml
- .github/workflows/pages-auto-deploy.yml
- .github/workflows/repository-health.yml
- .github/workflows/repository-surface.yml
- .github/workflows/secret-scan.yml

## Evidence

- Swift Package/Xcode review path
- CLI smoke passes
- Motion fallback is explicit
- Review pack is generated

## Commercial Notes

| Possible offer | Working price assumption |
|---|---|
| Paid educational app prototype | $2-$5 app |
| Workshop demo license | $500-$2k workshop license |
| Native UX case-study package | $2k-$8k UX prototype engagement |

## Boundaries

- Telemetry privacy
- Avoid scientific accuracy overclaims
- Motion data opt-in

## Useful Metrics

- Scenario completions
- Workshop adoption
- App retention
