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
            Text("単語データが選択されていません。")
                .foregroundColor(.gray)
        } else {
            ZStack(alignment: .bottomTrailing) {
                testContentList
                bottomButton
            }
        }
    }
}

private extension TangoTestView {
    var testContentList: some View {
        List {
            Section {
                ForEach(0..<tangoData.endIndex, id: \.self) { index in
                    makeListItem(index: index)
                }
            }
            .listSectionSeparator(.hidden) //上下のリスト区切り線を消す
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

    var bottomButton: some View {
        HStack(spacing: 0) {
            shuffleButton
            Divider()
            showAnswersButton
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(lineWidth: 0.5)
                .foregroundColor(.blue)
        )
        .frame(height: 10)
        .padding(.horizontal, 23)
        .padding(.vertical, 30)
    }

    var shuffleButton: some View {
        Button(action: {
            impactOccurred()
            tangoData.shuffle()
        }) {
            Image(systemName: "shuffle")
                .frame(width: 13, height: 10)
                .padding()
//                .background(Color(UIColor.systemBackground).opacity(0.95))
        }
    }

    var showAnswersButton: some View {
        Button(action: {
            impactOccurred()
            isCheckingAnswers.toggle()
        }) {
            Image(systemName: isCheckingAnswers ? "pencil" : "pencil.slash")
                .frame(width: 13, height: 10)
                .padding()
                .foregroundColor(.red)
//                .background(Color(UIColor.systemBackground).opacity(0.95))
        }
    }

    func impactOccurred() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
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
