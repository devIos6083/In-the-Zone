import SwiftUI

struct WriteView: View {
    @StateObject private var viewModel = WriteViewModel() // ViewModel 초기화
    @State private var isShowingEditor = false // 작성 뷰를 보여줄지 여부를 결정하는 State 변수
    @State private var isEditing = false // 선택 모드 활성화 여부를 관리
    @State private var selectedPosts: Set<String> = [] // 선택된 글 ID 목록
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.posts.isEmpty {
                    // 글이 없을 때 초기 화면
                    Spacer()
                    
                    // 중앙에 이미지 표시
                    Image("pencil")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 20)
                    
                    Text("글을 작성해 보세요.")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 40)
                    
                    Spacer()
                } else {
                    // 글이 작성된 후에는 글 목록을 보여줍니다.
                    List(viewModel.posts) { post in
                        HStack {
                            // 선택모드일때 체크 박스
                            if isEditing {
                                Image(selectedPosts.contains(post.id) ? "selectedBox" : "unSelectedBox")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .onTapGesture {
                                        toggleSelection(for: post.id)
                                    }
                                
                            }
                            // Firestore에 저장된 이미지가 있는 경우 보여줍니다.
                            AsyncImage(url: URL(string: post.imageUrl)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(post.description)
                                    .font(.headline)
                                    .lineLimit(2)
                                Text(post.timestamp, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("글 목록") // Navigation 제목 설정
            .toolbar {
                // 작성 버튼을 툴바에 추가
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingEditor = true // 작성 뷰 열기
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                
                
                // 삭제 버튼을 툴바에 추가
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                        if !isEditing {
                            selectedPosts.removeAll()
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                // 선택된 항목 삭제 버튼 추가
                ToolbarItem(placement: .navigationBarLeading) {
                    if isEditing {
                        Button(action: {
                            deleteSelectedPosts() // 선택된 포스트 삭제
                        }) {
                            Text("삭제")
                                .foregroundColor(.red)
                        }
                    }
                }
                
            }
            
            .sheet(isPresented: $isShowingEditor) {
                MemoEditorView(viewModel: viewModel) // 작성 뷰 모달로 띄우기
            }
        }
    }
    private func toggleSelection(for id: String) {
        if selectedPosts.contains(id) {
            selectedPosts.remove(id)
        } else {
            selectedPosts.insert(id)
        }
        
    }
    // 선택된 포스트 삭제 함수
      private func deleteSelectedPosts() {
          for postId in selectedPosts {
              viewModel.deletePost(by: postId)
          }
          selectedPosts.removeAll() // 삭제 후 선택 초기화
      }
}


struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView()
    }
}
