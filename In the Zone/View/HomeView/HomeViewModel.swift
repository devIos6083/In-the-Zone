import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = [] // Firestore에서 가져온 게시글을 저장하는 배열
    @Published var newsPosts: [Post] = [] // 뉴스 API에서 가져온 게시글을 저장하는 배열
    @Published var likedPosts: [Post] = [] // 사용자가 좋아요한 게시글을 저장하는 배열
       
    
    private var db = Firestore.firestore() // Firestore 인스턴스 생성
    private let newsAPIKey = "389fead73e7f47e2813916c8b4a4bfd3" // NewsAPI 키
    private let randomUserAPIKey = "UQ4K-IDJY-VMHF-8L84" // Random User Generator 키
    private var randomUsers: [RandomUser] = [] // 가상 유저 데이터를 저장할 배열

    init() {
        fetchRandomUsers() // 가상 유저 데이터를 먼저 불러옴
    }
    // 좋아요 기능 구현: 게시글의 좋아요 상태를 토글하는 함수
    func toggleLike(post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isLiked.toggle()
            posts[index].likes += posts[index].isLiked ? 1 : -1
            if posts[index].isLiked {
                likedPosts.append(posts[index])
            } else {
                likedPosts.removeAll { $0.id == post.id }
            }
        } else if let index = newsPosts.firstIndex(where: { $0.id == post.id }) {
            newsPosts[index].isLiked.toggle()
            newsPosts[index].likes += newsPosts[index].isLiked ? 1 : -1
            if newsPosts[index].isLiked {
                likedPosts.append(newsPosts[index])
            } else {
                likedPosts.removeAll { $0.id == post.id }
            }
        }
    }
    // Random User Generator에서 가상 유저 데이터를 가져오는 함수
    func fetchRandomUsers() {
        let urlString = "https://randomuser.me/api/?results=20" // 20명의 가상 유저 생성 요청
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching random users: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let randomUserResponse = try decoder.decode(RandomUserResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.randomUsers = randomUserResponse.results
                    self?.fetchNews() // 가상 유저 데이터를 불러온 후 뉴스 데이터를 가져옴
                }
            } catch {
                print("Error decoding random user data: \(error.localizedDescription)")
            }
        }.resume()
    }

    // NewsAPI에서 상위 20개의 뉴스를 가져오는 함수
    func fetchNews() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&pageSize=20&apiKey=\(newsAPIKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching news: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // 가상 유저와 뉴스 데이터를 조합하여 포스트로 만듦
                    self?.newsPosts = newsResponse.articles.enumerated().compactMap { index, article in
                        guard let user = self?.randomUsers[safe: index] else { return nil }
                        return Post(
                            id: UUID().uuidString, // 뉴스는 Firestore ID가 없으므로 UUID를 사용
                            username: user.login.username,
                            profileImageUrl: user.picture.medium, // 유저의 프로필 이미지
                            imageUrl: article.urlToImage ?? "",
                            likes: Int.random(in: 0...100), // 좋아요 수를 임의로 설정
                            description: article.title ?? "No description available", // 헤드라인을 설명에 넣음
                            timestamp: ISO8601DateFormatter().date(from: article.publishedAt ?? "") ?? Date()
                        )
                    }
                }
            } catch {
                print("Error decoding news data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// Random User Generator의 데이터를 디코딩하기 위한 구조체
struct RandomUserResponse: Codable {
    let results: [RandomUser]
}

struct RandomUser: Codable {
    let login: Login
    let picture: Picture
}

struct Login: Codable {
    let username: String
}

struct Picture: Codable {
    let medium: String
}

// NewsAPI에서 가져온 데이터를 디코딩하기 위한 구조체
struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String?
    let urlToImage: String?
    let publishedAt: String?
}

struct Source: Codable {
    let name: String?
}

// 배열의 인덱스 범위를 안전하게 처리하는 확장
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
