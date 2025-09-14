# SwiftTarotCards

A comprehensive Swift library for modeling tarot cards, decks, spreads, and readings. Built on the [Rider-Waite-Smith tarot deck](https://en.wikipedia.org/wiki/Rider%E2%80%93Waite%E2%80%93Smith_tarot) data from the [tarot-model](https://github.com/infomofo/tarot-model) repository.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%2B%20|%20macOS%2012%2B%20|%20watchOS%208%2B%20|%20tvOS%2015%2B%20|%20Linux-lightgrey.svg)](https://swift.org)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Features

- **Complete Tarot Deck**: All 78 cards of the Rider-Waite-Smith tarot deck
- **Type-Safe Design**: Swift enums and structs for cards, suits, elements, and arcana
- **Secure Shuffling**: Cryptographically secure random shuffling using `SystemRandomNumberGenerator`
- **Flexible Spreads**: Built-in spreads (single card, three-card, Celtic Cross) with extensible architecture
- **SwiftUI Integration**: Native SwiftUI views for card rendering on supported platforms
- **Cross-Platform**: Supports iOS, macOS, watchOS, tvOS, and Linux
- **YAML Data Loading**: Comprehensive card data loaded from structured YAML files
- **Comprehensive Testing**: Full test coverage with continuous integration

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/infomofo/swift-tarot-cards.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/infomofo/swift-tarot-cards.git`

## Quick Start

```swift
import SwiftTarotCards

// Create a deck and shuffle it
let deck = try TarotDeck()
deck.shuffle()

// Draw a single card
let cards = deck.drawCards(count: 1)
let card = cards.first!
print(card.textRepresentation(isReversed: false))

// Generate a three-card reading
let generator = TarotReadingGenerator(deck: deck)
let reading = generator.generateReading(
    spread: CommonSpreads.threeCard,
    userContext: "What should I focus on today?"
)

print(reading.basicInterpretation())
```

## Core Components

### Cards and Deck

```swift
// Access specific cards
let fool = deck.getMajorArcana(.fool)
let aceOfCups = deck.getMinorArcana(suit: .cups, number: .ace)

// Get all cards of a suit
let allCups = deck.getCards(suit: .cups)

// Different shuffling strategies
let secureShuffled = SecureShuffleStrategy() // Cryptographically secure (default)
let simpleShuffled = SimpleShuffleStrategy() // Basic random shuffle

// Card selection strategies
let topCards = deck.drawCards(count: 3, strategy: TopCardSelectionStrategy())
let randomCards = deck.drawCards(count: 3, strategy: RandomCardSelectionStrategy())
```

### Card Information

```swift
// Major Arcana
let card = deck.getMajorArcana(.magician)!
print(card.name)                    // "The Magician"
print(card.romanNumeral)            // "I"
print(card.keywords)                // ["manifestation", "resourcefulness", ...]
print(card.meanings.upright)        // Array of upright meanings
print(card.meanings.reversed)       // Array of reversed meanings

// Minor Arcana
let minorCard = deck.getMinorArcana(suit: .cups, number: .ace)!
print(minorCard.fullName)           // "Ace of Cups"
print(minorCard.suit)               // .cups
print(minorCard.element)            // .water
print(minorCard.emoji)              // "🏆" (suit symbol)
```

### Spreads and Readings

```swift
// Built-in spreads
let singleCard = CommonSpreads.singleCard
let threeCard = CommonSpreads.threeCard
let celticCross = CommonSpreads.celticCross

// Generate readings
let generator = TarotReadingGenerator(deck: deck, reversalProbability: 0.3)
let reading = generator.generateReading(spread: threeCard)

// Access drawn cards
for drawnCard in reading.drawnCards {
    print("\(drawnCard.position.name): \(drawnCard.card.name)")
    if drawnCard.isReversed {
        print("(Reversed)")
    }
}

// Get interpretation
print(reading.basicInterpretation())
```

### Custom Spreads

```swift
let customSpread = TarotSpread(
    name: "Decision Spread",
    description: "A spread for making decisions",
    positions: [
        SpreadPosition(position: 1, name: "Current Situation", 
                      positionSignificance: "Your current state", dealOrder: 1),
        SpreadPosition(position: 2, name: "Option A", 
                      positionSignificance: "First choice outcome", dealOrder: 2),
        SpreadPosition(position: 3, name: "Option B", 
                      positionSignificance: "Second choice outcome", dealOrder: 3)
    ],
    layout: [
        SpreadLayoutPosition(position: 1, x: 0.5, y: 0.2),
        SpreadLayoutPosition(position: 2, x: 0.2, y: 0.8),
        SpreadLayoutPosition(position: 3, x: 0.8, y: 0.8)
    ]
)
```

## SwiftUI Integration

```swift
import SwiftUI
import SwiftTarotCards

struct CardView: View {
    let card: any TarotCard
    
    var body: some View {
        TarotCardView(card: card, isReversed: false, showDetails: true)
            .frame(width: 200, height: 280)
    }
}

struct DeckGridView: View {
    let deck: TarotDeck
    
    var body: some View {
        TarotCardGridView(
            cards: deck.getMajorArcanaCards(),
            columns: 3,
            spacing: 12
        )
    }
}
```

## Data Model

The library uses the [tarot-model](https://github.com/infomofo/tarot-model) repository as a git submodule, providing:

- **Major Arcana**: 22 cards (0-21) with individual YAML files
- **Minor Arcana**: 56 cards organized by suit in YAML files
- **Suit Properties**: Element associations, meanings, and symbols
- **Tags and Symbols**: Comprehensive symbolism database
- **Spreads**: Traditional and modern spread layouts
- **Numerology**: Number meanings and associations

### Card Structure

Each card includes:
- Name and identification
- Keywords for quick reference
- Upright and reversed meanings
- Visual description and analysis
- Symbolic elements
- Historical significance

## Architecture

### Protocols and Extensions

- `TarotCard`: Base protocol for all cards
- `VisuallyRepresentable`: Cards that can be rendered visually
- `ShuffleStrategy`: Customizable shuffling algorithms
- `CardSelectionStrategy`: Different card selection methods

### Type Safety

The library uses Swift's type system for safety:
- `Arcana` enum for Major/Minor classification
- `Suit` enum for the four tarot suits
- `Element` enum for elemental associations
- `MajorArcanaNumber` and `MinorNumber` enums for card numbers

### Cross-Platform Compatibility

- **iOS/macOS/watchOS/tvOS**: Full SwiftUI support with visual rendering
- **Linux**: Core functionality with text-based representations
- **CI/CD**: Headless operation for automated testing and image generation

## Testing

The library includes comprehensive tests covering:

```bash
# Run all tests
swift test

# Run with coverage
swift test --enable-code-coverage

# Platform-specific testing
swift test --platform macos
```

Test categories:
- Core type functionality
- Card data loading and validation
- Deck shuffling and card selection
- Spread system and reading generation
- SwiftUI view rendering (where available)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass (`swift test`)
6. Run the linter (`swiftlint`)
7. Commit your changes (`git commit -m 'Add amazing feature'`)
8. Push to the branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

### Development Setup

```bash
# Clone with submodules
git clone --recursive https://github.com/infomofo/swift-tarot-cards.git
cd swift-tarot-cards

# Build the project
swift build

# Run tests
swift test

# Install SwiftLint (macOS)
brew install swiftlint
swiftlint
```

## Continuous Integration

The project includes three GitHub Actions workflows:

1. **Linting** (`.github/workflows/lint.yml`)
   - SwiftLint code quality checks
   - Swift formatting validation
   - Style consistency enforcement

2. **Testing** (`.github/workflows/test.yml`)
   - Multi-platform testing (macOS, Linux, iOS Simulator)
   - Code coverage reporting
   - Comprehensive test execution

3. **Image Generation** (`.github/workflows/generate-images.yml`)
   - Automated card representation generation
   - Sample reading creation
   - CI-friendly text-based outputs
   - Artifact upload for easy viewing

## Acknowledgments

- **Tarot Model**: Built on the comprehensive [tarot-model](https://github.com/infomofo/tarot-model) repository
- **TypeScript Reference**: Inspired by [ts-tarot-cards](https://github.com/infomofo/ts-tarot-cards) implementation
- **Rider-Waite-Smith Deck**: Traditional meanings and symbolism
- **Swift Community**: For excellent libraries and tooling

## License

This project is licensed under the ISC License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

⚠️ **This library is for educational, entertainment, and software development purposes only.**

- Tarot card interpretations are traditional meanings and should not be considered professional advice
- This software is not intended to provide medical, psychological, financial, or legal guidance
- Random number generation cannot predict future events
- Use responsibly and with understanding that tarot is a tool for reflection and entertainment

## Related Projects

- [tarot-model](https://github.com/infomofo/tarot-model) - YAML data source for tarot card information
- [ts-tarot-cards](https://github.com/infomofo/ts-tarot-cards) - TypeScript implementation of this library
