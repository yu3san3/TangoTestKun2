//
//  TangoTestView.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/02.
//

import SwiftUI

struct TangoTestView: View {
    @Binding var tangoData: [TangoDataElement]
    let testType: TestType
    @Binding var isCheckingAnswers: Bool

    var body: some View {
        if tangoData.isEmpty {
            VStack {
                Text("単語データが空です。")
                Text("編集ボタンからデータを入力してください。")
            }
            .foregroundColor(.gray)
        } else {
            testContentList
        }
    }
}

private extension TangoTestView {
    var testContentList: some View {
        List {
            Section {
                ForEach(0..<tangoData.endIndex, id: \.self) { index in
                    VStack(alignment: .leading) {
                        makeListItem(index: index)
                        #if os(macOS)
                        Divider()
                        #endif
                    }
                }
            }
            .listSectionSeparator(.hidden) //リストの一番上と下の区切り線を消す
        }
        .listStyle(.plain)
    }

    func makeListItem(index: Int) -> some View {
        HStack {
            Image(systemName: "\(index+1).circle")
            switch testType {
            case .jp:
                Text(tangoData[index].jp)
                if isCheckingAnswers {
                    Spacer()
                    Text(tangoData[index].en)
                }
            case .en:
                Text(tangoData[index].en)
                if isCheckingAnswers {
                    Spacer()
                    Text(tangoData[index].jp)
                }
            }
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TangoTestView(
            tangoData: .constant(TangoFile.mockTangoData),
            testType: .jp,
            isCheckingAnswers: .constant(false)
        )
    }
}
