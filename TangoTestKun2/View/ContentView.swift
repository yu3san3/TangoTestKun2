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

    @Binding var tangoFile: TangoTestKun2Document

    @State private var isShowingVersionAlert = false
    @State private var isCheckingAnswers = false
    @State private var isImporting = false
    @State private var isShowingExistingFileEditView = false
    @State private var isShowingNewFileEditView = false

    var body: some View {
        VStack {
            header
            TabView {
                TangoTestView(
                    tangoData: .constant(TangoParser.parse(tangoFile.text)),
                    testType: .jp,
                    isCheckingAnswers: $isCheckingAnswers
                )
                .tabItem {
                    Image(systemName: "j.circle.fill")
                    Text("日本語")
                }
                TangoTestView(
                    tangoData: .constant(TangoParser.parse(tangoFile.text)),
                    testType: .en,
                    isCheckingAnswers: $isCheckingAnswers
                )
                .tabItem {
                    Image(systemName: "e.circle.fill")
                    Text("英語")
                }
            }
        }
    }
}

private extension ContentView {
    var header: some View {
        HStack {
            titleText
            Spacer()
            fileMenu
            .sheet(
                isPresented: $isShowingExistingFileEditView,
                content: {
//                    FileEditView(tangoFile: nowEditingFile, editMode: .existingFile)
                    Text("hello")
                }
            )
        }
        .padding(.horizontal, 10)
    }

    var titleText: some View {
        Text("単語テストくん")
            .bold()
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .onTapGesture {
                isShowingVersionAlert = true
            }
            .alert("単語テストくん", isPresented: $isShowingVersionAlert) {
                Button("OK") {}
            } message: {
                Text("\(appVersion) (\(appBuildNum))")
            }
    }

    var fileMenu: some View {
        Menu {
            importTangoFileButton
//            if !nowEditingFile.tangoData.isEmpty {
                editExistingFileButton
//            }
            createNewFileButton
        } label: {
            Label("フォルダ", systemImage: "folder")
                .labelStyle(.iconOnly)
                .padding(.vertical, 7)
                .padding(.horizontal, 14)
        }
    }

    var importTangoFileButton: some View {
        Button(action: {
            isImporting = true
        }) {
            Label("読み込み", systemImage: "arrow.down.doc")
        }
    }

    var editExistingFileButton: some View {
        Button(action: {
            isShowingExistingFileEditView = true
        }) {
            Label("編集", systemImage: "pencil")
        }
    }

    var createNewFileButton: some View {
        Button(action: {
            isShowingNewFileEditView = true
        }) {
            Label("新規作成", systemImage: "plus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tangoFile: .constant(TangoTestKun2Document()))
    }
}
