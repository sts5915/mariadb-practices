create database employees;
show databases;

create user 'hr'@'localhost' identified by 'hr';

grant all privileges on employees.* to 'hr'@'localhost';
flush privileges;