//
//  ContentView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

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

    @State private var isShowingVersionAlert = false
    @State private var isCheckingAnswers = false
    @State private var isShowingFileEditView = false

    var body: some View {
        Group {
            TabView {
                TangoTestView(
                    tangoData: $tangoFile.tangoData,
                    testType: .jp,
                    isCheckingAnswers: $isCheckingAnswers
                )
                .tabItem {
                    Image(systemName: "j.circle.fill")
                    Text("日本語")
                }
                TangoTestView(
                    tangoData: $tangoFile.tangoData,
                    testType: .en,
                    isCheckingAnswers: $isCheckingAnswers
                )
                .tabItem {
                    Image(systemName: "e.circle.fill")
                    Text("英語")
                }
            }
        }
        #if os(macOS)
        .frame(minWidth: 320, minHeight: 280)
        #else
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
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
    var shuffleButton: some View {
        Button(action: {
            impactOccurred()
            tangoFile.tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
        }
    }

    var showAnswersButton: some View {
        Button(action: {
            impactOccurred()
            isCheckingAnswers.toggle()
        }) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
                .foregroundColor(.red)
        }
    }

    func impactOccurred() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }

    var fileEditButton: some View {
        Button(action: {
            isShowingFileEditView = true
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
        ContentView(tangoDocument: .constant(TangoTestKun2Document()))
    }
}
