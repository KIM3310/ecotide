import EcoTideShared

// Compile-smoke coverage for the reviewer-handoff scenario contract.
// Runtime CLI verification stays in scripts/smoke_cli_review_pack.sh.
func compileScenarioFocusRegression() {
    let quickStarts = ScenarioDefinition.quickStarts
    let criticalDrill = ScenarioDefinition.criticalDrill

    _ = quickStarts.count
    _ = quickStarts.first?.focusCard.actionLabel
    _ = quickStarts.last?.focusCard.temperatureLabel
    _ = quickStarts.first?.focusCard.signalPills
    _ = quickStarts.first?.focusCard.confidenceLine
    _ = criticalDrill.id
    _ = ScenarioDefinition.criticalDrillID
    _ = criticalDrill.focusCard.title
    _ = criticalDrill.focusCard.signalPills.last
    _ = criticalDrill.focusCard.confidenceLine
    _ = criticalDrill.focusCard.proofLine
    _ = quickStarts.first?.reviewerHandoff.lane
    _ = quickStarts[1].reviewerHandoff.owner
    _ = criticalDrill.reviewerHandoff.nextAction
}
