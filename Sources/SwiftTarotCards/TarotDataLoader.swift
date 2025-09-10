import Foundation
import Yams

/// Manages loading of tarot card data from YAML files
public class TarotDataLoader {
    
    private static let sharedInstance = TarotDataLoader()
    
    /// Get the shared instance
    public static func shared() -> TarotDataLoader {
        return sharedInstance
    }
    
    private init() {}
    
    /// Load a major arcana card from its YAML file
    public func loadMajorArcanaCard(number: MajorArcanaNumber) throws -> MajorArcanaCard {
        let filename = String(format: "%02d-%@.yml", number.rawValue, number.displayName.lowercased().replacingOccurrences(of: " ", with: "-"))
        let path = "tarot-model/decks/rider-waite-smith/major-arcana/\(filename)"
        
        guard let url = Bundle.module.url(forResource: path, withExtension: nil) else {
            throw TarotDataError.fileNotFound(path)
        }
        
        let data = try Data(contentsOf: url)
        let yamlString = String(data: data, encoding: .utf8) ?? ""
        
        let decoder = YAMLDecoder()
        return try decoder.decode(MajorArcanaCard.self, from: yamlString)
    }
    
    /// Load all major arcana cards
    public func loadAllMajorArcanaCards() throws -> [MajorArcanaCard] {
        var cards: [MajorArcanaCard] = []
        
        for number in MajorArcanaNumber.allCases {
            let card = try loadMajorArcanaCard(number: number)
            cards.append(card)
        }
        
        return cards.sorted { $0.number.rawValue < $1.number.rawValue }
    }
    
    /// Load all minor arcana cards for a specific suit
    public func loadMinorArcanaCards(suit: Suit) throws -> [MinorArcanaCard] {
        let filename = "\(suit.rawValue.lowercased()).yml"
        let path = "tarot-model/decks/rider-waite-smith/minor-arcana/\(filename)"
        
        guard let url = Bundle.module.url(forResource: path, withExtension: nil) else {
            throw TarotDataError.fileNotFound(path)
        }
        
        let data = try Data(contentsOf: url)
        let yamlString = String(data: data, encoding: .utf8) ?? ""
        
        let decoder = YAMLDecoder()
        let suitData = try decoder.decode(MinorArcanaSuitData.self, from: yamlString)
        
        return suitData.cards.sorted { $0.number.rawValue < $1.number.rawValue }
    }
    
    /// Load all minor arcana cards
    public func loadAllMinorArcanaCards() throws -> [MinorArcanaCard] {
        var cards: [MinorArcanaCard] = []
        
        for suit in Suit.allCases {
            let suitCards = try loadMinorArcanaCards(suit: suit)
            cards.append(contentsOf: suitCards)
        }
        
        return cards
    }
    
    /// Load suit properties
    public func loadSuitProperties(suit: Suit) throws -> SuitProperties {
        let filename = "\(suit.rawValue.lowercased()).yml"
        let path = "tarot-model/suits/\(filename)"
        
        guard let url = Bundle.module.url(forResource: path, withExtension: nil) else {
            throw TarotDataError.fileNotFound(path)
        }
        
        let data = try Data(contentsOf: url)
        let yamlString = String(data: data, encoding: .utf8) ?? ""
        
        let decoder = YAMLDecoder()
        return try decoder.decode(SuitProperties.self, from: yamlString)
    }
    
    /// Load all tags
    public func loadTags() throws -> [String: Tag] {
        let path = "tarot-model/tags.yml"
        
        guard let url = Bundle.module.url(forResource: path, withExtension: nil) else {
            throw TarotDataError.fileNotFound(path)
        }
        
        let data = try Data(contentsOf: url)
        let yamlString = String(data: data, encoding: .utf8) ?? ""
        
        let decoder = YAMLDecoder()
        return try decoder.decode([String: Tag].self, from: yamlString)
    }
    
    /// Load numerology data
    public func loadNumerology() throws -> [String: Numerology] {
        let path = "tarot-model/numerology.yml"
        
        guard let url = Bundle.module.url(forResource: path, withExtension: nil) else {
            throw TarotDataError.fileNotFound(path)
        }
        
        let data = try Data(contentsOf: url)
        let yamlString = String(data: data, encoding: .utf8) ?? ""
        
        let decoder = YAMLDecoder()
        return try decoder.decode([String: Numerology].self, from: yamlString)
    }
}

/// Errors that can occur when loading tarot data
public enum TarotDataError: Error, LocalizedError {
    case fileNotFound(String)
    case invalidData(String)
    case decodingError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "Tarot data file not found: \(path)"
        case .invalidData(let description):
            return "Invalid tarot data: \(description)"
        case .decodingError(let error):
            return "Error decoding tarot data: \(error.localizedDescription)"
        }
    }
}