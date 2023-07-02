//
//  TangoTestKun2Document.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct TangoTestKun2Document: FileDocument {
    var text: String

    init(text: String = "Hello, world!=こんにちは世界！") {
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

extension TangoTestKun2Document {
    static let mockTangoData = TangoParser.parse(mockRawText)
    static let mockRawText = """
    起動する、開始する=launch
    意図=intent
    適格である=eligible
    束=bundle
    浮く=float
    委任する、代表=delegate
    制限、制約=restriction
    登録する、記録=register
    整列、調整=alignment
    半径=radius
    """.trimmingCharacters(in: .whitespaces) //両端の空白を削除
}
