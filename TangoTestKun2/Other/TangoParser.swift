//
//  TangoParser.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import Foundation

class TangoParser {
    static func parse(_ text: String) -> [TangoDataElement] {
        var result: [TangoDataElement] = []
        for lineRow in text.components(separatedBy: .newlines) { //textを1行づつ処理
            let line: String = lineRow.trimmingCharacters(in: .whitespaces) //行の端にある空白を削除
            if line == "" {
                continue
            } else {
                var lineArray: [String] = line.components(separatedBy: "=")
                let jp: String = lineArray.removeFirst() //左側
                let en: String = lineArray.joined(separator: "=") //右側
                result.append(TangoDataElement(jp: jp, en: en))
            }
        }
        return result
    }
}
