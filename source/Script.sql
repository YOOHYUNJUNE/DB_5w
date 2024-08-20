# SNS 데이터베이스 구성

# DB 생성 (ostagram)
# 테이블 (users, posts, followers, likes)

# users [
	-- id int auto_increment primary key,
	-- name varchar(100) not null, 
	-- email varchar(100) not null unique,  
	-- password varchar(255) not null, 
	-- bio text, 
	-- profile varchar(255), 
	-- created_at datetime default current_timestamp, 
	-- updated_at datetime default current_timestamp on update current_timestamp, 
	-- deleted_at datetime
-- ]


# posts [
	-- id,
	-- user_id,
	-- content,
	-- image,
	-- created_at datetime default current_timestamp, 
	-- updated_at datetime default current_timestamp on update current_timestamp, 
	-- deleted_at datetime

	# user_id는 users 테이블과 관계 (users 삭제시 posts도 삭제)
-- ]


# likes [
	-- id,
	-- user_id,
	-- post_id,
	-- created_at datetime default current_timestamp, 
	-- deleted_at datetime
	# user_id는 users 테이블과 관계 (users 삭제시 likes도 삭제)
	# post_id는 posts 테이블과 관계 (posts 삭제시 likes도 삭제)
-- ]


# followers [ -- 회원과 회원 다 : 다 연결해줌
	-- id,
	-- following_id,
	-- followed_id
	-- created_at datetime default current_timestamp, 
	-- deleted_at datetime
	# following_id는 users 테이블과 관계 (users 삭제시, follwer도 삭제)
	# followed_id는 users 테이블과 관계
-- ]
drop database if exists kostagram;
create database kostagram default charset=utf8mb4;
use kostagram;

-- drop table posts;
-- drop table users, posts, likes, followers;

# 유저
create table users (
	id int auto_increment primary key,
	name varchar(100) not null,
	email varchar(100) not null unique,
	password varchar(255) not null,
	bio text,
	profile varchar(255),
	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp,
	deleted_at datetime
);

# 작성글
create table posts (
 	id int auto_increment primary key,
	user_id int not null,
	content text,
	image varchar(255) not null,
	created_at datetime default current_timestamp, 
	updated_at datetime default current_timestamp on update current_timestamp, 
	deleted_at datetime,
	# id는 users 테이블과 관계 (users 삭제시 posts도 삭제)
	foreign key(user_id) references users(id) on delete cascade
);

# 좋아요
create table likes (
	id int auto_increment primary key,
	user_id int not null,
	post_id int not null,
	created_at datetime default current_timestamp, 
	deleted_at datetime,
	 # 유저아이디는 users 테이블과 관계 (users 삭제시 likes도 삭제)
	foreign key(user_id) references users(id) on delete cascade,
	 # 포스트아이디는 posts 테이블과 관계 (posts 삭제시 likes도 삭제)
	foreign key(post_id) references posts(id) on delete cascade,
	 # 좋아요는 중복되지 않게
	unique key(user_id, post_id)
);

# 팔로잉
create table followers ( -- 회원과 회원 다 : 다 연결해줌
	id int auto_increment primary key,
	following_id int not null,
	followed_id int not null,
	created_at datetime default current_timestamp, 
	deleted_at datetime,
	# following_id는 users 테이블과 관계 (users 삭제시, follwer도 삭제)
	foreign key(following_id) references users(id) on delete cascade,
	# followed_id는 users 테이블과 관계
	foreign key(followed_id) references users(id) on delete cascade
);


#--------------------------------------------------------------------
select * from users;
select * from posts;
select * from likes;
select * from followers;

# 데이터 삽입
insert into users (name, email, password) values
('A', 'aaa@naver.com', 'a123456'),
('B', 'bbb@naver.com', 'b123456'),
('C', 'ccc@naver.com', 'c123456'),
('D', 'ddd@naver.com', 'd123456');
select * from users;

insert into posts (user_id, content, image) values
(2, '어이가 없네', 'hr.jpg'),
(3, '환승 아닙니다', 'hsh.jpg');
select * from posts;

# 삭제하지 않은 행만 조회
select * from users where deleted_at is null;

# 특정 사용자의 게시물 조회
select p.*, u.name from posts p
join users u
on p.user_id = u.id
where p.deleted_at is null and u.id=3;

# 팔로우
insert into followers (following_id, followed_id)
values (2, 1) on duplicate key update deleted_at = null;

select * from followers;

# 언팔로우
update followers
set deleted_at = now()
where following_id = 3 and followed_id = 1 and deleted_at is null;

select f.id, ing.name `팔로우 한`, ed.name `팔로우 된` from followers f
join users ing on ing.id = f.following_id
join users ed on ed.id = f.followed_id
where f.deleted_at is null;


-- 좋아요, 좋아요 취소
select * from users;
select * from posts;
select * from likes;

# posts와 likes 연결
select p.id, p.content, l.user_id `좋아요 누른사람` from posts p join likes l on p.id = l.post_id;

# 특정 글에 좋아요
insert into likes (user_id, post_id) values(1, 1) on duplicate key update deleted_at = null;

# 좋아요 취소
update likes set deleted_at = now() where user_id=1 and post_id=1 and deleted_at is null;
select * from likes;

-- 특정 사용자 팔로워, 팔로잉 수
select * from users;
select * from followers;

# 팔로워 목록
select u.name, f.following_id, f.followed_id from followers f 
join users u on u.id = f.following_id
join users ing on ing.id = f.followed_id;

select ed.* from followers f
join users ing on f.following_id = ing.id
join users ed on f.followed_id = ed.id
where ed.id = 3;

# 팔로우 수
select u.name, count(*) from followers f 
join users u on u.id = f.following_id group by name;

# 팔로우 된 수
select u.name, count(*) from followers f 
join users u on u.id = f.followed_id group by name;


