//
//  ContentView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//
// 2023/07/04 Alpha 1.0.0

import SwiftUI

let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let appBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {
    @StateObject var tangoFile = TangoFile()
    @Binding var tangoDocument: TangoTestKun2Document {
        didSet {
            tangoFile.rawText = tangoDocument.text
        }
    }

    @State private var testType: TestType = .jp
    @State private var isShowingVersionAlert = false
    @State private var isCheckingAnswers = false
    @State private var isShowingFileEditView = false

    var body: some View {
        ZStack {
            TabView(selection: $testType) {
                TangoTestView(
                    tangoData: $tangoFile.tangoData,
                    testType: .jp,
                    isCheckingAnswers: $isCheckingAnswers
                )
                .tabItem {
                    Image(systemName: "j.circle.fill")
                    Text("日本語")
                }
                .tag(TestType.jp)
                TangoTestView(
                    tangoData: $tangoFile.tangoData,
                    testType: .en,
                    isCheckingAnswers: $isCheckingAnswers
                )
                .tabItem {
                    Image(systemName: "e.circle.fill")
                    Text("英語")
                }
                .tag(TestType.en)
            }
            setKeyboardShortcut(shortcut: KeyboardShortcut("1", modifiers: .command)) {
                testType = .jp
            }
            setKeyboardShortcut(shortcut: KeyboardShortcut("2", modifiers: .command)) {
                testType = .en
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            //初期状態を設定
            tangoFile.rawText = tangoDocument.text
        }
        .toolbar {
            #if os(macOS)
            ToolbarItem(placement: .navigation) {
                fileEditButton
                    .sheet(isPresented: $isShowingFileEditView) {
                        FileEditView(rawText: $tangoFile.rawText) { text in
                            tangoDocument.text = text
                        }
                    }
            }
            ToolbarItemGroup(placement: .automatic) {
                shuffleButton
                showAnswersButton
            }
            #else
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                shuffleButton
                showAnswersButton
                Menu {
                    fileEditButton
                    infoButton
                } label: {
                    Label("その他", systemImage: "ellipsis.circle")
                }
                .sheet(isPresented: $isShowingFileEditView) {
                    FileEditView(rawText: $tangoFile.rawText) { text in
                        tangoDocument.text = text
                    }
                }
                .alert("単語テストくん", isPresented: $isShowingVersionAlert) {
                    Button("OK") {}
                } message: {
                    Text("\(appVersion) (\(appBuildNum))")
                }
            }
            #endif
        }
    }
}

private extension ContentView {
    func setKeyboardShortcut(shortcut: KeyboardShortcut, action: @escaping () -> Void ) -> some View {
        Button(action: {
            action()
        }) {}
            .padding(0)
            .opacity(0)
            .frame(width: 0, height: 0)
            .keyboardShortcut(shortcut)
    }

    var shuffleButton: some View {
        Button(action: {
            #if os(iOS)
            impactOccurred(style: .rigid)
            #endif
            tangoFile.tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
        }
        .keyboardShortcut("s", modifiers: [])
    }

    var showAnswersButton: some View {
        Button(action: {
            #if os(iOS)
            impactOccurred(style: .light)
            #endif
            isCheckingAnswers.toggle()
        }) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
                .foregroundColor(.red)
        }
        .keyboardShortcut("a", modifiers: [])
    }

    #if os(iOS)
    func impactOccurred(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    #endif

    var fileEditButton: some View {
        Button(action: {
            isShowingFileEditView = true
        }) {
            Label("編集", systemImage: "doc.text")
        }
        .keyboardShortcut("e", modifiers: .command)
    }

    var infoButton: some View {
        Button(action: {
            isShowingVersionAlert = true
        }) {
            Label("情報", systemImage: "info.circle")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tangoDocument: .constant(TangoTestKun2Document()))
    }
}
