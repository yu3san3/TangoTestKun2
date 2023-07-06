//
//  ContentView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//
// 2023/07/04 Alpha 1.0.0
// 2023/07/05 Alpha 1.0.1
// 2023/07/06 1.0.0

import SwiftUI

let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let appBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {
    @Binding var tangoDocument: TangoTestKun2Document {
        didSet {
            tangoFile.rawText = tangoDocument.text
        }
    }
    @ObservedObject var tangoFile: TangoFile
    @ObservedObject var appState: AppState

    @State private var isShowingVersionAlert = false

    var body: some View {
        TabView(selection: $appState.testType) {
            TangoTestView(
                tangoData: $tangoFile.tangoData,
                testType: .en,
                isCheckingAnswers: $appState.isCheckingAnswers
            )
            .tabItem {
                Image(systemName: "e.circle.fill")
                Text("英語")
            }
            .tag(TestType.en)
            TangoTestView(
                tangoData: $tangoFile.tangoData,
                testType: .jp,
                isCheckingAnswers: $appState.isCheckingAnswers
            )
            .tabItem {
                Image(systemName: "j.circle.fill")
                Text("日本語")
            }
            .tag(TestType.jp)
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
                    .sheet(isPresented: $appState.isShowingFileEditView) {
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
                .sheet(isPresented: $appState.isShowingFileEditView) {
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
    var shuffleButton: some View {
        Button(action: {
            #if os(iOS)
            impactOccurred(style: .rigid)
            #endif
            tangoFile.tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
        }
    }

    var showAnswersButton: some View {
        Button(action: {
            #if os(iOS)
            impactOccurred(style: .light)
            #endif
            appState.isCheckingAnswers.toggle()
        }) {
            Image(systemName: appState.isCheckingAnswers ? "pencil" : "pencil.slash")
                .foregroundColor(.red)
        }
    }

    #if os(iOS)
    func impactOccurred(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }
    #endif

    var fileEditButton: some View {
        Button(action: {
            appState.isShowingFileEditView = true
        }) {
            Label("編集", systemImage: "doc.text")
        }
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
        ContentView(
            tangoDocument: .constant( TangoTestKun2Document() ),
            tangoFile: TangoFile(),
            appState: AppState()
        )
    }
}
