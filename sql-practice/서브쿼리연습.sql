-- subquery
-- 1) select 절
-- 2) from 절의 서브쿼리
select now() as a, sysdate() as b, 3+1 as c;

select s.a, s.b, s.c
	from (select now() as a, sysdate() as b, 3+1 as c) s;
    
-- 3) where절의 서브쿼리
-- 예제) 현재, Fai Bale이 근무하는 부서의 직원들의 사번, 이름을 출력하세요

select dept_no
	from dept_emp a, employees b
    where a.emp_no = b.emp_no
    and a.to_date = '9999-01-01'
    and concat(first_name,' ', last_name) = 'Fai Bale';
    
select a.emp_no, b.first_name
	from dept_emp a, employees b
    where a.emp_no = b.emp_no
    and a.to_date = '9999-01-01'
    and a.dept_no = 'd004';
    
-- sol)
select a.emp_no, b.first_name
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and a.to_date = '9999-01-01'
   and a.dept_no = (select dept_no
					  from dept_emp a, employees b
					 where a.emp_no = b.emp_no
					   and a.to_date = '9999-01-01'
					   and concat(first_name,' ', last_name) = 'Fai Bale');

-- 3-1) 단일행 연산자 : =, !=, >, <, <=, >=
-- 실습문제1:
-- 현재, 전체사원의 평균연봉 보다 적은 급여를 받고 있는 사원의 이름, 급여를 출력하세요
select avg(salary) from salaries where to_date = '9999-01-01';

-- 72012.2359
select a.first_name, b.salary
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and b.salary <  (select avg(salary) 
				      from salaries 
					 where to_date = '9999-01-01')
order by b.salary desc;

-- 실습문제2 : 현재, 가장 적은 직책별 평균급여를 받고 있는 직책과 그 평균급여를 출력하세요
-- 1)현재 가장 적은 직책별 평균급여
-- 1-1)직책별 평균급여
  select a.title, avg(b.salary) as avg_salary
    from titles a, salaries b
   where a.emp_no = b.emp_no
     and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by a.title;
-- 1-2) 가장 적은 직책별 평균급여
select min(a.avg_salary)
from (select a.title, avg(b.salary) as avg_salary
        from titles a, salaries b
       where a.emp_no = b.emp_no
         and a.to_date = '9999-01-01'
         and b.to_date = '9999-01-01'
    group by a.title)a;
-- 2-1) sol 1
  select a.title, avg(b.salary) as avg_salary
    from titles a, salaries b
   where a.emp_no = b.emp_no
     and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by a.title
  having avg_salary = (select min(a.avg_salary)
                         from (select a.title, avg(b.salary) as avg_salary
                                 from titles a, salaries b
                                where a.emp_no = b.emp_no
                                  and a.to_date = '9999-01-01'
                                  and b.to_date = '9999-01-01'
							 group by a.title)a);
-- 2-2) sol2: top-k
 select a.title, avg(b.salary) as avg_salary
    from titles a, salaries b
   where a.emp_no = b.emp_no
     and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by a.title
order by avg_salary asc
   limit 0, 1;

-- 3-2) 복수행 연산자 : in, not in, any, all
-- any 사용법
-- 1.=any : in과 동일
-- 2. >any , >=any : 최소값
-- 3. <any , <=any : 최대값
-- 4. <>any : not in과 동일

-- all 사용법
-- 1. =all : 논리모순 x
-- 2. >all, >=all : 최대값
-- 3. <all, <=all : 최소값
-- 4. <>all : 쓸 수있다 
-- 실습문제3) 현재 급여가 50000이상인 직원의 이름과 급여를 출력하세요.
-- sol1 join
  select a.first_name, b.salary
    from employees a, salaries b
   where a.emp_no = b.emp_no
     and b.to_date = '9999-01-01'
     and b.salary >= 50000
order by b.salary asc;

-- sol2 subquery
  select a.first_name, b.salary
    from employees a, salaries b
   where a.emp_no = b.emp_no
     and b.to_date = '9999-01-01'
     and (a.emp_no, b.salary) in (select emp_no, salary      -- in =  =any 쓰는거랑 같다
                                    from salaries
								   where to_date = '9999-01-01'
                                     and salary >= 50000)
   order by b.salary asc;

-- 실습문제 4 : 현재, 각 부서별로 최고 월급을 받는 직원의 이름, 부서, 월급을 출력하세요.
-- 나의 풀이 (틀린듯? 결과가 나오긴 하는데 정답이 밑에 풀이와 다르고 정렬을 시켰는데 정렬이 안됨)
  select a.first_name, d.dept_name, max(b.salary)
    from employees a, salaries b, dept_emp c, departments d
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
     and c.dept_no = d.dept_no
     and b.to_date = '9999-01-01'
     and c.to_date = '9999-01-01'
group by d.dept_name
order by b.salary desc;

-- sol
select a.dept_no, max(b.salary) as max_salary
from dept_emp a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.dept_no;

-- sol1) where절 subquery
select a.dept_name, c.first_name, d.salary
  from departments a, dept_emp b, employees c, salaries d
 where a.dept_no = b.dept_no
   and b.emp_no = c.emp_no
   and c.emp_no = d.emp_no
   and b.to_date = '9999-01-01'
   and d.to_date = '9999-01-01'
   and (a.dept_no, d.salary) in (select a.dept_no, max(b.salary) as max_salary
                                   from dept_emp a, salaries b
                                  where a.emp_no = b.emp_no
                                    and a.to_date = '9999-01-01'
                                    and b.to_date = '9999-01-01'
							   group by a.dept_no)
order by d.salary desc;

-- sol2) from절 subquery
select a.dept_name, c.first_name, d.salary
  from departments a, 
       dept_emp b, 
       employees c, 
       salaries d,
       (select a.dept_no, max(b.salary) as max_salary 
          from dept_emp a, salaries b
		 where a.emp_no = b.emp_no
		   and a.to_date = '9999-01-01'
		   and b.to_date = '9999-01-01'
	  group by a.dept_no) e
 where a.dept_no = b.dept_no
   and b.emp_no = c.emp_no
   and c.emp_no = d.emp_no
   and e.dept_no = a.dept_no
   and b.to_date = '9999-01-01'
   and d.to_date = '9999-01-01'
   and e.max_salary = d.salary;

   
   
   
   
   
   
   