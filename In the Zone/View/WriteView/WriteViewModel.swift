import SwiftUI
import FirebaseFirestore
import PhotosUI

class WriteViewModel: ObservableObject {
    @Published var memoText: String = "" // 메모 내용
    @Published var selectedImage: UIImage? // 선택된 이미지
    @Published var posts: [Post] = [] // 작성된 메모 목록을 Post 구조체로 관리
    private var db = Firestore.firestore() // Firestore 인스턴스

    init() {
        fetchPosts() // 초기화 시 Firestore에서 데이터를 가져옵니다.
    }
    
    // WriteViewModel.swift - 삭제 기능 추가 부분

    // Firestore에서 포스트 삭제 함수
    func deletePost(by id: String) {
        db.collection("posts").document(id).delete { error in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Post deleted successfully")
            }
        }
    }


    // Firestore에서 메모 데이터를 가져오는 함수
    func fetchPosts() {
        db.collection("posts").order(by: "timestamp", descending: true).addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self?.posts = documents.compactMap { doc -> Post? in
                let data = doc.data()
                guard let username = data["username"] as? String,
                      let profileImageUrl = data["profileImageUrl"] as? String,
                      let imageUrl = data["imageUrl"] as? String,
                      let likes = data["likes"] as? Int,
                      let description = data["description"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    print("Error parsing document data: \(doc.data())")
                    return nil
                }
                return Post(
                    id: doc.documentID,
                    username: username,
                    profileImageUrl: profileImageUrl,
                    imageUrl: imageUrl,
                    likes: likes,
                    description: description,
                    timestamp: timestamp.dateValue()
                )
            }
        }
    }

    // 메모를 Firestore에 저장하는 함수
    func savePost() {
        guard !memoText.isEmpty else { return }

        uploadImage(selectedImage) { [weak self] url in
            guard let self = self else { return }
            let newPost: [String: Any] = [
                "username": "user1", // 예시로 사용자 이름 지정
                "profileImageUrl": "https://example.com/profile.png", // 사용자 프로필 이미지 URL 예시
                "imageUrl": url ?? "", // 선택된 이미지의 URL 또는 빈 값
                "likes": 0,
                "description": self.memoText,
                "timestamp": Timestamp(date: Date())
            ]

            self.db.collection("posts").addDocument(data: newPost) { error in
                if let error = error {
                    print("Error adding post: \(error.localizedDescription)")
                } else {
                    print("Post saved successfully")
                    self.memoText = "" // 저장 후 텍스트 필드 초기화
                    self.selectedImage = nil
                }
            }
        }
    }
}

// 이미지 업로드 함수 예시 (Cloud Storage 연동 필요)
func uploadImage(_ image: UIImage?, completion: @escaping (String?) -> Void) {
    guard let image = image else {
        completion(nil)
        return
    }

    // Cloud Storage에 이미지 업로드 로직 구현 필요
    // 완료 후 URL을 반환해야 함
    completion("https://example.com/uploaded_image.png") // 예시 URL
}

