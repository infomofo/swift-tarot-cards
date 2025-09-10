import Foundation

// MARK: - Spread System

/// Represents a position in a tarot spread
public struct SpreadPosition: Codable, Hashable, Identifiable {
    public let id = UUID()
    public let position: Int
    public let name: String
    public let positionSignificance: String
    public let dealOrder: Int
    
    private enum CodingKeys: String, CodingKey {
        case position, name, dealOrder
        case positionSignificance = "position_significance"
    }
    
    public init(position: Int, name: String, positionSignificance: String, dealOrder: Int) {
        self.position = position
        self.name = name
        self.positionSignificance = positionSignificance
        self.dealOrder = dealOrder
    }
}

/// Layout position for visual representation of spreads
public struct SpreadLayoutPosition: Codable, Hashable {
    public let position: Int
    public let x: Double
    public let y: Double
    public let rotation: Double?
    
    public init(position: Int, x: Double, y: Double, rotation: Double? = nil) {
        self.position = position
        self.x = x
        self.y = y
        self.rotation = rotation
    }
}

/// A tarot spread definition
public struct TarotSpread: Codable, Hashable, Identifiable {
    public let id = UUID()
    public let name: String
    public let description: String
    public let positions: [SpreadPosition]
    public let layout: [SpreadLayoutPosition]
    public let allowReversals: Bool
    public let preferredStrategy: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, description, positions, layout
        case allowReversals = "allow_reversals"
        case preferredStrategy = "preferred_strategy"
    }
    
    /// Number of cards in this spread
    public var cardCount: Int {
        return positions.count
    }
    
    public init(
        name: String,
        description: String,
        positions: [SpreadPosition],
        layout: [SpreadLayoutPosition],
        allowReversals: Bool = true,
        preferredStrategy: String? = nil
    ) {
        self.name = name
        self.description = description
        self.positions = positions
        self.layout = layout
        self.allowReversals = allowReversals
        self.preferredStrategy = preferredStrategy
    }
}

/// A card drawn for a specific position in a spread
public struct DrawnCard: Identifiable, Hashable {
    public let id = UUID()
    public let card: any TarotCard
    public let position: SpreadPosition
    public let isReversed: Bool
    
    public init(card: any TarotCard, position: SpreadPosition, isReversed: Bool = false) {
        self.card = card
        self.position = position
        self.isReversed = isReversed
    }
    
    public static func == (lhs: DrawnCard, rhs: DrawnCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// A complete tarot reading with spread and drawn cards
public struct TarotReading: Identifiable {
    public let id = UUID()
    public let spread: TarotSpread
    public let drawnCards: [DrawnCard]
    public let timestamp: Date
    public let userContext: String?
    
    public init(spread: TarotSpread, drawnCards: [DrawnCard], userContext: String? = nil) {
        self.spread = spread
        self.drawnCards = drawnCards
        self.timestamp = Date()
        self.userContext = userContext
    }
    
    /// Get the card for a specific position
    public func cardFor(position: Int) -> DrawnCard? {
        return drawnCards.first { $0.position.position == position }
    }
    
    /// Generate a basic interpretation of the reading
    public func basicInterpretation() -> String {
        var interpretation = "Reading: \(spread.name)\n\n"
        
        if let context = userContext {
            interpretation += "Context: \(context)\n\n"
        }
        
        for drawnCard in drawnCards.sorted(by: { $0.position.dealOrder < $1.position.dealOrder }) {
            interpretation += "\(drawnCard.position.name): \(drawnCard.card.textRepresentation(isReversed: drawnCard.isReversed))\n"
            interpretation += "Significance: \(drawnCard.position.positionSignificance)\n"
            
            if let visualCard = drawnCard.card as? VisuallyRepresentable {
                interpretation += "\(visualCard.renderingDescription(isReversed: drawnCard.isReversed))\n"
            }
            
            interpretation += "\n"
        }
        
        return interpretation
    }
}

// MARK: - Common Spreads

/// Factory for creating common tarot spreads
public struct CommonSpreads {
    
    /// A simple three-card spread (Past, Present, Future)
    public static let threeCard = TarotSpread(
        name: "Three Card Spread",
        description: "A simple spread representing Past, Present, and Future",
        positions: [
            SpreadPosition(
                position: 1, 
                name: "Past", 
                positionSignificance: "Events and influences from the past affecting the current situation", 
                dealOrder: 1
            ),
            SpreadPosition(position: 2, name: "Present", positionSignificance: "The current situation and immediate influences", dealOrder: 2),
            SpreadPosition(position: 3, name: "Future", positionSignificance: "Potential outcomes and future developments", dealOrder: 3)
        ],
        layout: [
            SpreadLayoutPosition(position: 1, x: 0.0, y: 0.5),
            SpreadLayoutPosition(position: 2, x: 0.5, y: 0.5),
            SpreadLayoutPosition(position: 3, x: 1.0, y: 0.5)
        ]
    )
    
    /// Single card draw for yes/no or daily guidance
    public static let singleCard = TarotSpread(
        name: "Single Card",
        description: "A single card draw for daily guidance or simple questions",
        positions: [
            SpreadPosition(position: 1, name: "Guidance", positionSignificance: "The main message or guidance for your question", dealOrder: 1)
        ],
        layout: [
            SpreadLayoutPosition(position: 1, x: 0.5, y: 0.5)
        ]
    )
    
    /// Celtic Cross spread (10 cards)
    public static let celticCross = TarotSpread(
        name: "Celtic Cross",
        description: "The classic 10-card spread for comprehensive life readings",
        positions: [
            SpreadPosition(position: 1, name: "Present Situation", positionSignificance: "Your current circumstances and state of mind", dealOrder: 1),
            SpreadPosition(position: 2, name: "Challenge", positionSignificance: "The challenge or obstacle you face", dealOrder: 2),
            SpreadPosition(position: 3, name: "Distant Past", positionSignificance: "Past events that led to the current situation", dealOrder: 3),
            SpreadPosition(position: 4, name: "Recent Past", positionSignificance: "Recent events affecting the present", dealOrder: 4),
            SpreadPosition(position: 5, name: "Possible Outcome", positionSignificance: "What may happen if current path continues", dealOrder: 5),
            SpreadPosition(position: 6, name: "Near Future", positionSignificance: "What will likely happen in the immediate future", dealOrder: 6),
            SpreadPosition(position: 7, name: "Your Approach", positionSignificance: "Your approach to the situation", dealOrder: 7),
            SpreadPosition(position: 8, name: "External Influences", positionSignificance: "How others perceive you and external factors", dealOrder: 8),
            SpreadPosition(position: 9, name: "Hopes and Fears", positionSignificance: "Your inner emotions, hopes, and fears", dealOrder: 9),
            SpreadPosition(position: 10, name: "Final Outcome", positionSignificance: "The ultimate outcome based on current path", dealOrder: 10)
        ],
        layout: [
            SpreadLayoutPosition(position: 1, x: 0.4, y: 0.5),      // Center
            SpreadLayoutPosition(position: 2, x: 0.4, y: 0.5, rotation: 90), // Cross
            SpreadLayoutPosition(position: 3, x: 0.4, y: 0.8),      // Bottom
            SpreadLayoutPosition(position: 4, x: 0.1, y: 0.5),      // Left
            SpreadLayoutPosition(position: 5, x: 0.4, y: 0.2),      // Top
            SpreadLayoutPosition(position: 6, x: 0.7, y: 0.5),      // Right
            SpreadLayoutPosition(position: 7, x: 0.85, y: 0.8),     // Staff bottom
            SpreadLayoutPosition(position: 8, x: 0.85, y: 0.65),    // Staff 2nd
            SpreadLayoutPosition(position: 9, x: 0.85, y: 0.35),    // Staff 3rd
            SpreadLayoutPosition(position: 10, x: 0.85, y: 0.2)     // Staff top
        ]
    )
    
    /// Get all predefined spreads
    public static let allSpreads = [singleCard, threeCard, celticCross]
}

// MARK: - Reading Generator

/// Generates tarot readings using a deck and spread
public class TarotReadingGenerator {
    private let deck: TarotDeck
    private let reversalProbability: Double
    
    public init(deck: TarotDeck, reversalProbability: Double = 0.3) {
        self.deck = deck
        self.reversalProbability = reversalProbability
    }
    
    /// Generate a reading for the given spread
    public func generateReading(
        spread: TarotSpread,
        selectionStrategy: CardSelectionStrategy = RandomCardSelectionStrategy(),
        userContext: String? = nil
    ) -> TarotReading {
        
        // Draw cards for the spread
        let drawnTarotCards = deck.drawCards(count: spread.cardCount, strategy: selectionStrategy)
        
        // Create DrawnCard objects with reversal chance
        var drawnCards: [DrawnCard] = []
        for (index, position) in spread.positions.enumerated() {
            guard index < drawnTarotCards.count else { break }
            
            let card = drawnTarotCards[index]
            let isReversed = spread.allowReversals && Double.random(in: 0...1) < reversalProbability
            
            let drawnCard = DrawnCard(card: card, position: position, isReversed: isReversed)
            drawnCards.append(drawnCard)
        }
        
        return TarotReading(spread: spread, drawnCards: drawnCards, userContext: userContext)
    }
}