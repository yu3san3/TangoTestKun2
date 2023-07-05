//
//  AppState.swift
//  TangoTestKun2
//
//  Created by 丹羽雄一朗 on 2023/07/06.
//

import Foundation

class AppState: ObservableObject {
    @Published var isCheckingAnswers = false
    @Published var isShowingFileEditView = false
    @Published var testType: TestType = .jp
}
