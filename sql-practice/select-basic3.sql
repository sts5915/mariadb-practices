-- 함수 : 날짜 함수

-- curdate(), current_date 날짜
select curdate(), current_date;

-- curtime(), current_time 시간
select curtime(), current_time;

-- now() 날짜 시간 둘다  vs sysdate()
select now(), sysdate();
select now(), sleep(2), sysdate();

-- date_format()
-- 2022년 10월 13일 10:12:55
select date_format(now(), '%y년 %m월 %d일 %h:%i:%s');

-- period_diff
-- 포맷팅: YYMM YYYYMM
-- 예) 근무 개월 수
select emp_no, 
	 period_diff(date_format(curdate(), '%Y%M'), date_format(hire_date, '%Y%M')) as month
     from employees
order by month;

-- date_add(=adddate), date_sub(=subdate)
-- 날짜를 date에 type(year, month, day)의 표현식을 더하거나 뺀다
-- 예제) 각 사원들의 근속년 수가 5년이 되는 날은 언제인가요?
select first_name,
	   hire_date,
       date_add(hire_date, interval 5 year)
	from employees;