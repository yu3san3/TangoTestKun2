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
    @State private var isShowingFileEditView = false

    var body: some View {
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
        .navigationTitle("単語テストくん")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingVersionAlert = true
                }) {
                    Label("情報", systemImage: "info.circle")
                }
                .alert("単語テストくん", isPresented: $isShowingVersionAlert) {
                    Button("OK") {}
                } message: {
                    Text("\(appVersion) (\(appBuildNum))")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingFileEditView = true
                }) {
                    Label("編集", systemImage: "doc.text")
                }
                .sheet(isPresented: $isShowingFileEditView) {
                    FileEditView(nowEditingFile: .constant(tangoFile)) { text in
                        tangoFile.text = text
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tangoFile: .constant(TangoTestKun2Document()))
    }
}
