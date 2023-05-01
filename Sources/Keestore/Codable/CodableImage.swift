//
//  Created by Anton Spivak
//

#if canImport(UIKit)
import UIKit
public typealias Unimage = UIImage
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias Unimage = NSImage
#else
// TODO:
#endif

// MARK: - CodableImage

@propertyWrapper
public struct CodableImage {
    // MARK: Lifecycle

    public init(wrappedValue: Unimage) {
        self.wrappedValue = wrappedValue
    }

    // MARK: Public

    public var wrappedValue: Unimage
}

// MARK: Codable

extension CodableImage: Codable {
    enum CodingKeys: CodingKey {
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .data)

        guard let image = Unimage(data: data)
        else {
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.data,
                in: container,
                debugDescription: "Invalid `data` image."
            )
        }

        self.wrappedValue = image
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let data = wrappedValue.pngData()
        else {
            throw EncodingError.invalidValue(wrappedValue, .init(
                codingPath: [CodingKeys.data],
                debugDescription: "Can't convert image to PNG representation."
            ))
        }

        try container.encode(data, forKey: .data)
    }
}

// MARK: Sendable

extension CodableImage: Sendable {}

// MARK: Hashable

extension CodableImage: Hashable {}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
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

extension NSImage: @unchecked Sendable {}
#endif
