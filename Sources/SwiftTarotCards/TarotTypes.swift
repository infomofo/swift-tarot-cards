import Foundation

// MARK: - Core Enums

/// Represents the two main categories of tarot cards
public enum Arcana: String, CaseIterable, Codable {
    case major = "Major"
    case minor = "Minor"
}

/// The four suits in a tarot deck
public enum Suit: String, CaseIterable, Codable {
    case cups = "Cups"
    case pentacles = "Pentacles" 
    case swords = "Swords"
    case wands = "Wands"
}

/// The four classical elements associated with suits
public enum Element: String, CaseIterable, Codable {
    case water = "Water"
    case earth = "Earth"
    case air = "Air"
    case fire = "Fire"
}

/// Numbers for minor arcana cards
public enum MinorNumber: Int, CaseIterable, Codable {
    case ace = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case page = 11
    case knight = 12
    case queen = 13
    case king = 14
    
    /// Get the display name for this number
    public var displayName: String {
        switch self {
        case .ace: return "Ace"
        case .two: return "Two"
        case .three: return "Three"
        case .four: return "Four"
        case .five: return "Five"
        case .six: return "Six"
        case .seven: return "Seven"
        case .eight: return "Eight"
        case .nine: return "Nine"
        case .ten: return "Ten"
        case .page: return "Page"
        case .knight: return "Knight"
        case .queen: return "Queen"
        case .king: return "King"
        }
    }
}

/// Numbers for major arcana cards (0-21)
public enum MajorArcanaNumber: Int, CaseIterable, Codable {
    case fool = 0
    case magician = 1
    case highPriestess = 2
    case empress = 3
    case emperor = 4
    case hierophant = 5
    case lovers = 6
    case chariot = 7
    case strength = 8
    case hermit = 9
    case wheelOfFortune = 10
    case justice = 11
    case hangedMan = 12
    case death = 13
    case temperance = 14
    case devil = 15
    case tower = 16
    case star = 17
    case moon = 18
    case sun = 19
    case judgement = 20
    case world = 21
    
    /// Get the display name for this major arcana card
    public var displayName: String {
        switch self {
        case .fool: return "The Fool"
        case .magician: return "The Magician"
        case .highPriestess: return "The High Priestess"
        case .empress: return "The Empress"
        case .emperor: return "The Emperor"
        case .hierophant: return "The Hierophant"
        case .lovers: return "The Lovers"
        case .chariot: return "The Chariot"
        case .strength: return "Strength"
        case .hermit: return "The Hermit"
        case .wheelOfFortune: return "Wheel of Fortune"
        case .justice: return "Justice"
        case .hangedMan: return "The Hanged Man"
        case .death: return "Death"
        case .temperance: return "Temperance"
        case .devil: return "The Devil"
        case .tower: return "The Tower"
        case .star: return "The Star"
        case .moon: return "The Moon"
        case .sun: return "The Sun"
        case .judgement: return "Judgement"
        case .world: return "The World"
        }
    }
    
    /// Get the roman numeral representation (special case for The Fool)
    public var romanNumeral: String {
        if self == .fool {
            return "0"
        }
        return toRomanNumeral(rawValue)
    }
}

// MARK: - Helper Functions

/// Convert numeric value to roman numeral
public func toRomanNumeral(_ num: Int) -> String {
    if num == 0 {
        return "0"
    }
    
    let values = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
    ]
    
    var result = ""
    var remaining = num
    
    for (value, numeral) in values {
        while remaining >= value {
            result += numeral
            remaining -= value
        }
    }
    
    return result
}