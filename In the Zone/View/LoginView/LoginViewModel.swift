//
//  LoginViewModel.swift
//  In the Zone
//
//  Created by 홍규강 on 9/2/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false // 로그인 성공 여부를 관리하는 상태 변수
    
    private let db = Firestore.firestore()

    // 이메일/비밀번호로 로그인하는 함수
    func signIn() {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self?.isLoggedIn = true // 로그인 성공 시 상태 변경
//                    self.saveUserData()
                }
            }
        }
    }
    // Firestore에 사용자 데이터를 저장하는 함수
    private func saveUserData(user: User) {
        let userRef = db.collection("users").document(user.uid)
        
        let userData: [String : Any] = [
            "email": user.email ?? "",
            "userId": user.uid,
            "profileImageUrl": "", // 프로필 이미지 URL을 나중에 업데이트 가능
            "createdAt": Timestamp()
        
        ]
        
        // Firestore에 사용자 데이터 저장
        userRef.setData(userData, merge: true) { error in
            if let error = error {
                print("Failed to save user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully")
            }
        }
    }
    

}
