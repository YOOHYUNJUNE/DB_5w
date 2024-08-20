DROP DATABASE IF EXISTS `mybatis_proj_db`;
CREATE DATABASE `mybatis_proj_db`;

USE `mybatis_proj_db`;


DROP TABLE IF EXISTS `users_tbl`;

CREATE TABLE `users_tbl` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '사용자 번호',
  `name` varchar(50) NOT NULL COMMENT '사용자 이름',
  `email` varchar(100) NOT NULL COMMENT '사용자 이메일',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '사용자 가입일',
  `is_deleted` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'n' COMMENT '사용자 탈퇴 여부',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `community_tbl`;

CREATE TABLE `community_tbl` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '글 번호',
  `title` varchar(300) NOT NULL COMMENT '글 제목',
  `content` text NOT NULL COMMENT '글 내용',
  `hit` int NOT NULL DEFAULT '0' COMMENT '조회 수',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
  `creator_id` int NOT NULL COMMENT '작성자 번호',
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
  `is_deleted` char(1) NOT NULL DEFAULT 'n' COMMENT '삭제 여부',
  PRIMARY KEY (`id`),
  KEY `creator_id` (`creator_id`),
  CONSTRAINT `community_tbl_ibfk_1` FOREIGN KEY (`creator_id`) REFERENCES `users_tbl` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `community_file_tbl`;

CREATE TABLE `community_file_tbl` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '파일 번호',
  `community_id` int NOT NULL COMMENT '글 번호',
  `origin_file_name` varchar(255) NOT NULL COMMENT '원본 파일명',
  `stored_file_path` varchar(255) NOT NULL COMMENT '파일 저장 경로',
  `file_size` int NOT NULL COMMENT '파일 크기',
  PRIMARY KEY (`id`),
  KEY `commnity_id` (`community_id`),
  CONSTRAINT `community_file_tbl_ibfk_1` FOREIGN KEY (`community_id`) REFERENCES `community_tbl` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from users_tbl;
select * from community_tbl;
select * from community_file_tbl;


