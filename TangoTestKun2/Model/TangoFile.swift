//
//  TangoFile.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/03.
//

import Foundation

class TangoFile: ObservableObject {
    @Published var tangoData: [TangoDataElement] = []
    @Published var rawText: String {
        didSet {
            tangoData = TangoParser.parse(rawText)
        }
    }

    init() {
        self.rawText = ""
    }
}

extension TangoFile {
    static let placeholderText = """
    apple=りんご
    book=本
    cat=猫
    """

    static let mockTangoData = TangoParser.parse(mockRawText)
    static let mockRawText = """
    launch=起動する、開始する
    intent=意図
    eligible=適格である
    bundle=束
    float=浮く
    delegate=委任する、代表
    restriction=制限、制約
    register=登録する、記録
    alignment=整列、調整
    radius=半径
    """.trimmingCharacters(in: .whitespaces) //両端の空白を削除
}
