extension String {
    // 문자열에서 해시태그 및 일반 단어를 추출하는 함수
    func extractKeywords() -> [String] {
        let words = self.split(separator: " ").map { String($0) }
        return words.filter { !$0.isEmpty }
    }
}
