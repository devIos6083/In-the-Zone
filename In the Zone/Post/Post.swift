import Foundation

struct Post: Identifiable {
    var id: String // Firestore의 document ID를 사용
    var username: String
    var profileImageUrl: String
    var imageUrl: String
    var likes: Int
    var description: String
    var timestamp: Date
    var isLiked: Bool = false // 게시물이 좋아요 되었는지 여부를 관리하는 속성
}
