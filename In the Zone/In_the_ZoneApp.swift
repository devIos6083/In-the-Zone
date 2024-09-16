//
//  In_the_ZoneApp.swift
//  In the Zone
//
//  Created by 홍규강 on 9/1/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import Firebase
import UIKit

// AppDelegate 클래스: Firebase 초기화 및 Google Sign-In 처리를 담당
class AppDelegate: NSObject, UIApplicationDelegate {

    // 앱이 실행될 때 Firebase 초기화 설정
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure() // Firebase 초기화 코드 추가
        return true
    }
    
}

@main
struct In_the_ZoneApp: App {
    // AppDelegate를 SwiftUI와 연결
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var homeviewmodel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                   ContentView()
                    .environmentObject(homeviewmodel)
                 }
        } // 메인 콘텐츠 뷰
    }
}

