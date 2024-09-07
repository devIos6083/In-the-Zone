# In the Zone

## 목차 
- [요약](#요약)
- [진행 상황](#진행-상황)
- [구현 결과](#구현-결과)
- [개선 및 기능 추가](#개선-및-기능-추가)
- [트러블 슈팅](#트러블-슈팅)
- [학습한 내용](#학습한-내용)

-------------

## 요약

|Index|Detail|
|------|---|
|기여|100% ( 1인 개발 진행 ) |
|앱의 목적 및 특징|하루하루를 충만하게 만들기 위한 앱 개발 / 편안한 색감을 위해 초록 색감을 세련되게 표현함|
|구현 기간| **2024.08.31 ~ 2024.~~.~~**|
|구현 목표 | [In the Zone]  <br> - 시작 화면 - 메인 화면| 
|실제 구현|  |
|기술 스택| |
|Pain Point| |
|해결 방법|  |
|아쉬운점| |

-------------

## 진행 상황

|날짜|내용|
|------|---|
|**2024.08.31**|앱 전체적인 기능 및 디자인 구상|
|**2024.09.01**|런치 스크린 구현|
|**2024.09.02**|로그인 화면 구현|
|**2024.09.04**|회원가입 화면 구현|
|**2024.09.05**|탭뷰 구현 / 홈뷰 구현(스크롤 뷰 + firebase DB 연결)|
|**2024.09.07**|검색뷰 구현|

-------------

# 구현 결과

## 구현
|런치스크린|로그인|회원가입|계정이 존재하는 경우|
|:----:|:----:|:----:|:----:|
|<img src="https://github.com/user-attachments/assets/6faac9cc-c149-4dcb-b418-e91d61e9806a" width="300">|<img src="https://github.com/user-attachments/assets/9e8d345d-2529-4565-be16-10257afd9c1b" width="300">|<img src="https://github.com/user-attachments/assets/d4cc7cd0-e4c7-4d5a-bb0e-03ca11695fba" width="300">|<img src="https://github.com/user-attachments/assets/995fac8c-766d-44e4-8e5e-f9a51e07bf76" width="300">|

|탭 뷰|홈뷰 구현(firebase DB 연결)|검색 뷰 구현||
|:----:|:----:|:----:|:----:|
|<img src="https://github.com/user-attachments/assets/3c43d4b0-6a00-4f7f-ac5c-5770359fd28a" width="300">|<img src="https://github.com/user-attachments/assets/9511b8bd-db1c-422a-ac43-f21c54e09a19" width="300" >|<img src="https://github.com/user-attachments/assets/e6278e64-4c9c-490d-b8c9-85a3e46e1106" width="300">||


-------------

## 개선 및 기능 추가

1. 구글 로그인 추가


## 트러블 슈팅
    1. 커스텀 색상을 내가 가져와서 확장해서 쓰고 싶었는데 잘안됨 
    2. 단순한 뷰를 런치스크린으로 하는 것은 상관없지만 애니메이션이 들어간 런치스크린을 뷰로 사용하는 경우 swiftUI에서는  문제가 발생 -> 단순한 zstack으로 감싸는걸 생각했음
    3. 런치스크린 -> 로그인 뷰로 넘어가는 것의 어려움 -> 비동기적 개념 필요

-------------

## 학습한 내용
 
#### 준비 중

