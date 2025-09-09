#if canImport(SwiftUI)
import SwiftUI

// MARK: - Card Display Views

/// SwiftUI view for rendering a tarot card
@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
public struct TarotCardView: View {
    let card: any TarotCard
    let isReversed: Bool
    let showDetails: Bool
    
    public init(card: any TarotCard, isReversed: Bool = false, showDetails: Bool = true) {
        self.card = card
        self.isReversed = isReversed
        self.showDetails = showDetails
    }
    
    public var body: some View {
        cardContent
            .rotationEffect(.degrees(isReversed ? 180 : 0))
            .accessibilityLabel(card.textRepresentation(isReversed: isReversed))
    }
    
    @ViewBuilder
    private var cardContent: some View {
        if let majorCard = card as? MajorArcanaCard {
            MajorArcanaCardView(card: majorCard, showDetails: showDetails)
        } else if let minorCard = card as? MinorArcanaCard {
            MinorArcanaCardView(card: minorCard, showDetails: showDetails)
        } else {
            defaultCardView
        }
    }
    
    private var defaultCardView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                VStack {
                    Text(card.name)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    if showDetails {
                        Text(card.keywords.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            )
    }
}

/// SwiftUI view specifically for Major Arcana cards
@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
public struct MajorArcanaCardView: View {
    let card: MajorArcanaCard
    let showDetails: Bool
    
    public init(card: MajorArcanaCard, showDetails: Bool = true) {
        self.card = card
        self.showDetails = showDetails
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundGradient)
            .overlay(
                VStack(spacing: 8) {
                    // Roman numeral
                    Text(card.romanNumeral)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Emoji if available
                    if let emoji = card.emoji {
                        Text(emoji)
                            .font(.largeTitle)
                    }
                    
                    // Card name
                    Text(card.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    if showDetails {
                        Divider()
                        
                        // Keywords
                        Text(card.keywords.prefix(3).joined(separator: " • "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                .padding(12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
            )
    }
    
    private var backgroundGradient: LinearGradient {
        let baseColor: Color
        if let bgColor = card.backgroundColor {
            baseColor = Color(hexString: bgColor) ?? .blue
        } else {
            // Default gradient based on card number
            let hue = Double(card.number.rawValue) / 21.0
            baseColor = Color(hue: hue, saturation: 0.3, brightness: 0.9)
        }
        
        return LinearGradient(
            gradient: Gradient(colors: [
                baseColor.opacity(0.8),
                baseColor.opacity(0.4)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

/// SwiftUI view specifically for Minor Arcana cards
@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
public struct MinorArcanaCardView: View {
    let card: MinorArcanaCard
    let showDetails: Bool
    
    public init(card: MinorArcanaCard, showDetails: Bool = true) {
        self.card = card
        self.showDetails = showDetails
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundGradient)
            .overlay(
                VStack(spacing: 6) {
                    // Suit emoji and number
                    HStack {
                        Text(card.emoji)
                            .font(.title2)
                        
                        Text(card.number.displayName)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    // Suit name
                    Text("of \(card.suit.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if showDetails {
                        Divider()
                        
                        // Element
                        Text(card.element.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(elementColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(elementColor.opacity(0.2))
                            .clipShape(Capsule())
                        
                        // Keywords
                        Text(card.keywords.prefix(2).joined(separator: " • "))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
                .padding(10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
            )
    }
    
    private var backgroundGradient: LinearGradient {
        let suitColor = suitColor(for: card.suit)
        return LinearGradient(
            gradient: Gradient(colors: [
                suitColor.opacity(0.6),
                suitColor.opacity(0.3)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var elementColor: Color {
        switch card.element {
        case .fire: return .red
        case .water: return .blue
        case .earth: return .green
        case .air: return .yellow
        }
    }
    
    private func suitColor(for suit: Suit) -> Color {
        switch suit {
        case .cups:
            return .blue
        case .pentacles:
            return .green
        case .swords:
            return .gray
        case .wands:
            return .orange
        }
    }
}

// MARK: - Grid and Collection Views

/// Grid view for displaying multiple tarot cards
@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
public struct TarotCardGridView: View {
    let cards: [any TarotCard]
    let columns: Int
    let spacing: CGFloat
    let cardAspectRatio: CGFloat
    
    public init(
        cards: [any TarotCard],
        columns: Int = 3,
        spacing: CGFloat = 12,
        cardAspectRatio: CGFloat = 0.7
    ) {
        self.cards = cards
        self.columns = columns
        self.spacing = spacing
        self.cardAspectRatio = cardAspectRatio
    }
    
    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
            spacing: spacing
        ) {
            ForEach(cards.indices, id: \.self) { index in
                TarotCardView(card: cards[index])
                    .aspectRatio(cardAspectRatio, contentMode: .fit)
            }
        }
        .padding(spacing)
    }
}

// MARK: - Helper Extensions

@available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *)
extension Color {
    init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#endif
