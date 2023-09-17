CREATE DATABASE "University";

CREATE TABLE "department" (
	dept_name VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
	building VARCHAR(30) NOT NULL,
	budget BIGINT NOT NULL CHECK(budget >= 0) DEFAULT 0
);

INSERT INTO "department" (dept_name, building, budget)
VALUES  ('CSE' , 'CSE-1', 10000000),
		('EEE' , 'EEE-1', 10000000),
		('CCE' , 'CCE-1', 10000000),
		('CIVIL' , 'CIVIL-1', 10000000);

select * from department


CREATE TABLE "course" (
	course_code VARCHAR(10) NOT NULL UNIQUE PRIMARY KEY,
	title VARCHAR(60) UNIQUE NOT NULL,
	dept_name VARCHAR(50) NOT NULL REFERENCES department(dept_name),
	credit FLOAT NOT NULL 
);

INSERT INTO "course" (course_code , title , dept_name , credit)
VALUES
	('CSE-1121' , 'Computer Programmig-1' , 'CSE' , 3),
	('CSE-1122' , 'Computer Programmig-1 Lab' , 'CSE' , 1.5),
	('EEE-1101' , 'Electrical Circuits-1' , 'EEE' , 3),
	('EEE-1102' , 'Electrical Circuits-1 sessional' , 'EEE' , 1.5),
	('CE-1100' , 'Civil Engineering Drawing and Digital Drafting' , 'CIVIL' , 1.5),
	('CE-1103' , 'Surveying' , 'CIVIL' , 3);
		

SELECT * FROM course
	
		

CREATE TABLE "instructor" (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	dept_name VARCHAR(50) NOT NULL REFERENCES department(dept_name),
	salary BIGINT NOT NULL CHECK(salary >= 0) DEFAULT 0
);

INSERT INTO "instructor"(id , name , dept_name , salary)
values
	(1 , 'TA' , 'CSE' , 70000),
	(2 , 'Akash' , 'CSE' , 50000),
	(3 , 'NM' , 'CSE' , 50000),
	(4 , 'JAA' , 'EEE' , 50000),
	(5 , 'YA' , 'EEE' , 70000),
    (6 , 'AB' , 'CIVIL' , 50000),
	(7 , 'CD' , 'CIVIL' , 70000);
	
select *from instructor

CREATE TABLE "section" (
	course_code VARCHAR(10) NOT NULL UNIQUE REFERENCES course(course_code),
	sec_id VARCHAR(10) NOT NULL PRIMARY KEY,
	semester VARCHAR(10) NOT NULL,
	year INT NOT NULL,
	building VARCHAR(30) NOT NULL,
	room_number INT NOT NULL,
	time_slot_id TIME NOT NULL
);

insert into section(course_code,sec_id,semester,year,building,room_number,time_slot_id)
values
	('EEE-1101','s1','1st','2023','Academic-2','101','11:00:00'),
	('EEE-1102','s3','1st','2023','Academic-2','103','11:00:00'),
	('CE-1100','s5','2nd','2023','Academic-3','101','11:00:00'),
	('CE-1103','s7','3rd','2023','Academic-3','103','11:00:00'),
	('CSE-1121','s9','1st','2023','Academic-1','101','11:00:00'),
	('CSE-1122','s12','1st','2023','Academic-1','104','11:40:00');
	
UPDATE section
SET building = 'EEE-1'
WHERE sec_id = 's1' and sec_id = 's3';

select * from section

CREATE TABLE "teaches" (
	id INT NOT NULL REFERENCES instructor(id),
	course_code VARCHAR(10) NOT NULL UNIQUE REFERENCES course(course_code),
	sec_id VARCHAR(10) NOT NULL REFERENCES section(sec_id),
	semester VARCHAR(10) NOT NULL,
	year INT NOT NULL
);

insert into teaches (id , course_code , sec_id , semester , year)
values
	(1 , 'CSE-1121' , 's9' , '1st' , 2023),
	(2 , 'CSE-1122' , 's12' , '1st' , 2023),
	(4 , 'EEE-1101' , 's1' , '1st' , 2023),
	(5 , 'EEE-1102' , 's3' , '1st' , 2023),
	(6 , 'CE-1100' , 's5' , '1st' , 2023),
	(7 , 'CE-1103' , 's7' , '1st' , 2023);
	
	

CREATE TABLE "student" (
	id VARCHAR(30) PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	dept_name VARCHAR(50) NOT NULL REFERENCES department(dept_name),
	tot_cred real
);


insert into student(id,name,dept_name,tot_cred)
values
	('C221043','Tawheedul Amin Siam','EEE', 50),
	('C221059','Istahadul Haque Tasin','EEE',50),
	('C221046','Mamun Mahmud','CSE',50),
	('C221050','Rayhan Uddain','CSE',60),
	('C221060','Najmus Sakib Rafi','CIVIL',40),
	('C221076','Faisal Haque Rifat','CIVIL',30);


CREATE TABLE "takes" (
	id VARCHAR(30) references student(id),
	course_code VARCHAR(10) NOT NULL UNIQUE REFERENCES course(course_code),
	sec_id VARCHAR(10) NOT NULL REFERENCES section(sec_id),
	semester VARCHAR(30), 
	year VARCHAR(30),
	grade real CHECK (grade >= 0 AND grade <=4 OR grade = NULL)
)


insert into takes(id,course_code,sec_id,semester,year,grade)
values

('C221043','CE-1100','s5','1st','2023',3.87),
('C221060','CE-1103','s7','1st','2023',3.87),
('C221046','CSE-1121','s9','1st','2023',3.87),
('C221060','CSE-1122','s12','1st','2023',3.87),
('C221043','EEE-1101','s1','1st','2023',3.87),
('C221076','EEE-1102','s1','1st','2023',3.87);



-- query-1
select *from department;

-- query - 2

select *from course
where credit != 3;

-- query - 3
select * from student
order by id asc;

-- query - 4
select credit , count(credit) as courses from course
group by credit;

-- query - 5
select dept_name , count(id) as teachers from instructor
group by dept_name;

-- query - 6
select student.name, course.title, takes.sec_id from takes 
inner join student on takes.id = student.id 
inner join course on takes.course_code = course.course_code
where student.id = 'C221060';

-- query - 7
select course_code, sec_id from section
where sec_id = 's12';

-- query - 7 or
select  section.sec_id, section.course_code, course.title from section 
inner join course on section.course_code = course.course_code
where sec_id = 's12';
