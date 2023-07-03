//
//  FileEditView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/03.
//

import SwiftUI

struct FileEditView: View {
    @Binding var rawText: String
    @State private var textEditorContent: String
    var onCompletion: (String) -> Void

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
                    ToolbarItem(placement: .navigationBarLeading) {
                        cancelButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton
                    }
                }
                .navigationTitle("ファイルを編集")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
        }
    }
}

private extension FileEditView {

    var textEditor: some View {
        TextEditor(text: $textEditorContent)
            .focused($isEditing)
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

    var cancelButton: some View {
        Button(action: {
            if !hasChanges() {
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
    }
}

struct DocEditView_Previews: PreviewProvider {
    static var previews: some View {
        FileEditView(rawText: .constant(TangoFile.mockRawText)) { _ in
            print("completion")
        }
    }
}
