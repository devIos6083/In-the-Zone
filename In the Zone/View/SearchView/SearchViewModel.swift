import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var posts: [Post] = [] // 전체 포스트 리스트
    @Published var filteredPosts: [Post] = [] // 필터링된 결과 리스트
    
    // 수정된 생성자: 외부에서 posts 데이터를 주입받음
    init(posts: [Post]) {
        self.posts = posts
        self.filteredPosts = posts
    }
    
    // 검색어에 따라 포스트 필터링
    func filterPosts(with query: String) {
        guard !query.isEmpty else {
            filteredPosts = posts // 검색어가 비어 있으면 전체 리스트 표시
            return
        }
        let keywords = query.extractKeywords()
        
        // username 검색 또는 description의 # 태그 검색
        filteredPosts = posts.filter { post in
            for keyword in keywords {
                if post.username.lowercased().contains(keyword.lowercased()) ||
                    post.description.lowercased().contains(keyword.lowercased()) {
                    return true
                }
            }
            return false
        }
    }
}
