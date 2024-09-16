//
//  SignupView.swift
//  In the Zone
//
//  Created by 홍규강 on 9/2/24.
//

import SwiftUI

struct SignupView: View {
    @ObservedObject var viewModel = SignupViewModel()
    @Environment(\.dismiss) var dismiss // 화면을 닫기 위해 사용
    @State private var isSignedUp = false // 계정 생성 후 HomeView로 이동할 때 사용

    var body: some View {
        VStack {
            Spacer()

            // 상단 타이틀
            Text("In the Zone")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("d-text-deep"))
                .padding(.bottom, 10)
            
            Text("하루하루를 충만하게!")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("bk-2-fix"))
                .padding(.bottom, 30)

            
            // 이메일 입력 필드
            TextField("Enter your email", text: $viewModel.email)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            
            // 비밀번호 입력 필드
            SecureField("Enter your password", text: $viewModel.password)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 20)
              
            
            // 비밀번호 확인입력 필드
            SecureField("Enter your password", text: $viewModel.confirmPassword)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
         
            // 가입하기 버튼
            Button(action: {
                viewModel.signUp {
                    isSignedUp = true
                }
            }) {
                Text("가입하기")
                    .foregroundColor(Color("bk-2-fix"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("customGray0"))
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 15)

            // 서비스 약관 및 개인정보 처리방침 안내
            Text("가입하면 In-the-Zone의 서비스 약관과 개인정보 처리방침에 동의하게 됩니다.")
                .foregroundColor(Color("d-text-deep"))
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)

            // 로그인 안내 문구
            HStack {
                Text("이미 계정이 있나요?")
                    .foregroundColor(.white)
                    .font(.footnote)
                Button(action: {
                    dismiss() // 현재 뷰를 닫고 이전 뷰로 돌아가기
                }) {
                    Text("로그인")
                        .foregroundColor(Color("live-red"))
                        .fontWeight(.bold)
                        .font(.footnote)
                        .underline()
                }
            }

            Spacer()
            NavigationLink(destination: HomeView(), isActive: $isSignedUp) {
                           EmptyView()
                   }
        }
        .padding()
        .background(Image("background"))
        .ignoresSafeArea()
    }
}

struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
