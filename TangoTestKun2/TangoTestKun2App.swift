//
//  TangoTestKun2App.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import SwiftUI

@main
struct TangoTestKun2App: App {
    var body: some Scene {
        DocumentGroup(newDocument: TangoTestKun2Document()) { file in
            ContentView(tangoDocument: file.$document)
        }
    }
}
