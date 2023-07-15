//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Document

public struct Document {
    // MARK: Lifecycle

    public init(direcotryURL: URL, fileNamed fileName: String) {
        self.direcotryURL = direcotryURL
        self.fileName = fileName
    }

    // MARK: Public

    public let direcotryURL: URL
    public let fileName: String

    public var isExists: Bool {
        Foundation.FileManager.default.fileExists(atPath: fileURL.relativePath)
    }

    // MARK: Private

    private var fileURL: URL {
        let fileURL = direcotryURL.appendingPathComponent("\(fileName).keestore")
        guard fileURL.isFileURL
        else {
            fatalError("[Keestore]: Not file URL.")
        }
        return fileURL
    }
}

// MARK: - File + Operations

public extension Document {
    func read() async throws -> Keestore? {
        guard isExists
        else {
            return nil
        }

        return try await _perform({
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder.decode(Keestore.self, from: data)
        })
    }

    func write(_ keestore: Keestore) async throws {
        try await _perform({
            let data = try JSONEncoder.encode(keestore)
            try data.write(to: fileURL, options: [.atomic])
        })
    }

    func delete() async throws {
        guard isExists
        else {
            return
        }

        try await _perform({
            try FileManager.default.removeItem(at: fileURL)
        })
    }
}

private extension Document {
    private static let queue = DispatchQueue(label: "keestore.document")

    func _perform<T>(_ body: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation({ continueation in
            Document.queue.async(execute: {
                do {
                    let result = try body()
                    continueation.resume(returning: result)
                } catch {
                    continueation.resume(throwing: error)
                }
            })
        })
    }
}
