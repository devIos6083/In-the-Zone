//
//  LoginView.swift
//  In the Zone
//
//  Created by 홍규강 on 9/2/24.
//
// LoginView.swift
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("In the Zone")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Text("로그인하여 계속하기")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
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
                    .padding(.bottom, 20)
                
                // 이메일 로그인 버튼
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                
                
                // 회원가입 안내 문구
                HStack {
                    Text("계정이 없으신가요?")
                        .foregroundColor(.white)
                        .font(.footnote)
                    NavigationLink(destination: SignupView()) {
                        Text("가입하기")
                            .foregroundColor(.red)
                            .font(.footnote)
                            .underline()
                    }
                    
                }
                Spacer()
              
            }
            .padding()
            .background(Image("background"))
            .ignoresSafeArea()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
