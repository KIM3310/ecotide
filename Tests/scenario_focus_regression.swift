import Foundation

@main
struct ScenarioFocusRegression {
    static func main() {
        precondition(ScenarioDefinition.quickStarts.count == 3)
        precondition(ScenarioDefinition.quickStarts.first?.focusCard.actionLabel == "Load Cold Baseline")
        precondition(ScenarioDefinition.quickStarts.last?.focusCard.temperatureLabel == "+4.6°C")
        print("EcoTide scenario focus regression OK")
    }
}
