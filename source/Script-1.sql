-- SNS 데이터베이스 구성하기
# 데이터베이스 생성 (kostagram)
drop database if exists kostagram;
create database kostagram default character set = 'utf8mb4';
use kostagram;
# 테이블 (users, posts, followers, likes)

# users
create table `users` (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	bio TEXT,
	profile_pic VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	deleted_at DATETIME
);

# posts
create table `posts` (
	id INT auto_increment primary key,
	user_id INT not NULL,
	content TEXT,
	image VARCHAR(255) not NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	deleted_at DATETIME,
	foreign key(user_id) references users(id) on delete cascade
);

# likes
create table `likes` (
	id INT auto_increment primary key,
	user_id INT not null,
	post_id INT not NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	deleted_at DATETIME,
	foreign key(user_id) references users(id) on delete cascade,
	foreign key(post_id) references posts(id) on delete cascade,
	unique key(user_id, post_id)
);

# followers
create table `followers` (
	id INT auto_increment primary key,
	following_id INT not NULL,
	followed_id INT not NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	deleted_at DATETIME,
	foreign key(following_id) references users(id) on delete cascade,
	foreign key(followed_id) references users(id) on delete cascade,
	unique key(following_id, followed_id)
);

# 데이터 삽입
insert into users (`name`, `email`, `password`) values
("류준열", "ryu@gmail.com", "1234"),
("혜리", "hr@gmail.com", "1234"),
("한소희", "hsh@gmail.com", "1234"),
("최인규", "choi@gmail.com", "1234");

insert into posts (`user_id`, `content`, `image`) values
(2, "어이가 없네?", "hr.jpg"),
(3, "환승 아닙니다", "hsh.jpg");

# 데이터 조회
-- 사용자 목록 조회
select * from users where deleted_at is NULL;

-- 게시물 전체 조회
select p.*, u.name from posts p
join users u on p.user_id = u.id
where p.deleted_at is NULL;

-- 특정 사용자 게시물 조회
select p.*, u.name from posts p
join users u on p.user_id = u.id
where u.id = 3 and p.deleted_at is null and u.deleted_at is null;

-- 팔로우 하기
insert into `followers` (following_id, followed_id)
values (1, 4) on duplicate key update deleted_at = null;

-- 언팔로우 하기
update `followers`
set deleted_at = now()
where following_id = 1 and followed_id = 4 and deleted_at is null;

-- select f.id, ing.name `팔로우한`, ed.name `팔로우 당한` from followers f
-- join users ing on ing.id = f.following_id
-- join users ed on ed.id = f.followed_id
-- where f.deleted_at is null;

-- 특정 사용자가 특정 게시물 좋아요
insert into `likes` (user_id, post_id)
values (1, 1) on duplicate key update deleted_at = null;

-- 특정 사용자가 특정 게시물 좋아요 취소
update `likes`
set deleted_at = now()
where user_id = 1 and post_id = 1 and deleted_at is null; 

-- 특정 사용자 팔로워 수, 팔로잉 수 조회
select
(select count(*) from followers where following_id = 1 group by following_id) as "내가 팔로잉",  
(select count(*) from followers where followed_id = 1 group by followed_id) as "나를 팔롱";

-- 특정 사용자 팔로워 목록 조회
select ing.* from followers f
join users ing on f.following_id = ing.id
join users ed on f.followed_id = ed.id
where ed.id = 3;

-- 특정 사용자 팔로잉 목록 조회
select ed.* from followers f
join users ing on f.following_id = ing.id
join users ed on f.followed_id = ed.id
where ing.id = 3;


select * from users;
select * from posts;
select * from followers;

select p.id `게시글 번호`, u.name, p.user_id `유저 번호`, p.content, p.image from users u join posts p on u.id = p.user_id;
select * from users where deleted_at is null;

select * from users;
select * from posts;
# 게시물 목록
select p.id `게시물ID`, user_id `유저ID`, u.name, content, image, p.deleted_at 
from posts p join users u on p.user_id = u.id;



select * from posts where deleted_at is null;
select * from likes;

select * from posts where id in (
select post_id from likes where user_id=1
);

select * from posts p join likes l
on l.post_id = p.id
where l.user_id = 1;






