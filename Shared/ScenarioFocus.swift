import Foundation

public struct ScenarioFocusCard: Equatable {
    public let title: String
    public let temperatureLabel: String
    public let headline: String
    public let reviewerNote: String
    public let actionLabel: String

    public init(title: String, temperatureLabel: String, headline: String, reviewerNote: String, actionLabel: String) {
        self.title = title
        self.temperatureLabel = temperatureLabel
        self.headline = headline
        self.reviewerNote = reviewerNote
        self.actionLabel = actionLabel
    }
}

public struct ScenarioDefinition: Equatable {
    public static let criticalDrillID = "critical-drill"

    public let id: String
    public let title: String
    public let temperature: Double
    public let headline: String
    public let reviewerNote: String

    public init(id: String, title: String, temperature: Double, headline: String, reviewerNote: String) {
        self.id = id
        self.title = title
        self.temperature = temperature
        self.headline = headline
        self.reviewerNote = reviewerNote
    }

    public var focusCard: ScenarioFocusCard {
        ScenarioFocusCard(
            title: title,
            temperatureLabel: String(format: "+%.1f°C", temperature),
            headline: headline,
            reviewerNote: reviewerNote,
            actionLabel: "Load \(title)"
        )
    }

    public static let quickStarts: [ScenarioDefinition] = [
        ScenarioDefinition(
            id: "cold-baseline",
            title: "Cold Baseline",
            temperature: 1.2,
            headline: "Show the habitat before stress: stable shelf, low flood risk, calm gravity.",
            reviewerNote: "Use this first when you want an emotionally calm opening for reviewers."
        ),
        ScenarioDefinition(
            id: "coastline-watch",
            title: "Coastline Watch",
            temperature: 3.1,
            headline: "Move into the watch band where the village still feels recoverable but pressure is visible.",
            reviewerNote: "Best for explaining the moment where action still matters."
        ),
        ScenarioDefinition(
            id: "critical-drill",
            title: "Critical Drill",
            temperature: 4.6,
            headline: "Jump straight to the emotional failure case: rapid melt, high water load, and urgent next action.",
            reviewerNote: "Use after baseline so the risk jump feels earned, not theatrical."
        )
    ]

    public static var criticalDrill: ScenarioDefinition {
        quickStarts.first(where: { $0.id == criticalDrillID }) ?? quickStarts.last!
    }
}
