# 파일 첨부를 위한 BD 설정

drop database exists 'file_tbl';

CREATE TABLE file_tbl (
id INT PRIMARY KEY AUTO_INCREMENT COMMENT '파일 번호',
board_id INT NOT NULL COMMENT '게시글 번호',
origin_file_name VARCHAR(255) NOT NULL COMMENT '원본 파일명',
stored_file_path VARCHAR(255) NOT NULL COMMENT '파일 저장 경로',
file_size INT NOT NULL COMMENT '파일 크기',
creator VARCHAR(50) NOT NULL COMMENT '작성자',
created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
is_deleted CHAR(1) NOT NULL DEFAULT 'n' COMMENT '삭제 여부'
);




