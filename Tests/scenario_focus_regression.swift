import Foundation

@main
struct ScenarioFocusRegression {
    static func main() {
        precondition(ScenarioDefinition.quickStarts.count == 3)
        precondition(ScenarioDefinition.quickStarts.first?.focusCard.actionLabel == "Load Cold Baseline")
        precondition(ScenarioDefinition.quickStarts.last?.focusCard.temperatureLabel == "+4.6°C")
        precondition(ScenarioDefinition.quickStarts.first?.focusCard.signalPills == [
            "Severity · Stable",
            "Water load · Low drift",
            "Review cue · Start here"
        ])
        precondition(ScenarioDefinition.criticalDrill.id == ScenarioDefinition.criticalDrillID)
        precondition(ScenarioDefinition.criticalDrill.focusCard.title == "Critical Drill")
        precondition(ScenarioDefinition.criticalDrill.focusCard.signalPills.last == "Review cue · Reset after proof")
        precondition(ScenarioDefinition.criticalDrill.focusCard.proofLine.contains("reset"))
        print("EcoTide scenario focus regression OK")
    }
}
