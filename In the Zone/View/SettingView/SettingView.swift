import SwiftUI

// SettingView는 사용자 프로필과 관련 게시물 목록을 보여주는 화면입니다.
struct SettingView: View {
    @ObservedObject var settingViewModel = SettingViewModel() // SettingViewModel 사용
    @ObservedObject var homeViewModel: HomeViewModel // HomeViewModel을 전달받아 사용
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 프로필 섹션
                    HStack {
                        if !settingViewModel.profileImageUrl.isEmpty {
                            AsyncImage(url: URL(string: settingViewModel.profileImageUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.trailing, 20)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding(.trailing, 20)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(settingViewModel.username)
                                .font(.largeTitle)
                                .bold()
                            Text(settingViewModel.userHandle)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 통계 섹션
                    HStack {
                        StatView(count: settingViewModel.posts.count, title: "게시물")
                        // 팔로워, 팔로잉 수는 따로 관리하도록 설정
                        StatView(count: 500, title: "팔로워")  // 예시로 고정값 사용
                        StatView(count: 300, title: "팔로잉")  // 예시로 고정값 사용
                    }
                    .padding(.bottom, 20)
                    
                    // 게시물 목록 섹션
                    ForEach(settingViewModel.posts) { post in
                        PostDetailView(post: post)
                    }
                    
                    // 메뉴 섹션
                    MenuItemView(title: "❤️ 좋아요한 게시물") {
                        // 좋아요한 게시물을 모아볼 수 있는 화면으로 이동
                        navigateToLikedPostsView()
                    }
                    MenuItemView(title: "프로필 수정", action: { /* 구현할 액션 */ })
                    MenuItemView(title: "개인정보 설정", action: { /* 구현할 액션 */ })
                    MenuItemView(title: "알림 설정", action: { /* 구현할 액션 */ })
                }
                .padding()
            }
            .navigationTitle("설정")
        }
        .onAppear {
            settingViewModel.fetchUserPosts() // 사용자 게시글을 가져오는 함수 호출
        }
    }
    
    // 좋아요한 게시물 화면으로 이동하는 함수
    private func navigateToLikedPostsView() {
        // HomeViewModel에서 likedPosts를 전달하여 LikedPostsView로 이동합니다.
        let likedPostsView = LikedPostsView(likedPosts: homeViewModel.likedPosts)
        let likedPostsVC = UIHostingController(rootView: likedPostsView)
        UIApplication.shared.windows.first?.rootViewController?.present(likedPostsVC, animated: true, completion: nil)
    }
}

// 좋아요한 게시물들을 모아 보여주는 뷰
struct LikedPostsView: View {
    let likedPosts: [Post]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(likedPosts) { post in
                PostDetailView(post: post)
            }
        }
        .padding()
        .navigationTitle("❤️ 좋아요한 게시물")
    }
}

// 개별 게시물 정보를 상세히 보여주는 뷰
struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: post.profileImageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                }
                
                Text(post.username)
                    .font(.headline)
                Spacer()
                Text(post.timestamp, style: .date)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            if let url = URL(string: post.imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(10)
            }
            
            HStack {
                Text("❤️ \(post.likes)")
                Spacer()
            }
            .padding(.vertical, 5)
            
            Text(post.description)
                .font(.body)
        }
        .padding(.vertical)
    }
}

// 통계 정보를 표시하는 뷰
struct StatView: View {
    let count: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.headline)
            Text(title)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

// 메뉴 아이템을 표시하는 뷰
struct MenuItemView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(homeViewModel: HomeViewModel()) // HomeViewModel 전달
    }
}
