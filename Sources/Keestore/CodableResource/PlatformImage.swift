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

// MARK: - PlatformImage

public struct PlatformImage: RawRepresentable {
    // MARK: Lifecycle

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }

    // MARK: Public

    public var rawValue: RawValue
}

public extension PlatformImage {
    #if canImport(UIKit)
    typealias RawValue = UIImage
    #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
    typealias RawValue = NSImage
    #else
    // TODO:
    #endif
}

// MARK: Codable

extension PlatformImage: Codable {
    enum CodingKeys: CodingKey {
        case rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .rawValue)

        guard let rawValue = RawValue(data: data)
        else {
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.rawValue,
                in: container,
                debugDescription: "Invalid image `rawValue`"
            )
        }

        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = rawValue.pngData()
        else {
            throw EncodingError.invalidValue((), .init(
                codingPath: [CodingKeys.rawValue],
                debugDescription: "Can't convert image to PNG representation."
            ))
        }

        try container.encode(data, forKey: .rawValue)
    }
}

// MARK: Sendable

extension PlatformImage: Sendable {}

// MARK: Hashable

extension PlatformImage: Hashable {}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension NSImage: @unchecked Sendable {}

private extension NSImage {
    func pngData() -> Data? {
        let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bitmapFormat: [],
            bytesPerRow: 0,
            bitsPerPixel: 0
        )

        guard let bitmap
        else {
            return nil
        }

        bitmap.size = size

        NSGraphicsContext.saveGraphicsState()

        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        NSGraphicsContext.current?.imageInterpolation = .high

        draw(
            in: NSRect(origin: .zero, size: size),
            from: .zero,
            operation: .copy,
            fraction: 1.0
        )

        NSGraphicsContext.restoreGraphicsState()

        return bitmap.representation(using: .png, properties: [:])
    }
}
#endif
