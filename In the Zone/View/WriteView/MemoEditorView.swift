import SwiftUI
import PhotosUI

struct MemoEditorView: View {
    @ObservedObject var viewModel: WriteViewModel
    @Environment(\.dismiss) var dismiss // 작성 후 뷰 닫기 기능 제공
    @State private var imagePickerPresented = false // 이미지 선택 시트 표시 여부

    var body: some View {
        NavigationView {
            VStack {
                // 이미지 선택 영역
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding()
                }

                Button("이미지 추가") {
                    imagePickerPresented = true
                }
                .sheet(isPresented: $imagePickerPresented) {
                    ImagePicker(selectedImage: $viewModel.selectedImage)
                }

                TextEditor(text: $viewModel.memoText)
                    .padding()
                    .border(Color.gray, width: 1)
                    .padding(.horizontal)

                Button(action: {
                    viewModel.savePost() // Post를 저장하고 Firestore에 반영
                    dismiss() // 작성 후 뷰 닫기
                }) {
                    Text("저장하기")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            .navigationTitle("메모 작성")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss() // 취소 버튼
                    }
                }
            }
        }
    }
}

