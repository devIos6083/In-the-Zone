//
//  SignupViewModel.swift
//  In the Zone
//
//  Created by 홍규강 on 9/2/24.
//

import SwiftUI
import FirebaseAuth

class SignupViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    // 회원가입 로직
    func signUp(completion: @escaping () -> Void) {
        // 비밀번호 일치 확인
        guard password == confirmPassword else {
            errorMessage = "비밀번호가 일치하지 않습니다."
            return
        }

        isLoading = true
        // Firebase에 계정 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    // 회원가입 성공 시 처리
                    completion()
                }
            }
        }
    }
}
