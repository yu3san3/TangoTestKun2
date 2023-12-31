//
//  FileEditView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/03.
//

import SwiftUI

struct FileEditView: View {
    @Binding var rawText: String
    var onCompletion: (String) -> Void
    @State private var textEditorContent: String

    @State private var isShowingDismissAlert = false
    @FocusState private var isEditing: Bool

    @Environment(\.dismiss) var dismiss

    init(rawText: Binding<String>, onCompletion: @escaping (String) -> Void) {
        self._rawText = rawText
        self._textEditorContent = State(initialValue: rawText.wrappedValue)
        self.onCompletion = onCompletion
    }

    var body: some View {
        NavigationStack {
            textEditor
                .toolbar {
                    var placementLeading: ToolbarItemPlacement {
                        #if os(iOS)
                        .navigationBarLeading
                        #else
                        .automatic
                        #endif
                    }
                    var placementTrailing: ToolbarItemPlacement {
                        #if os(iOS)
                        .navigationBarTrailing
                        #else
                        .automatic
                        #endif
                    }
                    ToolbarItem(placement: placementLeading) {
                        cancelButton
                    }
                    ToolbarItem(placement: placementTrailing) {
                        saveButton
                    }
                }
                .navigationTitle("ファイルを編集")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .navigationBarBackButtonHidden()
        }
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 300)
        #endif
    }
}

private extension FileEditView {

    var textEditor: some View {
        ZStack {
            if textEditorContent.isEmpty { //placeholder
                TextEditor(text: .constant(TangoFile.placeholderText))
                    .disabled(true)
            }
            TextEditor(text: $textEditorContent)
                .focused($isEditing)
                .opacity(textEditorContent.isEmpty ? 0.7 : 1)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("完了") {
                            isEditing = false
                        }
                    }
                }
                .onAppear {
                    isEditing = true
                }
        }
        #if os(macOS)
        .padding(.top, 5)
        #endif
    }

    var cancelButton: some View {
        Button(action: {
            if !hasChanges() { //何も変更がなかった場合は素直にdismiss
                dismiss()
                return
            }
            isShowingDismissAlert = true
        }) {
            Text("キャンセル")
        }
        .alert("本当に戻りますか？", isPresented: $isShowingDismissAlert) {
            Button("はい", role: .destructive) { dismiss() }
            Button("いいえ", role: .cancel) {}
        } message: {
            Text("「はい」を押すと、今までの編集内容は保存されません。")
        }
    }

    func hasChanges() -> Bool {
        if textEditorContent != rawText {
            return true
        }
        return false
    }

    var saveButton: some View {
        Button(action: {
            onCompletion(textEditorContent)
            dismiss()
        }) {
            Text("保存")
        }
        .keyboardShortcut("s", modifiers: .command)
    }
}

struct DocEditView_Previews: PreviewProvider {
    static var previews: some View {
        FileEditView(rawText: .constant(TangoFile.mockRawText)) { _ in
            print("completion")
        }
    }
}
