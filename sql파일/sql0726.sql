# 테이블 데이터 조회
select * from emp;
select * from tcity;


# 테이블 열 이름으로 조회
select job from emp;
select ename, job from emp;
select name, area, popu from tcity;


# 테이블 중복 제거
select distinct job from emp;


# 테이블 구조, 속성 파악 Describe (info ? )
desc tcity; # char : 고정된 길이의 문자열
desc emp; # varchar : 가변 길이 문자열 - 데이터 크기에 맞춰 저장공간 크기가 변경
# integer 에 int 포함


-- practice
select region, name, area from tcity;
# alias : as 별명 / 별명에 공백, 특문, 대문자, 한글인 경우 백틱 ` ` 권장
select region as a, popu `인구(만명)`, area c from tcity; # 컬럼명 alias로 출력

select name as `도시명`, popu `인구` from tcity where metro='n';

# 산술 표현식(from 외 전부 가능)
select name `도시명`, popu * 10000 `인구` from tcity;
select * from tcity where popu = 300 + 42;
select 1+2+3+4+5 as `5까지합계`;

-- tcity 테이블에서 name, area, popu, 인구밀도 조회
-- 인구밀도는 인구수를 면적으로 나눈 값
select name, area, popu, popu/area as `인구밀도` from tcity;

-- 1년은 몇 초인가
select 365 * 24 * 60 * 60 as `1년은 몇 초인가`;


# 컬럼 연결(Concatenate) : concat(arg1, arg2, arg3, ...)
select concat("홍길동", "은", "천재") `명언`;
select concat(name, " ", grade) `직원` from tstaff;

# distinct 중복 제거
select distinct region from tcity;

# 정렬 (order by)
select * from tcity order by region;
select * from tcity order by area;
select * from tcity order by popu desc;
select * from tcity order by popu desc, region asc;
select * from tcity order by 5, 1 desc; # 5번째열 (region) 오름차순, 1번쨰열(name) 내림차순
select name `도시명`, popu `인구` from tcity order by `인구` desc; # popu로 해도 됨

-- tstaff에서 salary가 적은 사람부터, 같다면 score가 높은 사람 먼저 조회
select * from tstaff;
select * from tstaff order by salary asc, score desc; # score: null인 경우 

-- tcity에서 metro가 n인 데이터(name, popu컬럼만) 인구수 내림차순
select name, popu from tcity where metro='n' order by popu desc;

-- tstaff에서 joindate가 2015 이전 데이터(name, depart, grade)
select * from tstaff;
select name, depart, grade from tstaff where joindate<'2015-01-01';

# null 비교는 is, is not null
select * from tstaff where score is null;

# 논리 연산자 
select * from logic_operation; 
select a, b, `and` from logic_operation where a=1 and b=1; # and
select a, b, `or` from logic_operation where a=1 or b=1; # or
select a from logic_operation where not a=1; # a가 1이 아닌것

-- or, not으로 and
select a, b, `and` from logic_operation where not (a=0 or b=0);

-- and와 not으로 or
select a, b, `or` from logic_operation where not (a=0 and b=0);


-- tstaff에서 salary 300미만, score 60이상
select * from tstaff where salary<300 and score>=60;

-- tstaff에서 인사과 남자 직원과 영업부 여자 직원
select * from tstaff where (depart='인사과' and gender="남") or (depart='영업부' and gender="여");

# like : _ _ 개수에 따라 / % 개수 상관X
select * from tstaff where name like '김%'; 

-- 
select * from emp where ename like '%T%';
select * from emp where not ename like '%T%';
select * from emp where ename like '%T';
select * from emp where ename like 'T%';
select * from promotion_tbl where promotion_msg like '%30\%%';

# between ~ and 
select * from tcity where popu between 50 and 100;
select * from tcity where popu >= 50 and popu <= 100;

select * from tstaff where name between '가' and '사';
select * from tstaff where joindate between '20150101' and '20180101';

select * from tcity where region in ('경상', '전라');
select * from tcity where region='경상' or region='전라';

--
select * from tcity where area between 500 and 1000;
select * from tcity where region not in ('경상', '전라');
# select * from tcity where region != '경상' and region != '전라';
select * from tstaff where name like '이%' or name like '안%';
select * from tstaff where depart='총무부' or depart='영업부';
# select * from tstaff where depart in ('총무부', '영업부');
select * from tstaff where (depart='총무부' or depart='영업부') and grade='대리';
# select * from tstaff where depart in ('총무부', '영업부') and grade='대리'

# 행 개수 제한 : limit 건너뛸 개수, 조회할 개수
select * from tcity order by area desc limit 0, 4;

--
select * from tstaff order by salary desc limit 5;
select * from tcity order by area desc limit 2, 3;
# select * from tcity order by area desc limit 3 offset 2;
select * from tstaff order by salary desc limit 11, 5;


# where 에서 연산
select * from tcity where (popu*10000/area) < 1000;
select *, (popu*10000/area)<1000 `인구밀도` from tcity where (popu*10000/area)<1000; # where 에 별명이 나오면 인식 못함

# order by 연산
select *, popu*10000/area `인구밀도` from tcity order by `인구밀도` desc;

# null과의 연산은 모두 null
select null*1, null+1, null-1, null/1, 1-null, 1/null;
select null*null, null+null, null-null, null/null;

# 산술 함수
select 10%3 `연산자 나머지 연산`, mod(10,3) `함수 나머지 연산`, round(10.5), round(3.1415926, 3), round(3141.5926, -3); # 나머지, 반올림
select truncate(3.1415926, 3), truncate(3145.926, -1); # 버림

select * from tstaff;
select score, (truncate(score, 0)%2) `홀짝` from tstaff;
select score, mod(truncate(score, 0), 2) `홀짝` from tstaff;
select score, mod(floor(score), 2) `홀짝` from tstaff;

select * from emp;
select *, mod(empno, 2) `홀수` from emp where mod(empno, 2)=1;
select *, round(score) `반올림` from tstaff; # score만 제외할 수는 없는듯 ㅠㅠ


# 문자 관련 함수
select concat('안녕하세요.                    ', '반갑습니다.');
select productname, concat(price, "개") `개당 가격` , concat(amount, "개") `구매 수량`, concat(price*amount, "원") `가격` from buytbl;

select name, concat(floor(length(name)/3), "글자") from usertbl;
select HIREDATE, substring(hiredate, 1, 4) `연도`, substring(hiredate, 6, 2) `월` from emp;

# 날짜
select current_time() + interval 3600 second + interval 60 minute;
select current_date();
select current_timestamp();

select adddate(curtime(), interval 1 hour);
select subdate(curtime(), interval 1 hour);

select current_date() - interval 365 day;
select current_date() - interval 1 year;
select adddate(curdate(), interval 1 year);
select subdate(curdate(), interval 1 year);

-- 오늘 까지 입사 후 며칠인지
select * from tstaff;
select joindate, current_date(), datediff(curdate(), joindate) `근무 일수` from tstaff;

-- 만 나이 조회
select * from usertbl;
select *, year(curdate())-birthyear - (right(curdate(), 5) < right(mdate, 5)) `만 나이` from usertbl;

--
select *, if(salary>=300, salary*0.3, salary*0.5) `성과급` from tstaff order by `성과급` desc;
select *, if(grade='사원', 100, if(grade='대리', 200, 300)) `성과급` from tstaff order by `성과급` desc;

# sum은 집계라서 * 사용 불가
select sum(popu) `인구합` from tcity where region='전라';

select * from tstaff order by depart desc;
select count(depart) `영업부 직원수` from tstaff where depart='영업부';
select * from emp where sal between 3000 and 4000;
select * from buytbl;
select * from buytbl where productname="운동화";

select * from tcar where price>=3000;
select * from usertbl where birthyear between 1990 and 1999;






