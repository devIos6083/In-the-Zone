import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // Firestore와 NewsAPI에서 데이터를 가져오는 ViewModel 사용

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Firestore에서 가져온 게시글 목록을 표시
                    ForEach(viewModel.posts) { post in
                        PostViews(post: post, viewModel: viewModel)
                    }
                    
                    // 뉴스 API와 Random User Generator에서 가져온 뉴스 게시글 목록을 표시
                    ForEach(viewModel.newsPosts) { post in
                        PostViews(post: post, viewModel: viewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("In the Zone") // 상단 네비게이션 타이틀 설정
        }
    }
}

// 각 게시글을 나타내는 뷰
struct PostViews: View {
    let post: Post
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // 사용자 정보와 프로필 이미지
            HStack {
                AsyncImage(url: URL(string: post.profileImageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 40)
                }
                
                Text(post.username)
                    .font(.headline)
            }
            .padding(.horizontal)
            
            // 게시된 이미지 표시
            AsyncImage(url: URL(string: post.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 400)
                    .frame(width: 400)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 400)
                    .frame(width: 400)
            }
            
            // 하단 아이콘과 설명 표시
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    // 좋아요 아이콘: 좋아요 상태에 따라 아이콘 색상 변경
                    Button(action: {
                        viewModel.toggleLike(post: post) // 좋아요 버튼 클릭 시 상태 변경
                    }) {
                        Image(systemName: post.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(post.isLiked ? .red : .black)
                    }
                    Image(systemName: "message")
                    Image(systemName: "paperplane")
                    Spacer()
                    Image(systemName: "bookmark")
                }
                .padding(.horizontal)
                .padding(.top, 5)
                
                Text("\(post.likes) likes")
                    .font(.subheadline)
                    .bold()
                    .padding(.horizontal)
                
                HStack {
                    Text(post.username)
                        .font(.subheadline)
                        .bold()
                    Text(post.description)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
