import SwiftUI
import FirebaseFirestore

// SettingViewModel은 설정 화면의 데이터를 관리하며, 사용자의 게시물 목록을 포함합니다.
class SettingViewModel: ObservableObject {
    @Published var username: String = "Corsair"
    @Published var userHandle: String = "@devIos6083"
    @Published var profileImageUrl: String = ""
    @Published var posts: [Post] = []
    @Published var likedPosts: [Post] = [] // 좋아요한 게시물 목록을 관리하는 배열

    // Firestore에서 사용자의 게시물을 가져오는 함수
    func fetchUserPosts() {
        let db = Firestore.firestore()
        db.collection("posts").whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                let post = Post(
                    id: doc.documentID,
                    username: data["username"] as? String ?? "",
                    profileImageUrl: data["profileImageUrl"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? "",
                    likes: data["likes"] as? Int ?? 0,
                    description: data["description"] as? String ?? "",
                    timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                )
                // 좋아요한 게시물이라면 likedPosts에 추가
                if post.isLiked {
                    self.likedPosts.append(post)
                }
                return post
            }
        }
    }
}
