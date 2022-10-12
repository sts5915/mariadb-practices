show tables;

select *
	from departments;
select dept_no, dept_name from departments;

-- alias(as 생략 가능)
-- 예제 1: employees 테이블에서 직원이 이름, 성별, 입사일을 출력

select first_name as '이름', gender as '성별', hire_date as '입사일' from employees;

-- 예제 2: employees 테이블에서 직원이 이름, 성별, 입사일을 출력, concat 함수 사용
select concat( first_name,'', last_name) as '이름', gender as '성별', hire_date as '입사일' from employees;

select concat('hell', '','world');

-- distinct
-- 예제 : title 테이블에서 모든 직급의 이름 출력
select distinct title from titles;

-- where절 #1
-- 예제 : employees 테이블에서 1991년 이전에 입사한 직원이 이름, 성별 , 입사일을 출력
select first_name, gender, hire_date
	from employees
   where hire_date < '1991-01-01';
   
-- where 절 #2 : 논리 연산자
-- 예제 : employees 테이블에서 1989년 이전에 입사한 여직원이 이름, 성별, 입사일을 출력
select first_name, gender, hire_date
	from employees
   where hire_date < '1989-01-01'
     and gender='f';
     
-- where 절 #3 : in 연산자
select emp_no, dept_no
	from dept_emp
   where dept_no in('d005', 'd009');
   
-- where절 #4 like 검색
-- 예제 : employees 테이블에서 1989년에 입사한 직원의 이름, 입사일을 출력
select first_name, hire_date
	from employees
   where '1989-01-01'<= hire_date
     and hire_date <= '1989-12-31';
select first_name, hire_date
	from employees
   where hire_date like '1989%';
select first_name, hire_date
	from employees
   where hire_date between '1989-01-01' and '1989-12-31';
   
-- 예제2 : 남자 직원의 이름, 성별, 입사일을 입사일순(선임순)으로 출력
select first_name, gender, hire_date
	from employees
   where gender='m'
order by hire_date;

-- 예제 3 직원들의 사번, 월급을 사번(asc), 월급순(desc)으로 출력하세요
select emp_no, salary
	from salaries
order by emp_no asc, salary desc;

     





   