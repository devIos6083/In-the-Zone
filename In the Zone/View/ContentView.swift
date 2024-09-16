import SwiftUI

struct ContentView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var showLaunchScreen = true
    @State private var selectedTab: PathType = .homeView
    @EnvironmentObject var homeviewmodel: HomeViewModel

    var body: some View {
        ZStack {
            if loginViewModel.isLoggedIn {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(PathType.homeView)
                    
                    SearchView(homeViewModel: homeviewmodel)
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .tag(PathType.searchView)
                    
                    WriteView()
                        .tabItem {
                            Label("Write", systemImage: "pencil")
                        }
                        .tag(PathType.writeView)
                    
                    SettingView(homeViewModel: homeviewmodel)
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .tag(PathType.settingView)
                }
            } else {
                LoginView(viewModel: loginViewModel)
            }

            if showLaunchScreen {
                LaunchScreenView(showLaunchScreen: $showLaunchScreen)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showLaunchScreen = false
                }
            }
        }
    }
}
