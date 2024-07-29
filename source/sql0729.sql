use study_db;

select if(10>20, "참", "거짓");

select
	case 10
		when 1 then '일'
        when 5 then '오'
        when 10 then '십'
        else '모름' 
	end `10은 어디에`;
        
select *, 
	case grade
		when '사원' then 100
        when '대리' then 200
        else 300
	end `성과급`
	from tstaff;
        

# case문 : 조건에 따른 값을 지정
# 검색case, 단순case로 구문

-- select *,
-- 	case score
-- 		when null then 0 # null은 비교 불가
--         else score
--         end
--  from tstaff;

select *,
	case
		when score is null then 0.00
        else score
        end
 from tstaff;

select *,
	ifnull(score, 0)
 from tstaff;

# tstaff에서 성별컬럼 추가 gender가 남이면 1, 여면 2
select *,
	case gender
		when '남' then 1
        when '여' then 2
        else '0' # 데이터 타입 일치시켜주는 것이 좋음
        end `성별`
 from tstaff;

select * from tstaff
where
	case grade
		when '사원' then 1
		when '대리' then 2
		when '차장' then 3
		when '과장' then 4
		when '부장' then 5
		when '이사' then 6
#	end in (1, 6);
    end between 3 and 6;

-- grade별 각 번호 지정해서 정렬
select * from tstaff
order by
case grade
		when '사원' then 1
		when '대리' then 2
		when '차장' then 3
		when '과장' then 4
		when '부장' then 5
		when '이사' then 6
	end desc, # 2번째 조건을 위해 end,
    salary; # grade 기준 내림차순, salary 기준 오름차순
    
# group by - 그룹화
select grade, 
	truncate(avg(salary), 1), 
    sum(salary),
    count(*) `직급별 직원 수` # null이 있는 경우 집계되지 않으므로 *
from tstaff group by grade;

# 그룹화할 때는 2개 이상의 컬럼 지정도 가능
select depart, concat(count(*), ' 명') `부서, 성별에 따른 직원수`, gender
from tstaff
group by depart, gender
order by depart, gender;

# 문자열 데이터의 합계 = 0으로 나옴. min, max는 출력됨(사전식 정렬을 통한 값)
select sum(grade), max(grade), min(grade) from tstaff
group by depart;

# 날짜는 max가 막내
select addr, sum(mdate), max(mdate), min(mdate), count(*)
from usertbl
group by addr;

-- tstaff
select count(grade) from tstaff;
select count(*) from tstaff where salary>=400;
select grade, count(*) from tstaff group by grade;
select grade, avg(salary) from tstaff where grade != '이사' group by grade; # not in ("이사")
select count(distinct(grade)) from tstaff;
select count(*) from tstaff where score is null;
select count(*) - count(score) from tstaff;
select depart, avg(salary) from tstaff where depart = '인사과';

-- tcity
select sum(popu), avg(popu), min(area), max(area) from tcity;

-- emp
select * from emp;
select count(*), max(sal), min(sal), avg(sal) from emp;
select job, count(*), max(sal), min(sal), avg(sal) from emp group by job;
select job, max(sal) - min(sal) `급여차` from emp group by job;
select max(sal) - min(sal) from emp;

# having : 그룹화 조건
select depart, avg(salary) from tstaff
group by depart having avg(salary) >= 350;


# 2개 이상 테이블로부터 데이터 추출
select * from dept;
select * from emp order by DEPTNO;

# union : 합집합
select deptno from dept
union # 중복 제거 합집합
select deptno from emp;

select deptno from dept
union all # 중복 포함 합집합
select deptno from emp;

# intersect : 교집합
select deptno from emp
intersect # 교집합
select deptno from dept;

# minus(except) : 차집합(순서가 중요)
select deptno from dept
except
select deptno from emp;


# 서브 쿼리
select * from emp;
select * from dept;
select * from dept where deptno = (select deptno from emp where ename ='smith');
select * from dept 
	where deptno in 
    (select deptno from emp where ename in ('smith', 'allen'));


select * from tcity;
select name from tcity where popu =
	(select max(popu) from tcity);

# 단일 행 서브 쿼리
select * from emp;
select avg(sal) from emp;
select * from emp where sal >= (select avg(sal) from emp);
select * from emp where deptno = (select deptno from emp where ename = 'miller');
select * from emp where job = (select job from emp where ename = 'miller');
select * from emp where sal >= (select sal from emp where ename = 'miller');

select * from emp;
select * from dept;
select * from emp where deptno = (select deptno from dept where loc = 'dallas');
select * from emp where mgr = (select empno from emp where ename = 'king');


select * from tstaff;
select depart from tstaff where name = '안중근';
select gender from tstaff where name = '안중근';
# 다중 열 서브 쿼리 (서브쿼리 결과가 한 줄, 여러 개 열)
select * from tstaff where (depart, gender) =
	(select depart, gender from tstaff where name = '안중근');
	
# 다중 행 서브 쿼리 (서브쿼리 결과가 여러 줄)
select * from dept where deptno in (20, 30);

# in : 서브쿼리 결과 중 하나라도 일치하면 참
-- emp에서 부서별로 가장 급여를 많이 많는 사원들과 같은 급여를 받는 사원
# select * from emp where sal in (5000, 3000, 2850);
select * from emp where sal in
 (select max(sal) from emp group by deptno);

# all : 서브쿼리 결과가 모두 일치해야 참(max가 더 편하긴 함)
select * from emp;
select * from emp where sal > all
	(select sal from emp where deptno = 30);
select * from emp where sal > 
	(select max(sal) from emp where deptno = 30);

# any, some # min()과 같음
# 하나라도 해당되면 모두 조회
select * from emp where sal > any
	(select sal from emp where deptno = 30);
select * from emp where sal >
	(select min(sal) from emp where deptno = 30);

# exists : 데이터 존재 여부
# sal이 2000 넘는 직원이 존재하면, 모든 직원 조회
select * from emp where exists
	(select * from emp where sal > 2000); 


--
select * from emp;
select * from dept;

select * from emp where sal in (select max(sal) from emp group by deptno);

select * from emp where deptno in (
select distinct deptno from emp where sal >= 3000);

select * from dept where deptno in (
select distinct deptno from emp where job = 'manager');

select * from emp where deptno = (
select deptno from emp where ename = 'blake');

select * from emp where sal >= (
select avg(sal) from emp) order by sal desc;

select * from emp where deptno in (
select distinct deptno from emp where ename like '%T%') order by empno;

select * from dept;
select * from emp where deptno in (
select deptno from dept where loc = 'dallas');

select * from emp where mgr = 
(select empno from emp where ename = 'king');


# Join : 2개 이상의 테이블을 엮음
# cross join : 모든 집합 (A 행 개수 * B 행 개수 : 카티션 곱)
select * from tcar;
select * from tmaker;
select * from tcar, tmaker;
select * from tcar cross join tmaker;

select c.*, m.maker from tcar `c` cross join tmaker `m`;
select * from tcar, tmaker where tcar.maker = tmaker.maker;

# join에서 별명을 붙였으면, where절에서 반드시 별명만 사용 가능
select * from tcar c cross join tmaker m where c.maker = m.maker;


# inner join ( ON ) : inner 생략 가능 
select * from tcar, tmaker where tcar.maker = tmaker.maker;
select * from tcar inner join tmaker on tcar.maker = tmaker.maker;
select * from tcar c inner join tmaker m on c.maker = m.maker; # 별명으로


# natural join (문법)
select * from tcar join tmaker using (maker);
select * from tcar natural join tmaker;


# self join (구조)
select concat(e.ename, "의 매니저 : ", m.ename) from emp e, emp m where e.mgr = m.empno;
select concat(e.ename, "의 매니저 : ", m.ename) from emp e join emp m on e.mgr = m.empno;

--
select * from dept;
select * from emp;
select ename, sal, deptno from emp where deptno = (
select distinct deptno from dept where loc = 'new york');

select emp.ename, emp.sal from emp
join dept on emp.deptno = dept.deptno
where loc = 'new york';

select ename, HIREDATE from emp join dept on emp.deptno = dept.deptno where dept.dname = 'accounting';

select * from emp join dept on emp.deptno = dept.deptno where emp.job = 'manager';

select * from emp;
select * from salgrade;
select ename, sal, grade from emp e join salgrade s on e.sal > s.losal and e.sal < s.hisal;
select ename, sal, grade from emp e join salgrade s on e.sal between s.losal and s.hisal;

select e.ename, e.job from emp e join emp m on e.mgr = m.empno where m.ename = 'king';

# inner join : (내부) 기본 조인. 두 테이블에 모두 지정한 열의 데이터가 있어야 함.
# outter join : 외부 조인. 최소한에 한쪽 테이블에 데이터가 있어야 함. 
# cross join : 상호 조인. 한 테이블에 다른 테이블의 모든 행을 교차곱(카티션 곱)
# self join : 자체 조인. 

select concat(e.ename, "의 매니저 : ", m.ename) from emp e
right join emp m on e.mgr = m.empno;

select concat(e.ename, "의 매니저 : ", m.ename) from emp e
left join emp m on e.mgr = m.empno;

# outer join
	# left (outer) join : 왼쪽 테이블의 모든 값 출력
    # right (outer) join : 오른쪽 테이블 모든 값 출력
    # (MySql 미지원) full outer join : 왼쪽 또는 오른쪽 테이블의 모든 값 출력

select * from emp e
left join emp m on e.mgr = m.empno;

select * from emp e
right join emp m on e.mgr = m.empno;


select * from tcar left join tmaker on tcar.maker = tmaker.maker;
# union # outer join
select * from tcar right join tmaker on tcar.maker = tmaker.maker;


# 다중 조인 : 테이블을 계속 중첩
select * from tcar;
select * from tmaker;
select car, c.maker, metro from tcar c
join tmaker m on c.maker = m.maker
join tcity ct on m.factory = ct.name;

select * from emp;
select * from dept;
select ename, d.deptno, dname from dept d left join emp e on e.deptno = d.deptno;
select * from emp e join dept d on e.deptno = d.deptno where d.loc = 'new york';
select * from emp e join dept d on e.deptno = d.deptno where e.comm is not null;    
select ename, job, dname, loc from emp e join dept d on e.deptno = d.deptno where e.ename like '%L%';

select * from emp;
select e.ename, e.hiredate, h.ename `관리자`, h.hiredate from emp e join emp h 
on e.mgr = h.empno where e.hiredate < h.hiredate;

insert into tcity values('강릉', 1040, 21, 'N', '강원');
insert into tcity (name, area, popu, metro, region) values('원주', 867, 35, 'y', '강원');
select * from tcity;

delete from tcity;
select * from tcity;

insert into tcity (name, area, popu, metro, region) values
('서울', 605, 974, 'y', '경기'),
('부산', 765, 342, 'y', '경상'),
('오산', 42, 21, 'n', '경기'),
('전주', 205, 65, 'n', '전라'),
('순천', 910, 27, 'n', '전라'),
('춘천', 1116, 27, 'n', '강원'),
('홍천', 1819, 7, 'n', '강원');
select * from tcity;

insert into tcity
values ('이천', 461, 21, 'n', '경기'), ('대구', 883, 248, 'y', '경상'), ('영월', 1127, 4, 'n', '강원');

insert into tcity 
(select factory, 940, 83, 'n', '충청' from tmaker where maker= '쌍용');

select * from tcity;

# delete from ~ where 로 일부만 삭제 가능
delete from tcity where name = '부산';
delete from tcity where region = '경기';
delete from tcity where popu > 50;
select * from tcity;

-- 영업부 직원 전부 삭제
select * from tstaff;
delete from tstaff where depart = '영업부';
select * from tstaff;

# update 테이블 set
update tcity set popu=1000, region='충청' where name = '서울';
select * from tcity;
update tcity set popu=popu*2 where name='오산';
select * from tcity;

select * from tstaff;
update tstaff set grade='차장' where gender = '여';
select * from tstaff;
update tstaff set salary=salary*1.1 where depart = '총무부'; # 자동으로 반올림
select * from tstaff where depart = '총무부';






















