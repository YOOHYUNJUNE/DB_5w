DROP DATABASE IF EXISTS `board_db`;
CREATE DATABASE board_db DEFAULT CHARACTER SET = 'utf8mb4' COLLATE = 'utf8mb4_0900_ai_ci';

USE board_db;

CREATE TABLE board_tbl (
	id INT PRIMARY KEY AUTO_INCREMENT COMMENT '글 번호',
	title VARCHAR(300) NOT NULL COMMENT '글 제목',
	content TEXT NOT NULL COMMENT '글 내용',
	hit INT NOT NULL DEFAULT 0 COMMENT '조회 수',
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
	creator VARCHAR(50) NOT NULL COMMENT '작성자',
	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
	is_deleted CHAR(1) NOT NULL DEFAULT 'n' COMMENT '삭제 여부'
);


INSERT INTO board_tbl (title, content, hit, creator, is_deleted)
VALUES
('여름 휴가 계획 공유합니다!', '올해 여름에는 제주도에 가려고 계획 중입니다. 맛집도 많이 찾아봤는데, 추천할 만한 곳 있으면 알려주세요!', 150, '김민수', 'n'),
('새로운 IT 트렌드 - AI와 빅데이터', '최근 AI와 빅데이터가 IT 업계의 핵심 이슈로 떠오르고 있습니다. 이와 관련된 세미나가 곧 열린다고 하니, 관심 있는 분들은 참여해보세요.', 230, '박지영', 'n'),
('가을 산책하기 좋은 장소 추천해주세요', '날씨가 선선해지면서 산책하기 좋은 계절이 왔네요. 서울 근교에서 가을 산책하기 좋은 장소를 추천받고 싶습니다.', 90, '이정훈', 'n');

select * from board_tbl;


# 파일첨부용 테이블 1:N (board 게시글에 파일 첨부 여러개)
CREATE TABLE file_tbl (
	id INT PRIMARY KEY AUTO_INCREMENT COMMENT '파일 번호',
	board_id INT NOT NULL COMMENT '게시글 번호',
	origin_file_name VARCHAR(255) NOT NULL COMMENT '원본 파일명',
	stored_file_path VARCHAR(255) NOT NULL COMMENT '파일 저장 경로',
	file_size INT NOT NULL COMMENT '파일 크기',
	creator VARCHAR(50) NOT NULL COMMENT '작성자',
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
	updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
	is_deleted CHAR(1) NOT NULL DEFAULT 'n' COMMENT '삭제 여부',
	foreign key(board_id) references board_tbl(id)
);

select * from file_tbl;










