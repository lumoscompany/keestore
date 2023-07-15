//
//  Created by Anton Spivak
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#else
// TODO:
#endif

// MARK: - PlatformColor

public struct PlatformColor: RawRepresentable {
    // MARK: Lifecycle

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    // MARK: Public

    public var rawValue: RawValue
}

public extension PlatformColor {
    #if canImport(UIKit)
    typealias RawValue = UIColor
    #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
    typealias RawValue = NSColor
    #else
    // TODO:
    #endif
}

// MARK: - PlatformColor.RawValue + Sendable

extension PlatformColor.RawValue: @unchecked Sendable {}

// MARK: - PlatformColor + Codable

extension PlatformColor: Codable {
    enum CodingKeys: CodingKey {
        case `default`
        case dark
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let _default = try container.decode(String.self, forKey: .default)
        let _dark: String? = try container.decode(String.self, forKey: .dark)

        guard let defaultColor = RawValue(hexRepresentation: _default)
        else {
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.default,
                in: container,
                debugDescription: "Invalid `default` color."
            )
        }

        var darkColor: RawValue?
        if let _dark {
            guard let color = RawValue(hexRepresentation: _dark)
            else {
                throw DecodingError.dataCorruptedError(
                    forKey: CodingKeys.default,
                    in: container,
                    debugDescription: "Invalid `dark` color."
                )
            }

            darkColor = color
        }

        self.init(rawValue: RawValue(default: defaultColor, dark: darkColor))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(rawValue.default.hexRepresentation, forKey: .default)
        try container.encode(rawValue.dark.hexRepresentation, forKey: .dark)
    }
}

// MARK: - PlatformColor + Sendable

extension PlatformColor: Sendable {}

// MARK: - PlatformColor + Hashable

extension PlatformColor: Hashable {}

internal extension PlatformColor.RawValue {
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

private extension PlatformColor.RawValue {
    var `default`: PlatformColor.RawValue {
        resolvedColor(using: .default)
    }

    var dark: PlatformColor.RawValue {
        resolvedColor(using: .dark)
    }

    convenience init(default _default: PlatformColor.RawValue, dark: PlatformColor.RawValue?) {
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
    convenience init(provider: @escaping (PlatformAppearance) -> UIColor) {
        self.init(dynamicProvider: { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return provider(.dark)
            default:
                return provider(.default)
            }
        })
    }

    func resolvedColor(using appearance: PlatformAppearance) -> UIColor {
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
    convenience init(provider: @escaping (PlatformAppearance) -> NSColor) {
        self.init(name: nil, dynamicProvider: { appearance in
            switch appearance.name {
            case .darkAqua:
                return provider(.dark)
            default:
                return provider(.default)
            }
        })
    }

    func resolvedColor(using appearance: PlatformAppearance) -> NSColor {
        let _appearance: NSAppearance?
        switch appearance {
        case .default:
            _appearance = NSAppearance(named: .darkAqua)
        case .dark:
            _appearance = NSAppearance(named: .aqua)
        }

        var color = self
        _appearance?.performAsCurrentDrawingAppearance({
            guard let _color = NSColor(cgColor: cgColor)
            else {
                return
            }

            color = _color
        })

        return color
    }
}
#else
// TODO:
#endif
