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
        let fileURL = direcotryURL.appendingPathComponent("\(fileName).wolstore")
        guard fileURL.isFileURL
        else {
            fatalError("[Wolstore]: Not file URL.")
        }
        return fileURL
    }

    public var isExists: Bool {
        Foundation.FileManager.default.fileExists(atPath: fileURL.relativePath)
    }
}

// MARK: - File + Operations

public extension File {
    func read() async throws -> Wolstore? {
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
                    version = try JSONDecoder.wolstore.decode(Version.self, from: encodedData)
                } catch {
                    continueation.resume(throwing: Wolstore.Error.decodingFailed(error))
                    return
                }

                let wolstore = Wolstore(version)
                continueation.resume(returning: wolstore)
            })
        })
    }

    func write(_ wolstore: Wolstore) async throws {
        let fileURL = fileURL
        let version = wolstore.version

        return try await withCheckedThrowingContinuation({ continueation in
            DispatchQueue.global(qos: .background).async(execute: {
                let encodedData: Data
                do {
                    encodedData = try JSONEncoder.wolstore.encode(version)
                } catch {
                    continueation.resume(throwing: Wolstore.Error.encodingFailed(error))
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
