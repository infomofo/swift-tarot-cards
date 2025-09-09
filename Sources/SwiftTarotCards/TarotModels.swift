import Foundation

// MARK: - Data Model Structures

/// Structured symbol information from the tarot model
public struct Tag: Codable, Hashable {
    public let name: String
    public let lineage: String
    public let appearance: String
    public let interpretation: String
    public let meaning: String
    public let mythologicalSignificance: String
    
    private enum CodingKeys: String, CodingKey {
        case name, lineage, appearance, interpretation, meaning
        case mythologicalSignificance = "mythological_significance"
    }
}

/// Numerology information for card numbers
public struct Numerology: Codable, Hashable {
    public let name: String
    public let meanings: [String]
    public let appearances: [String]
    public let significance: [String]
}

/// Properties of a tarot suit
public struct SuitProperties: Codable, Hashable {
    public let element: Element
    public let generalMeaning: String
    public let keywords: [String]
    public let emoji: String
    
    private enum CodingKeys: String, CodingKey {
        case element, keywords, emoji
        case generalMeaning = "general_meaning"
    }
}

/// Card meanings for upright and reversed positions
public struct CardMeanings: Codable, Hashable {
    public let upright: [String]
    public let reversed: [String]
}

/// Visual description of a card
public struct VisualDescription: Codable, Hashable {
    public let background: String
    public let foreground: String
}

// MARK: - Card Protocols

/// Base protocol for all tarot cards
public protocol TarotCard {
    var id: String { get }
    var name: String { get }
    var keywords: [String] { get }
    var meanings: CardMeanings { get }
    var visualDescription: VisualDescription { get }
    var visualDescriptionAnalysis: [String] { get }
    var symbols: [String] { get }
    var significance: String { get }
    var arcana: Arcana { get }
    
    /// Get the card's text representation
    func textRepresentation(isReversed: Bool) -> String
}

/// Protocol for cards that can be rendered visually
public protocol VisuallyRepresentable {
    /// Generate a description for visual rendering
    func renderingDescription(isReversed: Bool) -> String
}

// MARK: - Major Arcana Card

/// Represents a Major Arcana tarot card
public struct MajorArcanaCard: TarotCard, VisuallyRepresentable, Codable, Hashable, Identifiable {
    public let id: String
    public let number: MajorArcanaNumber
    public let name: String
    public let keywords: [String]
    public let meanings: CardMeanings
    public let visualDescription: VisualDescription
    public let visualDescriptionAnalysis: [String]
    public let symbols: [String]
    public let significance: String
    public let emoji: String?
    public let backgroundColor: String?
    
    public var arcana: Arcana { .major }
    public var romanNumeral: String { number.romanNumeral }
    
    private enum CodingKeys: String, CodingKey {
        case number, name, keywords, meanings, symbols, significance, emoji
        case visualDescription = "visual_description"
        case visualDescriptionAnalysis = "visual_description_analysis"
        case backgroundColor = "background_color"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle number as either Int or MajorArcanaNumber
        if let numberInt = try? container.decode(Int.self, forKey: .number) {
            guard let majorNumber = MajorArcanaNumber(rawValue: numberInt) else {
                throw DecodingError.dataCorruptedError(forKey: .number, in: container, debugDescription: "Invalid major arcana number: \(numberInt)")
            }
            self.number = majorNumber
        } else {
            self.number = try container.decode(MajorArcanaNumber.self, forKey: .number)
        }
        
        self.name = try container.decode(String.self, forKey: .name)
        self.keywords = try container.decode([String].self, forKey: .keywords)
        self.meanings = try container.decode(CardMeanings.self, forKey: .meanings)
        self.visualDescription = try container.decode(VisualDescription.self, forKey: .visualDescription)
        self.visualDescriptionAnalysis = try container.decode([String].self, forKey: .visualDescriptionAnalysis)
        self.symbols = try container.decode([String].self, forKey: .symbols)
        self.significance = try container.decode(String.self, forKey: .significance)
        self.emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor)
        
        // Generate ID based on number
        self.id = "major-\(number.rawValue)"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(number.rawValue, forKey: .number)
        try container.encode(name, forKey: .name)
        try container.encode(keywords, forKey: .keywords)
        try container.encode(meanings, forKey: .meanings)
        try container.encode(visualDescription, forKey: .visualDescription)
        try container.encode(visualDescriptionAnalysis, forKey: .visualDescriptionAnalysis)
        try container.encode(symbols, forKey: .symbols)
        try container.encode(significance, forKey: .significance)
        try container.encodeIfPresent(emoji, forKey: .emoji)
        try container.encodeIfPresent(backgroundColor, forKey: .backgroundColor)
    }
    
    public func textRepresentation(isReversed: Bool = false) -> String {
        let reversedText = isReversed ? " (Reversed)" : ""
        return "\(romanNumeral) - \(name)\(reversedText)"
    }
    
    public func renderingDescription(isReversed: Bool = false) -> String {
        let meaningsList = isReversed ? meanings.reversed : meanings.upright
        let mainMeaning = meaningsList.first ?? "No meaning available"
        return "\(name)\(isReversed ? " (Reversed)" : ""): \(mainMeaning)"
    }
}

// MARK: - Minor Arcana Card

/// Represents a Minor Arcana tarot card
public struct MinorArcanaCard: TarotCard, VisuallyRepresentable, Codable, Hashable, Identifiable {
    public let id: String
    public let number: MinorNumber
    public let name: String
    public let suit: Suit
    public let element: Element
    public let keywords: [String]
    public let meanings: CardMeanings
    public let visualDescription: VisualDescription
    public let visualDescriptionAnalysis: [String]
    public let symbols: [String]
    public let significance: String
    public let emoji: String
    
    public var arcana: Arcana { .minor }
    public var fullName: String { "\(number.displayName) of \(suit.rawValue)" }
    
    private enum CodingKeys: String, CodingKey {
        case number, name, keywords, meanings, symbols, significance, emoji
        case visualDescription = "visual_description"
        case visualDescriptionAnalysis = "visual_description_analysis"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Parse name to extract number and suit
        self.name = try container.decode(String.self, forKey: .name)
        
        // Extract suit and number from name (e.g., "Ace of Cups")
        let components = name.components(separatedBy: " of ")
        guard components.count == 2 else {
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Invalid minor arcana name format: \(name)")
        }
        
        let numberString = components[0]
        let suitString = components[1]
        
        // Parse suit
        guard let parsedSuit = Suit(rawValue: suitString) else {
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Invalid suit: \(suitString)")
        }
        self.suit = parsedSuit
        
        // Parse number
        switch numberString.lowercased() {
        case "ace": self.number = .ace
        case "two": self.number = .two
        case "three": self.number = .three
        case "four": self.number = .four
        case "five": self.number = .five
        case "six": self.number = .six
        case "seven": self.number = .seven
        case "eight": self.number = .eight
        case "nine": self.number = .nine
        case "ten": self.number = .ten
        case "page": self.number = .page
        case "knight": self.number = .knight
        case "queen": self.number = .queen
        case "king": self.number = .king
        default:
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Invalid number: \(numberString)")
        }
        
        // Determine element based on suit
        switch suit {
        case .cups: self.element = .water
        case .pentacles: self.element = .earth
        case .swords: self.element = .air
        case .wands: self.element = .fire
        }
        
        self.keywords = try container.decode([String].self, forKey: .keywords)
        self.meanings = try container.decode(CardMeanings.self, forKey: .meanings)
        self.visualDescription = try container.decode(VisualDescription.self, forKey: .visualDescription)
        self.visualDescriptionAnalysis = try container.decode([String].self, forKey: .visualDescriptionAnalysis)
        self.symbols = try container.decode([String].self, forKey: .symbols)
        self.significance = try container.decode(String.self, forKey: .significance)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        
        // Generate ID
        self.id = "minor-\(suit.rawValue.lowercased())-\(number.rawValue)"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(keywords, forKey: .keywords)
        try container.encode(meanings, forKey: .meanings)
        try container.encode(visualDescription, forKey: .visualDescription)
        try container.encode(visualDescriptionAnalysis, forKey: .visualDescriptionAnalysis)
        try container.encode(symbols, forKey: .symbols)
        try container.encode(significance, forKey: .significance)
        try container.encode(emoji, forKey: .emoji)
    }
    
    public func textRepresentation(isReversed: Bool = false) -> String {
        let reversedText = isReversed ? " (Reversed)" : ""
        return "\(fullName)\(reversedText)"
    }
    
    public func renderingDescription(isReversed: Bool = false) -> String {
        let meaningsList = isReversed ? meanings.reversed : meanings.upright
        let mainMeaning = meaningsList.first ?? "No meaning available"
        return "\(fullName)\(isReversed ? " (Reversed)" : ""): \(mainMeaning)"
    }
}

// MARK: - Container for Minor Arcana Suit Data

/// Container structure for loading minor arcana suit data from YAML
public struct MinorArcanaSuitData: Codable {
    public let cards: [MinorArcanaCard]
}