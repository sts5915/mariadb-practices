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
-- 실습문제3) 현재 급여가 50000이상인 직원의 이름과 급여를 출력하세요.
-- sol1 join
  select a.first_name, b.salary
    from employees a, salaries b
   where a.emp_no = b.emp_no
     and b.to_date = '9999-01-01'
     and b.salary >= 50000
order by b.salary asc;

-- sol2 subquery
