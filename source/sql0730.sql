use study_db;

# 테이블 생성
create table contact (
	id int auto_increment primary key, # 인덱스 번호
    name varchar(255),
    addr varchar(255),
    tel varchar(20),
    email varchar(255),
    birthday date
) engine=InnoDB auto_increment=1 default charset=utf8mb4;

# 테이블 컬럼 추가
alter table contact add column age int;

# 테이블 확인
desc contact;

# 테이블 컬럼 삭제
alter table contact drop age;

# 테이블 기존 컬럼 이름, 자료형 변경 / change
alter table contact change tel phone int;
desc contact;

alter table contact change phone tel varchar(20);
desc contact;

# 자료형만 변경 / modify
alter table contact modify tel varchar(255);
desc contact;

# 테이블 컬럼 순서 조정 / modify
alter table contact modify column email varchar(255) after name;
desc contact;

# 테이블 삭제 / drop
-- drop table contact;

# DB 내부 테이블 확인 / show
show tables;


# 워크벤치로 테이블 생성해놓기
select * from students;

# 내용 추가
insert into students values 
	(null, '정서연', '2000-12-10', '서울', 'ISTJ'),
    (null, '권지훈', '2000-01-31', '서울', 'INTJ'),
    (null, '한민혁', '2000-09-29', '인천', 'ESFP');
    
insert into students (name, birthday, address, mbti) values
	('박진국', '2000-08-21', '서울', 'INFP'),
    ('성제현', '2000-12-05', '대구', 'ENFP');

select * from students;

# enum 타입 데이터 컬럼 추가
alter table students add column gender enum('남', '여');
select * from students;


# 제약 조건 null
create table tNullable (
	name char(10) not null,
    age int # null (생략 가능)
);

insert into tNullable (name, age) value ('흥부', 36);
insert into tNullable (name) value ('놀부');
insert into tNullable (age) value (44); # 기본값(name)이 없어서 입력되지 않음

select * from tNullable;


# default
create table tCityDefault (
	name char(10) primary key,
    area int not null default 0,
    popu int not null default 0,
    metro enum('y', 'n') not null default 'n',
    region char(6) null
);
desc tCityDefault;

insert into tCityDefault (name, area, popu, region) values 
	('진주', 712, 34, '경상');
insert into tCityDefault values 
	('인천', 1063, 295, 'y', '경기');
insert into tCityDefault values 
	('강릉', 131, 24, default, '강원'); # default를 지정해야
insert into tCityDefault (name) values 
	('군산'); # 미입력값은 기본값으로 들어감

select * from tCityDefault;


# check
create table tCheck (
	gender char(3) check(gender='남' or gender='여'),
    grade int check(grade between 1 and 3),
    origin char(3) check(origin in ('동', '서', '남', '북')),
    name char(12) check(name like '김%')
);

insert into tCheck values ('남자', 4, '동서', '홍길동');
insert into tCheck values ('남', 3, '동', '김길동');
select * from tCheck;


--
select * from tstaff;
desc tstaff;
create table tStaffDefault (
	name char(15) not null primary key,
    depart char(10) not null default '영업부' check(depart in('영업부', '총무부', '인사과')),
    gender char(3) not null check(gender='남' or gender='여'),
    # gender enum('남', '여'),
    joindate date not null default (curdate()),
    grade char(10) not null default '수습',
    salary int not null default '280' check(salary>0),
    score decimal(5, 2) not null default '1.0'
);

select * from tStaffDefault;
alter table tStaffDefault modify column joindate date after name;
insert into tStaffDefault (name, joindate, gender) values ('홍길동', '2024-01-01', '남');
select * from tStaffDefault;

select * from emp;
# 슈퍼키 : empno, ename / empno, ename 컬럼들과의 조합 컬럼
# 후보키 : empno, ename / 주민번호, 여권번호
# 기본키 : empno(ename보다 자주 참조), not null, 후보키 중에서 지정한 키(테이블에 오직 1개의 키 / 복합키 가능)

create table tStaffCompoKey (
	name char(15),
    depart char(10) not null default '영업부' check(depart in('영업부', '총무부', '인사과')),
    gender char(3) not null check(gender='남' or gender='여'),
    # gender enum('남', '여'),
    joindate date not null default (curdate()),
    grade char(10) not null default '수습',
    salary int not null default '280' check(salary>0),
    score decimal(5, 2) not null default '1.0',
    
    # (제약조건) 별도로 키 지정
    constraint ck_pk primary key (name, depart, gender)
);
desc tStaffCompoKey;

create table tPrimary (
	isLongHair bool check(isLongHair in (1,0)),
    isGlasses bool check(isGlasses in (1,0)),
    gender enum('남', '여'),
    
	constraint ct_pk primary key(isLongHair, isGlasses, gender)
);

insert into tPrimary values
(0,0,'남'),
(0,0,'여'),
(0,1,'남'),
(0,1,'여'),
(1,0,'남'),
(1,0,'여'),
(1,1,'남'),
(1,1,'여');

select * from tPrimary;

# auto_increment : 데이터 추가시 빈 칸이 아닌, 최신 데이터로 추가
create table tSale (
	saleno int auto_increment primary key,
    customer varchar(10),
    product varchar(30)
);

insert into tSale (customer, product) values
('단군', '지팡이'), ('고주몽', '고등어');

select * from tSale;
delete from tSale where saleno = 2;

insert into tSale (customer, product) values
('박혁거세', '계란'); # 3번으로 들어감
select * from tSale;

alter table tSale auto_increment = 1;
insert into tSale (customer, product) values
('고주몽', '고등어'); # 2번으로 들어가지 않고 마지막으로 들어감(3번을 삭제하고 생성시에는 2번으로 들어감)
select * from tSale;

alter table tSale auto_increment = 1000;
insert into tSale (customer, product) values
('궁예', '너구리');
select * from tSale;

# 최신 id의 내용 수정
select last_insert_id();
update tSale set product='짜파게티' where saleno = last_insert_id();
select * from tSale;


# 참조 무결성 : 테이블간 관계 설정 / join했는데, 특정 id를 삭제하는 상황
# 외래키 미설정 시
create table tEmployee (
	name char(10) primary key,
    salary int not null,
    addr varchar(30) not null
);

insert into tEmployee values 
('홍길동1', 650, '대구'), ('홍길동2', 480, '안산'), ('홍길동3', 625, '서울');
select * from tEmployee;

create table tProject (
	projectID int primary key,
    employee char(10) not null,
    project varchar(30) not null,
    cost int
);
insert into tProject values
(1, '홍길동1', '홍콩 수출건', 800),
(2, '홍길동1', 'TV 광고건', 3400),
(3, '홍길동1', '매출 분석건', 200),
(4, '홍길동2', '경영 혁신안 작성', 120),
(5, '홍길동2', '대리점 계획', 85),
(6, '홍길동3', '노조 협상건', 24);
select * from tProject;

-- join으로 대구 출신 직원이 진행중인 프로젝트
select * from tEmployee e join tProject p on e.name = p.employee where addr = '대구';

insert into tProject values (7, '임꺽정', '원자재 매입', 9000);
select * from tProject;

delete from tEmployee where name = '홍길동1';
select * from tProject;

drop table tEmployee;
drop table tProject;

#############
# 참조 무결성 : 외래키 설정하기 
create table tEmployee (
	name char(10) primary key,
    salary int not null,
    addr varchar(30) not null
);

insert into tEmployee values 
('홍길동1', 650, '대구'), ('홍길동2', 480, '안산'), ('홍길동3', 625, '서울');
select * from tEmployee;

# 외래키 설정 : employee
create table tProject (
	projectID int primary key,
    employee char(10) not null,
    project varchar(30) not null,
    cost int,
    
    constraint FK_employee foreign key(employee) references tEmployee(name)
);
insert into tProject values
(1, '홍길동1', '홍콩 수출건', 800),
(2, '홍길동1', 'TV 광고건', 3400),
(3, '홍길동1', '매출 분석건', 200),
(4, '홍길동2', '경영 혁신안 작성', 120),
(5, '홍길동2', '대리점 계획', 85),
(6, '홍길동3', '노조 협상건', 24);
select * from tProject;

# 무결성 유지(외래키로 연결 안 된 데이터 추가X 및 연결된 데이터 삭제X)
insert into tProject values (7, '임꺽정', '원자재 매입', 9000);
delete from tEmployee where name = '홍길동1';
select * from tProject;
select * from tEmployee;

























