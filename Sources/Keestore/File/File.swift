//
//  Created by Anton Spivak
//

import Foundation

// MARK: - File

public struct File {
    // MARK: Lifecycle

    public init(direcotryURL: URL, fileNamed fileName: String) {
        self.direcotryURL = direcotryURL
        self.fileName = fileName
    }

    // MARK: Public

    public let direcotryURL: URL
    public let fileName: String

    public var fileURL: URL {
        let fileURL = direcotryURL.appendingPathComponent("\(fileName).keestore")
        guard fileURL.isFileURL
        else {
            fatalError("[Keestore]: Not file URL.")
        }
        return fileURL
    }

    public var isExists: Bool {
        Foundation.FileManager.default.fileExists(atPath: fileURL.relativePath)
    }
}

// MARK: - File + Operations

public extension File {
    func read() async throws -> Keestore? {
        guard isExists
        else {
            return nil
        }

        let fileURL = fileURL
        return try await withCheckedThrowingContinuation({ continueation in
            DispatchQueue.global(qos: .background).async(execute: {
                let encodedData: Data
                do {
                    encodedData = try Data(contentsOf: fileURL)
                } catch {
                    continueation.resume(throwing: URLError(.cannotOpenFile))
                    return
                }

                let version: Version
                do {
                    version = try JSONDecoder.keestore.decode(Version.self, from: encodedData)
                } catch {
                    continueation.resume(throwing: Keestore.Error.decodingFailed(error))
                    return
                }

                let keestore = Keestore(version)
                continueation.resume(returning: keestore)
            })
        })
    }

    func write(_ keestore: Keestore) async throws {
        let fileURL = fileURL
        let version = keestore.version

        return try await withCheckedThrowingContinuation({ continueation in
            DispatchQueue.global(qos: .background).async(execute: {
                let encodedData: Data
                do {
                    encodedData = try JSONEncoder.keestore.encode(version)
                } catch {
                    continueation.resume(throwing: Keestore.Error.encodingFailed(error))
                    return
                }

                do {
                    try encodedData.write(to: fileURL, options: [.atomic])
                } catch {
                    continueation.resume(throwing: URLError(.cannotWriteToFile))
                    return
                }

                continueation.resume(returning: ())
            })
        })
    }

    func delete() async throws {
        guard isExists
        else {
            return
        }

        let fileURL = fileURL
        return try await withCheckedThrowingContinuation({ continueation in
            DispatchQueue.global(qos: .background).async(execute: {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    continueation.resume(returning: ())
                } catch {
                    continueation.resume(throwing: error)
                }
            })
        })
    }
}
