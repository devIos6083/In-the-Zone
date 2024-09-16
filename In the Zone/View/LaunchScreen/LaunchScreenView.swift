import SwiftUI

// 메인 Launch Screen 뷰
struct LaunchScreenView: View {
    @Binding var showLaunchScreen: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(1.0)
                .edgesIgnoringSafeArea(.all)

            BackgroundView()
            
            // GeometryReader로 뷰 위치를 상대적으로 조정
            GeometryReader { geometry in
                LogoView()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // 중앙에 배치
            }
            .onAppear {
                // 3초 후에 Launch Screen이 사라지도록 설정
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showLaunchScreen = false
                    }
                }
            }
        }
    }
}

// MARK: - 배경 뷰를 담당하는 컴포넌트
private struct BackgroundView: View {
    fileprivate var body: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
    }
}

// "In the Zone" 텍스트와 애니메이션 로고를 표시하는 컴포넌트
private struct LogoView: View {
    fileprivate var body: some View {
        VStack(spacing: 30) {
            Spacer() // 상단에 빈 공간 추가로 중앙 위치 유지
            Text("In the Zone")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeOut(duration: 0.8).delay(0.2))

            RotatingCircleView() // 원 애니메이션 뷰

            Text("하루하루 충만한 삶을 기대하며")
                .font(.footnote)
                .foregroundColor(.white)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeOut(duration: 0.8).delay(0.8))
            Spacer() // 하단에 빈 공간 추가로 중앙 위치 유지
        }
        .frame(maxHeight: .infinity) // VStack의 높이를 최대 크기로 설정하여 중앙 배치
    }
}

// 회전하는 원 애니메이션을 표시하는 컴포넌트
private struct RotatingCircleView: View {
    @State private var isRotating = false

    fileprivate var body: some View {
        ZStack {
            // 고정된 흰색 원
            Circle()
                .frame(width: 96, height: 96)
                .foregroundColor(.white)

            // 흰색 원 내부에서 회전하는 얇은 초록색 선
            Circle()
                .trim(from: 0, to: 0.25) // 원의 1/4 부분만 보이도록 설정
                .stroke(
                    Color(red: 29 / 255, green: 185 / 255, blue: 84 / 255),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round) // 선 두께를 줄이고 끝을 둥글게 처리
                )
                .frame(width: 48, height: 48) // 흰색 원과 동일한 크기로 설정
                .rotationEffect(.degrees(isRotating ? 360 : 0)) // 회전 애니메이션 적용
                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: isRotating)
                .onAppear {
                    isRotating = true // 회전 애니메이션 시작
                }
        }
    }
}

// 프리뷰 설정
struct LaunchScreen_Previews: PreviewProvider {
    @State static var showLaunchScreen = true
    static var previews: some View {
        LaunchScreenView(showLaunchScreen: $showLaunchScreen)
    }
}
