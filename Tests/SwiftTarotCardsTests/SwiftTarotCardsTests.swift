import XCTest
@testable import SwiftTarotCards

final class SwiftTarotCardsTests: XCTestCase {
    
    func testRomanNumeralConversion() {
        XCTAssertEqual(toRomanNumeral(0), "0")
        XCTAssertEqual(toRomanNumeral(1), "I")
        XCTAssertEqual(toRomanNumeral(4), "IV")
        XCTAssertEqual(toRomanNumeral(5), "V")
        XCTAssertEqual(toRomanNumeral(9), "IX")
        XCTAssertEqual(toRomanNumeral(10), "X")
        XCTAssertEqual(toRomanNumeral(21), "XXI")
    }
    
    func testMajorArcanaNumbers() {
        XCTAssertEqual(MajorArcanaNumber.fool.rawValue, 0)
        XCTAssertEqual(MajorArcanaNumber.fool.displayName, "The Fool")
        XCTAssertEqual(MajorArcanaNumber.fool.romanNumeral, "0")
        
        XCTAssertEqual(MajorArcanaNumber.magician.rawValue, 1)
        XCTAssertEqual(MajorArcanaNumber.magician.displayName, "The Magician")
        XCTAssertEqual(MajorArcanaNumber.magician.romanNumeral, "I")
        
        XCTAssertEqual(MajorArcanaNumber.world.rawValue, 21)
        XCTAssertEqual(MajorArcanaNumber.world.displayName, "The World")
        XCTAssertEqual(MajorArcanaNumber.world.romanNumeral, "XXI")
    }
    
    func testMinorNumbers() {
        XCTAssertEqual(MinorNumber.ace.rawValue, 1)
        XCTAssertEqual(MinorNumber.ace.displayName, "Ace")
        
        XCTAssertEqual(MinorNumber.king.rawValue, 14)
        XCTAssertEqual(MinorNumber.king.displayName, "King")
    }
    
    func testSuitElements() {
        // Test that we can access all suits and they have distinct values
        let allSuits = Suit.allCases
        XCTAssertEqual(allSuits.count, 4)
        XCTAssertTrue(allSuits.contains(.cups))
        XCTAssertTrue(allSuits.contains(.pentacles))
        XCTAssertTrue(allSuits.contains(.swords))
        XCTAssertTrue(allSuits.contains(.wands))
    }
    
    func testShuffleStrategies() {
        let cards = ["A", "B", "C", "D", "E"]
        
        // Test secure shuffle
        let secureStrategy = SecureShuffleStrategy()
        let secureShuffled = secureStrategy.shuffle(cards)
        XCTAssertEqual(secureShuffled.count, cards.count)
        XCTAssertEqual(Set(secureShuffled), Set(cards))
        
        // Test simple shuffle
        let simpleStrategy = SimpleShuffleStrategy()
        let simpleShuffled = simpleStrategy.shuffle(cards)
        XCTAssertEqual(simpleShuffled.count, cards.count)
        XCTAssertEqual(Set(simpleShuffled), Set(cards))
    }
    
    func testCommonSpreads() {
        // Test single card spread
        let singleCard = CommonSpreads.singleCard
        XCTAssertEqual(singleCard.name, "Single Card")
        XCTAssertEqual(singleCard.positions.count, 1)
        XCTAssertEqual(singleCard.layout.count, 1)
        
        // Test three card spread
        let threeCard = CommonSpreads.threeCard
        XCTAssertEqual(threeCard.name, "Three Card Spread")
        XCTAssertEqual(threeCard.positions.count, 3)
        XCTAssertEqual(threeCard.layout.count, 3)
        
        // Test Celtic Cross
        let celticCross = CommonSpreads.celticCross
        XCTAssertEqual(celticCross.name, "Celtic Cross")
        XCTAssertEqual(celticCross.positions.count, 10)
        XCTAssertEqual(celticCross.layout.count, 10)
    }
    
    func testSpreadPositions() {
        let position = SpreadPosition(
            position: 1,
            name: "Test Position",
            positionSignificance: "Test significance",
            dealOrder: 1
        )
        
        XCTAssertEqual(position.position, 1)
        XCTAssertEqual(position.name, "Test Position")
        XCTAssertEqual(position.positionSignificance, "Test significance")
        XCTAssertEqual(position.dealOrder, 1)
    }
    
    func testCardSelectionStrategies() {
        // Create mock cards for testing
        let mockCards = createMockCards()
        
        // Test top selection
        let topStrategy = TopCardSelectionStrategy()
        let topSelected = topStrategy.selectCards(from: mockCards, count: 3)
        XCTAssertEqual(topSelected.count, 3)
        XCTAssertEqual(topSelected[0].id, mockCards[0].id)
        XCTAssertEqual(topSelected[1].id, mockCards[1].id)
        XCTAssertEqual(topSelected[2].id, mockCards[2].id)
        
        // Test random selection
        let randomStrategy = RandomCardSelectionStrategy(shuffleStrategy: SimpleShuffleStrategy())
        let randomSelected = randomStrategy.selectCards(from: mockCards, count: 3)
        XCTAssertEqual(randomSelected.count, 3)
        
        // All selected cards should be from the original deck
        for card in randomSelected {
            XCTAssertTrue(mockCards.contains { $0.id == card.id })
        }
    }
    
    // MARK: - Helper Methods
    
    private func createMockCards() -> [MockTarotCard] {
        return (1...10).map { index in
            MockTarotCard(
                id: "mock-\(index)",
                name: "Mock Card \(index)",
                keywords: ["keyword\(index)"],
                meanings: CardMeanings(upright: ["upright\(index)"], reversed: ["reversed\(index)"]),
                visualDescription: VisualDescription(background: "bg\(index)", foreground: "fg\(index)"),
                visualDescriptionAnalysis: ["analysis\(index)"],
                symbols: ["symbol\(index)"],
                significance: "significance\(index)"
            )
        }
    }
}

// MARK: - Mock Card for Testing

private struct MockTarotCard: TarotCard, Hashable {
    let id: String
    let name: String
    let keywords: [String]
    let meanings: CardMeanings
    let visualDescription: VisualDescription
    let visualDescriptionAnalysis: [String]
    let symbols: [String]
    let significance: String
    let arcana: Arcana = .major
    
    func textRepresentation(isReversed: Bool) -> String {
        return "\(name)\(isReversed ? " (Reversed)" : "")"
    }
    
    static func == (lhs: MockTarotCard, rhs: MockTarotCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
