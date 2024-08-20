create database mybatis_proj_db
default character set = 'utf8mb4' collate = 'utf8mb4_0900_ai_ci';

use mybatis_proj_db;

# users 테이블 생성
create table users_tbl (
	id int auto_increment primary key comment '사용자 번호',
	name varchar(50) not null comment '사용자 이름',
	email varchar(100) unique not null comment '사용자 이메일',
	created_at datetime default current_timestamp comment '사용자 가입날짜',
	deleted_at char(1) default 'n' not null comment '사용자 탈퇴 여부'
);
-- deleted_at -> is_deleted

# coffee 테이블 생성
create table coffee_tbl (
	id int primary key auto_increment comment '메뉴 고유 번호',
	name varchar(255) not null comment '메뉴 이름',
	price int not null comment '메뉴 가격',
	caffeine int not null default 0 comment '메뉴 카페인 함량',
	sugar int not null default 0 comment '메뉴 당류 함량',
	detail varchar(255) not null comment '메뉴 상세 설명',
	ice char(1) default 'n' not null comment '아이스, 핫 여부',
	created_at datetime not null default current_timestamp comment '메뉴 등록일',
	creator_id int not null comment '메뉴 등록자 번호',
	updated_at datetime default null on update current_timestamp comment '메뉴 수정일',
	is_deleted char(1) not null default 'n' comment '메뉴 삭제 여부',
	foreign key (creator_id) references users_tbl(id)
);

# 커피 메뉴의 파일 테이블
create table coffee_file_tbl (
	id int primary key auto_increment comment '파일 번호',
	coffee_id int not null comment '메뉴 고유 번호',
	origin_file_name varchar(255) not null comment '원본 파일명',
	stored_file_path varchar(255) not null comment '파일 저장 경로',
	file_size int not null comment '파일 크기',
	foreign key (coffee_id) references coffee_tbl(id)
);


select * from users_tbl;

select * from coffee_tbl;

select * from coffee_file_tbl;


