#if canImport(XCTest)
import EcoTideShared
import XCTest

final class ScenarioFocusRegressionTests: XCTestCase {
    func testQuickStartsExposeReviewerFocusedCards() {
        let quickStarts = ScenarioDefinition.quickStarts

        XCTAssertEqual(quickStarts.count, 3)
        XCTAssertEqual(quickStarts.first?.focusCard.actionLabel, "Load Cold Baseline")
        XCTAssertEqual(quickStarts.last?.focusCard.temperatureLabel, "+4.6°C")
        XCTAssertEqual(quickStarts.first?.reviewerHandoff.lane, "baseline-proof")
        XCTAssertEqual(quickStarts[1].reviewerHandoff.owner, "simulation operator")
    }

    func testCriticalDrillFallsBackToExpectedScenarioContract() {
        let criticalDrill = ScenarioDefinition.criticalDrill

        XCTAssertEqual(criticalDrill.id, ScenarioDefinition.criticalDrillID)
        XCTAssertEqual(criticalDrill.focusCard.title, "Critical Drill")
        XCTAssertTrue(criticalDrill.focusCard.proofLine.contains("Show the surge"))
        XCTAssertTrue(criticalDrill.reviewerHandoff.nextAction.contains("reset immediately"))
    }
}
#endif
