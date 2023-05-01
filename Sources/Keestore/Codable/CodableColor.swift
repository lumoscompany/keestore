//
//  Created by Anton Spivak
//

#if canImport(UIKit)
import UIKit
public typealias Unicolor = UIColor
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias Unicolor = NSColor
#else
// TODO:
#endif

// MARK: - CodableColor

@propertyWrapper
public struct CodableColor {
    // MARK: Lifecycle

    public init(wrappedValue: Unicolor) {
        self.wrappedValue = wrappedValue
    }

    // MARK: Public

    public var wrappedValue: Unicolor
}

// MARK: Codable

extension CodableColor: Codable {
    enum CodingKeys: CodingKey {
        case `default`
        case dark
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let _default = try container.decode(String.self, forKey: .default)
        let _dark: String? = try container.decode(String.self, forKey: .dark)

        guard let defaultColor = Unicolor(hexRepresentation: _default)
        else {
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.default,
                in: container,
                debugDescription: "Invalid `default` color."
            )
        }

        var darkColor: Unicolor?
        if let _dark {
            guard let color = Unicolor(hexRepresentation: _dark)
            else {
                throw DecodingError.dataCorruptedError(
                    forKey: CodingKeys.default,
                    in: container,
                    debugDescription: "Invalid `dark` color."
                )
            }

            darkColor = color
        }

        self.wrappedValue = Unicolor(default: defaultColor, dark: darkColor)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(wrappedValue.default.hexRepresentation, forKey: .default)
        try container.encode(wrappedValue.dark.hexRepresentation, forKey: .dark)
    }
}

internal extension Unicolor {
    convenience init?(hexRepresentation: String) {
        var value = hexRepresentation
        if value.hasPrefix("#") {
            value = String(value.dropFirst())
        }

        let scanner = Scanner(string: value)
        guard let rgba = scanner.scanInt(representation: .hexadecimal)
        else {
            return nil
        }

        self.init(
            red: CGFloat(UInt8((rgba & 0xFF000000) >> 24)) / 255,
            green: CGFloat(UInt8((rgba & 0x00FF0000) >> 16)) / 255,
            blue: CGFloat(UInt8((rgba & 0x0000FF00) >> 8)) / 255,
            alpha: CGFloat(UInt8(rgba & 0x000000FF)) / 255
        )
    }

    var hexRepresentation: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let value =
            Int(UInt8(red * 255)) << 24 |
            Int(UInt8(green * 255)) << 16 |
            Int(UInt8(blue * 255)) << 8 |
            Int(UInt8(alpha * 255))

        return String(format: "#%08x", value)
    }
}

private extension Unicolor {
    var `default`: Unicolor {
        resolvedColor(using: .default)
    }

    var dark: Unicolor {
        resolvedColor(using: .dark)
    }

    convenience init(default _default: Unicolor, dark: Unicolor?) {
        self.init(provider: { unistyle in
            switch unistyle {
            case .dark:
                return dark ?? _default
            case .default:
                return _default
            }
        })
    }
}

#if canImport(UIKit)
private extension UIColor {
    convenience init(provider: @escaping (CodableAppearance) -> UIColor) {
        self.init(dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return provider(.dark)
            default:
                return provider(.default)
            }
        })
    }

    func resolvedColor(using appearance: CodableAppearance) -> UIColor {
        switch appearance {
        case .default:
            return resolvedColor(with: .init(userInterfaceStyle: .dark))
        case .dark:
            return resolvedColor(with: .init(userInterfaceStyle: .light))
        }
    }
}

#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
private extension NSColor {
    convenience init(provider: @escaping (CodableAppearance) -> NSColor) {
        self.init(name: nil, dynamicProvider: { appearance in
            switch appearance.name {
            case .darkAqua:
                return provider(.dark)
            default:
                return provider(.default)
            }
        })
    }

    func resolvedColor(using appearance: CodableAppearance) -> NSColor {
        let previous = NSAppearance.current
        let color: NSColor

        switch appearance {
        case .default:
            NSAppearance.current = NSAppearance(named: .darkAqua)
            color = NSColor(cgColor: cgColor)!
        case .dark:
            NSAppearance.current = NSAppearance(named: .aqua)
            color = NSColor(cgColor: cgColor)!
        }

        NSAppearance.current = previous
        return color
    }
}
#else
// TODO:
#endif

// MARK: - CodableColor + Sendable

extension CodableColor: Sendable {}

// MARK: - CodableColor + Hashable

extension CodableColor: Hashable {}

// MARK: - Unicolor + Sendable

extension Unicolor: @unchecked Sendable {}
