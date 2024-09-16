import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @State private var searchText: String = ""
   
    // `HomeViewModel`의 데이터를 SearchViewModel로 전달
    init(homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(posts: homeViewModel.posts + homeViewModel.newsPosts))
    }

    var body: some View {
        VStack {
            TextField("검색어를 입력해주세요", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            // 검색 결과를 리스트로 표시
            List(viewModel.filteredPosts) { post in
                VStack(alignment: .leading) {
                    Text(post.username).bold()
                    Text(post.description)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("In the Zone")
        .onChange(of: searchText) { newValue in
            viewModel.filterPosts(with: newValue) // 검색어가 변경될 때마다 필터링
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(homeViewModel: HomeViewModel())
    }
}
