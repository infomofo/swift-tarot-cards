import Foundation

// MARK: - Shuffle Strategies

/// Protocol for different deck shuffling strategies
public protocol ShuffleStrategy {
    var name: String { get }
    var description: String { get }
    
    /// Shuffle the given array of cards
    func shuffle<T>(_ cards: [T]) -> [T]
}

/// Fisher-Yates shuffle using cryptographically secure random number generator
public struct SecureShuffleStrategy: ShuffleStrategy {
    public let name = "Secure Fisher-Yates"
    public let description = "Cryptographically secure Fisher-Yates shuffle using SystemRandomNumberGenerator"
    
    public init() {}
    
    public func shuffle<T>(_ cards: [T]) -> [T] {
        var shuffled = cards
        var generator = SystemRandomNumberGenerator()
        
        for i in (1..<shuffled.count).reversed() {
            let j = Int.random(in: 0...i, using: &generator)
            shuffled.swapAt(i, j)
        }
        
        return shuffled
    }
}

/// Simple shuffle using default random number generator (for testing/development)
public struct SimpleShuffleStrategy: ShuffleStrategy {
    public let name = "Simple"
    public let description = "Basic shuffle using default random number generator"
    
    public init() {}
    
    public func shuffle<T>(_ cards: [T]) -> [T] {
        return cards.shuffled()
    }
}

// MARK: - Card Selection Strategies

/// Protocol for different card selection strategies
public protocol CardSelectionStrategy {
    var name: String { get }
    var description: String { get }
    
    /// Select the specified number of cards from the deck
    func selectCards(from deck: [any TarotCard], count: Int) -> [any TarotCard]
}

/// Select cards from the top of the deck
public struct TopCardSelectionStrategy: CardSelectionStrategy {
    public let name = "Top"
    public let description = "Select cards from the top of the deck in order"
    
    public init() {}
    
    public func selectCards(from deck: [any TarotCard], count: Int) -> [any TarotCard] {
        return Array(deck.prefix(count))
    }
}

/// Select cards randomly from the deck
public struct RandomCardSelectionStrategy: CardSelectionStrategy {
    public let name = "Random"
    public let description = "Select cards randomly from anywhere in the deck"
    
    private let shuffleStrategy: ShuffleStrategy
    
    public init(shuffleStrategy: ShuffleStrategy = SecureShuffleStrategy()) {
        self.shuffleStrategy = shuffleStrategy
    }
    
    public func selectCards(from deck: [any TarotCard], count: Int) -> [any TarotCard] {
        let shuffled = shuffleStrategy.shuffle(deck)
        return Array(shuffled.prefix(count))
    }
}

// MARK: - Tarot Deck

/// Represents a complete tarot deck with shuffling and card selection capabilities
public class TarotDeck {
    private var majorArcana: [MajorArcanaCard]
    private var minorArcana: [MinorArcanaCard]
    private let shuffleStrategy: ShuffleStrategy
    
    /// All cards in the deck (major + minor arcana)
    public var allCards: [any TarotCard] {
        return majorArcana + minorArcana
    }
    
    /// Number of cards in the deck
    public var count: Int {
        return majorArcana.count + minorArcana.count
    }
    
    /// Initialize with loaded card data
    public init(majorArcana: [MajorArcanaCard], minorArcana: [MinorArcanaCard], shuffleStrategy: ShuffleStrategy = SecureShuffleStrategy()) {
        self.majorArcana = majorArcana
        self.minorArcana = minorArcana
        self.shuffleStrategy = shuffleStrategy
    }
    
    /// Initialize from data loader
    public convenience init(dataLoader: TarotDataLoader = TarotDataLoader.shared(), shuffleStrategy: ShuffleStrategy = SecureShuffleStrategy()) throws {
        let majorCards = try dataLoader.loadAllMajorArcanaCards()
        let minorCards = try dataLoader.loadAllMinorArcanaCards()
        self.init(majorArcana: majorCards, minorArcana: minorCards, shuffleStrategy: shuffleStrategy)
    }
    
    /// Shuffle the deck
    public func shuffle() {
        majorArcana = shuffleStrategy.shuffle(majorArcana)
        minorArcana = shuffleStrategy.shuffle(minorArcana)
    }
    
    /// Reset deck to original order
    public func reset() {
        majorArcana.sort { $0.number.rawValue < $1.number.rawValue }
        minorArcana.sort { card1, card2 in
            if card1.suit == card2.suit {
                return card1.number.rawValue < card2.number.rawValue
            }
            return card1.suit.rawValue < card2.suit.rawValue
        }
    }
    
    /// Draw cards using a selection strategy
    public func drawCards(count: Int, strategy: CardSelectionStrategy = TopCardSelectionStrategy()) -> [any TarotCard] {
        let allCards: [any TarotCard] = majorArcana + minorArcana
        return strategy.selectCards(from: allCards, count: min(count, allCards.count))
    }
    
    /// Get a specific major arcana card
    public func getMajorArcana(_ number: MajorArcanaNumber) -> MajorArcanaCard? {
        return majorArcana.first { $0.number == number }
    }
    
    /// Get a specific minor arcana card
    public func getMinorArcana(suit: Suit, number: MinorNumber) -> MinorArcanaCard? {
        return minorArcana.first { $0.suit == suit && $0.number == number }
    }
    
    /// Get all cards of a specific suit
    public func getCards(suit: Suit) -> [MinorArcanaCard] {
        return minorArcana.filter { $0.suit == suit }.sorted { $0.number.rawValue < $1.number.rawValue }
    }
    
    /// Get all major arcana cards
    public func getMajorArcanaCards() -> [MajorArcanaCard] {
        return majorArcana.sorted { $0.number.rawValue < $1.number.rawValue }
    }
    
    /// Get all minor arcana cards
    public func getMinorArcanaCards() -> [MinorArcanaCard] {
        return minorArcana.sorted { card1, card2 in
            if card1.suit == card2.suit {
                return card1.number.rawValue < card2.number.rawValue
            }
            return card1.suit.rawValue < card2.suit.rawValue
        }
    }
}