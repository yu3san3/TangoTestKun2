//
//  ContentView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: TangoTestKun2Document

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(TangoTestKun2Document()))
    }
}
