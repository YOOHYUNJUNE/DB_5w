-- news_db 생성
drop database if exists news_db;

create database news_db default character set = 'utf8mb4' collate utf8mb4_0900_ai_ci;

use news_db;

-- news 테이블 생성
create table news (
	id int not null primary key auto_increment, # primay key니까 not null 생략가능
	title varchar(255) not null,
	img varchar(255) not null,
	date datetime not null default current_timestamp,
	content varchar(255) not null
);

select * from news;



















