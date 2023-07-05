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
    @StateObject var appState = AppState()

    var body: some Scene {
        DocumentGroup(newDocument: TangoTestKun2Document() ) { file in
            ContentView(tangoDocument: file.$document,
                        tangoFile: tangoFile,
                        appState: appState
            )
            .frame(minWidth: 320, idealWidth: 380, minHeight: 280, idealHeight: 500)
        }
        .commands {
            CommandGroup(after: .toolbar) {
                Button("単語をシャッフル") {
                    tangoFile.tangoData.shuffle()
                }
                .keyboardShortcut("s", modifiers: [])
                Button("答えを表示") {
                    appState.isCheckingAnswers.toggle()
                }
                .keyboardShortcut("a", modifiers: [])
                Divider()
                Button("英語→日本語") {
                    appState.testType = .en
                }
                .keyboardShortcut("1", modifiers: .command)
                Button("日本語→英語") {
                    appState.testType = .jp
                }
                .keyboardShortcut("2", modifiers: .command)
                Divider()
            }
            CommandGroup(after: .pasteboard) {
                Divider()
                Button("単語ファイルを編集") {
                    appState.isShowingFileEditView = true
                }
                .keyboardShortcut("e", modifiers: .command)
            }
        }
    }
}
