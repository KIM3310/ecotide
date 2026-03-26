import Foundation

public struct ScenarioFocusCard: Equatable {
    public let title: String
    public let temperatureLabel: String
    public let headline: String
    public let reviewerNote: String
    public let confidenceLine: String
    public let actionLabel: String
    public let signalPills: [String]
    public let proofLine: String

    public init(title: String, temperatureLabel: String, headline: String, reviewerNote: String, confidenceLine: String, actionLabel: String, signalPills: [String], proofLine: String) {
        self.title = title
        self.temperatureLabel = temperatureLabel
        self.headline = headline
        self.reviewerNote = reviewerNote
        self.confidenceLine = confidenceLine
        self.actionLabel = actionLabel
        self.signalPills = signalPills
        self.proofLine = proofLine
    }
}

public struct ScenarioReviewerHandoff: Equatable {
    public let lane: String
    public let owner: String
    public let nextAction: String

    public init(lane: String, owner: String, nextAction: String) {
        self.lane = lane
        self.owner = owner
        self.nextAction = nextAction
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
        let severityLabel: String
        let waterLoadGuidance: String
        let reviewerCue: String
        let confidenceLine: String
        let proofLine: String

        if temperature < 2.0 {
            severityLabel = "Severity · Stable"
            waterLoadGuidance = "Water load · Low drift"
            reviewerCue = "Review cue · Start here"
            confidenceLine = "Confidence line · Begin here so the simulation feels calm before you ask reviewers to interpret pressure."
            proofLine = "Proof path · Open calm baseline first, then escalate only after reviewers see a stable shelf."
        } else if temperature < 4.0 {
            severityLabel = "Severity · Escalating"
            waterLoadGuidance = "Water load · Watch drift"
            reviewerCue = "Review cue · Explain action window"
            confidenceLine = "Confidence line · Use this only after baseline so the scenario shift feels explainable rather than abrupt."
            proofLine = "Proof path · Use this watch band to explain how motion and thermal pressure combine before failure."
        } else {
            severityLabel = "Severity · Critical"
            waterLoadGuidance = "Water load · Peak flood risk"
            reviewerCue = "Review cue · Reset after proof"
            confidenceLine = "Confidence line · Use this emotional peak after the calmer route, then reset immediately so the proof stays reviewer-safe."
            proofLine = "Proof path · Show the surge, read next action, then reset so the dramatic state stays reproducible."
        }

        return ScenarioFocusCard(
            title: title,
            temperatureLabel: String(format: "+%.1f°C", temperature),
            headline: headline,
            reviewerNote: reviewerNote,
            confidenceLine: confidenceLine,
            actionLabel: "Load \(title)",
            signalPills: [severityLabel, waterLoadGuidance, reviewerCue],
            proofLine: proofLine
        )
    }

    public var reviewerHandoff: ScenarioReviewerHandoff {
        if temperature < 2.0 {
            return ScenarioReviewerHandoff(
                lane: "baseline-proof",
                owner: "review host",
                nextAction: "Open the calm baseline first and only escalate after reviewers understand the stable shelf."
            )
        } else if temperature < 4.0 {
            return ScenarioReviewerHandoff(
                lane: "watch-band",
                owner: "simulation operator",
                nextAction: "Narrate the action window before the scenario tips into the critical drill."
            )
        }
        return ScenarioReviewerHandoff(
            lane: "critical-drill",
            owner: "demo lead",
            nextAction: "Show the surge, explain the risk, then reset immediately so the proof stays reproducible."
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
