⸻

📱 LocalSearchApp

Flutter로 개발된 위치 기반 로컬 리뷰 앱입니다.
사용자가 장소를 검색하고, 해당 장소에 대해 리뷰(댓글)를 남길 수 있습니다.

⸻

🧩 주요 기능
	•	🔍 장소 검색
사용자가 원하는 장소를 검색해 결과를 리스트로 확인
	•	💬 리뷰 작성 및 보기
각 장소별로 댓글(리뷰)을 입력 및 확인할 수 있음
	•	🧭 지도 기반 위치 정보 연동
각 장소의 좌표(mapX, mapY)를 기반으로 위치 리뷰 관리

⸻

🏗️ 사용된 기술
	•	Flutter 3.x
	•	Riverpod (상태 관리)
	•	Firestore (리뷰 저장 및 불러오기)
	•	intl (날짜 포맷팅)

⸻

🛠️ 실행 방법
	1.	Flutter 설치
https://docs.flutter.dev/get-started/install
	2.	프로젝트 클론

git clone https://github.com/kk20192073/localseachapp.git
cd localseachapp


	3.	패키지 설치

flutter pub get


	4.	실행

flutter run



⸻

📁 폴더 구조

lib/
├── homepage.dart               # 검색 및 장소 목록
├── reviewpage.dart            # 댓글(리뷰) 작성 화면
├── review.dart                # 리뷰 모델
├── review_view_model.dart     # 리뷰 ViewModel (Riverpod)
├── store.dart                 # 장소(Store) 모델
├── main.dart                  # 앱 진입점


⸻

✍️ 리뷰 저장 형식 (Firestore 예시)

{
  "id": "timestamp 기반 ID",
  "content": "사용자 입력 댓글",
  "mapX": 127.12345,
  "mapY": 37.54321,
  "createdAt": "2025-07-30T12:34:56.789"
}


⸻

🙌 기여 방법
	1.	이 레포를 포크합니다
	2.	새 브랜치를 생성합니다 (git checkout -b feature/기능)
	3.	변경사항을 커밋합니다 (git commit -m 'Add 기능')
	4.	푸시합니다 (git push origin feature/기능)
	5.	Pull Request를 보냅니다!

⸻

📄 라이선스

MIT License © 2025 kk20192073

⸻


