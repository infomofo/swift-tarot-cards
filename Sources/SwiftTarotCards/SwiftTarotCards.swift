/// SwiftTarotCards - A Swift library for modeling tarot cards, decks, and spreads
/// 
/// This library provides a comprehensive Swift implementation for working with tarot cards,
/// based on the Rider-Waite-Smith tarot deck data. It includes:
/// 
/// - Complete Major and Minor Arcana card models
/// - Deck management with secure shuffling
/// - Spread systems for readings
/// - SwiftUI views for card rendering
/// - Extensible architecture for different deck types
///
/// Example usage:
/// ```swift
/// import SwiftTarotCards
/// 
/// // Create a deck
/// let deck = try TarotDeck()
/// deck.shuffle()
/// 
/// // Draw some cards
/// let cards = deck.drawCards(count: 3)
/// for card in cards {
///     print(card.textRepresentation(isReversed: false))
/// }
/// ```