//
//  TangoTestKun2App.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import SwiftUI

@main
struct TangoTestKun2App: App {
    @StateObject var tangoFile = TangoFile()
    @State private var isCheckingAnswers = false
    @State private var isShowingFileEditView = false
    @State private var testType: TestType = .jp

    var body: some Scene {
        DocumentGroup(newDocument: TangoTestKun2Document() ) { file in
            ContentView(tangoDocument: file.$document,
                        tangoFile: tangoFile,
                        isCheckingAnswers: $isCheckingAnswers,
                        isShowingFileEditView: $isShowingFileEditView,
                        testType: $testType
            )
            .frame(minWidth: 320,idealWidth: 380, minHeight: 280, idealHeight: 500)
        }
        .commands {
            CommandGroup(after: .toolbar) {
                Button("単語をシャッフル") {
                    tangoFile.tangoData.shuffle()
                }
                .keyboardShortcut("s", modifiers: [])
                Button("答えを表示") {
                    isCheckingAnswers.toggle()
                }
                .keyboardShortcut("a", modifiers: [])
                Button("日本語→英語") {
                    testType = .jp
                }
                .keyboardShortcut("1", modifiers: .command)
                Button("英語→日本語") {
                    testType = .en
                }
                .keyboardShortcut("2", modifiers: .command)
            }
            CommandGroup(after: .pasteboard) {
                Button("単語ファイルを編集") {
                    isShowingFileEditView = true
                }
                .keyboardShortcut("e", modifiers: .command)
            }

        }
    }
}
