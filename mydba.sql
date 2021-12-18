--drop table sequence--
DROP TABLE used;
DROP TABLE material;
DROP TABLE joins;
DROP TABLE employee;
DROP TABLE department;
DROP TABLE project;
DROP TABLE team ;
DROP TABLE company;

--create tables sequence--

create table company
(id_comp integer not null PRIMARY KEY,
name_comp VARCHAR2(35) not null,
telphone VARCHAR2(15),
email VARCHAR2(20),
address VARCHAR2(25)
);

create table team
(id_team integer not null PRIMARY KEY,
name VARCHAR2(30) not null,
speciality VARCHAR2(50)
);

create table project
( id_proj  integer not null PRIMARY KEY,
id_comp integer not null,
id_team integer not null,
name_proj VARCHAR2(50) not null,
budget FLOAT not null,
begin_date DATE,
end_date DATE,
foreign key (id_comp) references company(id_comp),
foreign key (id_team) references team(id_team)
);

create table department
( id_dept integer not null PRIMARY KEY,
name_dept VARCHAR2(100) not null
);

create table employee
(id_emp integer not null PRIMARY KEY,
id_dept integer,
first_name VARCHAR2(20) not null,
last_name VARCHAR2(20) not null,
gender CHAR(1),
date_of_birth DATE,
salary FLOAT not null,
function VARCHAR2(20) not null,
supervisor VARCHAR2(20) not null,
foreign key (id_dept) references department(id_dept)
);

create table joins
( id_emp integer not null,
id_team integer not null,
join_date DATE,
leave_date DATE,
foreign key (id_emp) references employee(id_emp),
foreign key (id_team) references team(id_team),
primary key(id_emp,id_team)
);

create table material
(id_mat INTEGER not null PRIMARY KEY,
name_mat VARCHAR2(30) not null,
description VARCHAR2(50)
);

create table used
(id_emp integer not null,
id_mat integer not null,
begin_date DATE,
end_date DATE,
foreign key(id_emp) references employee(id_emp),
foreign key(id_mat) references material(id_mat),
primary key(id_emp,id_mat)
);

--insert values--
insert into department values(1,'cst2');
insert into department values(2,'cst1');
insert into department values(3,'cst3');

insert into employee values(1,1,'Irfan','morshed','M','20-dec-2021',1000.50,'developer','Dr.Francis');
insert into employee values(2,2,'morshed','Irfan','M','10-dec-2020',700.50,'developer','Dr.Francis');
insert into employee values(3,2,'Irf','mor','M','20-dec-2019',400.50,'developer','Dr.Francis');
insert into employee values(4,3,'mor','irf','M','20-dec-2018',600.50,'developer','Dr.Francis');
insert into employee values(5,3,'Xi','Jinping','M','15-jun-1953',600.50,'developer','Dr.Francis');
insert into employee values(6,3,'Liu','Yifei','F','25-AUG-1987',9000.50,'model','Dr.Francis');

insert into team values(1,'Team Jupiter',null);
insert into team values(2,'Team Mars',null);

insert into joins values(1,1,null,null);
insert into joins values(2,2,null,null);

insert into company values(1,'XPACE',null,null,null);
insert into company values(2,'SPACE-X',null,null,null);
insert into company values(3,'NUIST',null,null,null);

insert into project values(1,1,1,'Cypher',5000.50,null,null);
insert into project values(2,1,1,'Apollo',5000.50,'20-dec-2020','20-dec-2022');
insert into project values(3,2,2,'MARS',500000.50,'20-dec-2018','20-dec-2030');


insert into material values(1,'Telescope',null);
insert into material values(2,'Laptop',null);

insert into used values(1,1,null,null);
insert into used values(2,1,null,null);



--query 1--

SELECT
    id_emp,(first_name||' '||last_name) as full_name, salary
FROM employee
WHERE salary = (Select MAX(salary) From employee);

--query 2--
SELECT
    e.id_emp,e.first_name,d.name_dept
FROM
   employee e, department d, team t, joins j
WHERE d.id_dept=e.id_dept
and e.id_emp=j.id_emp
and j.id_team=t.id_team
and name='Team Jupiter';

--query 3--

SELECT
    d.name_dept, avg(e.salary)
FROM
   department d, employee e
WHERE d.id_dept = e.id_dept
GROUP BY d.name_dept;

--query 4--

SELECT
    c.name_comp, p.name_proj, concat(e.first_name,e.last_name) as employee_name, d.name_dept
FROM
   company c, project p, joins j, employee e, department d
WHERE d.id_dept=e.id_dept
and e.id_emp=j.id_emp
and j.id_team=p.id_team
and p.id_comp=c.id_comp 
and p.name_proj='Cypher';

--query 5--

SELECT
    (first_name||' '||last_name)as All_employeeName_over50
FROM
    employee
WHERE current_date- date_of_birth>(50*365);

--query 6--

SELECT
    *
FROM
 employee
WHERE id_emp not in (select Distinct(id_team)from team);

--query 7--

SELECT
    *
FROM
  employee
inner join used
on employee.id_emp= used.id_emp
inner join material
on used.id_mat=material.id_mat
WHERE material.name_mat='Telescope';

--query 8--

SELECT
    t.name, p.name_proj, c.name_comp, p.begin_date as start_date
FROM
   team t, project p, company c
WHERE
  t.id_team=p.id_team
and p.id_comp=c.id_comp
and p.end_date>current_date; --ongoing project--


--query 9--

SELECT
    concat(first_name,last_name) as employees_name, supervisor as supervisor_name
FROM
   employee
WHERE gender = 'M'; --qus mentioned 'his'--

--query 10--

SELECT
    *
FROM
  employee e
WHERE id_emp in 
(SELECT DISTINCT(id_team) 
FROM project p, company c 
WHERE p.id_comp=c.id_comp 
and c.name_comp='XPACE');

--end--