//
//  TangoTestKun2Document.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import SwiftUI
import UniformTypeIdentifiers

struct TangoTestKun2Document: FileDocument {
    var text: String

    init(text: String = TangoFile.newFileRawText) {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.plainText] }

    //読み込み
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }

    //書き込み
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
