--Part – A 
ALTER TABLE STUDENT
DROP COLUMN CGPA
--1.	INSERT Procedures: Create stored procedures to insert records into STUDENT tables (SP_INSERT_STUDENT)
--StuID	   Name	             Email	      Phone	    Department	DOB	       EnrollmentYear
--10	Harsh Parmar	harsh@univ.edu	9876543219	CSE	     2005-09-18	       2023
--11	Om Patel	    om@univ.edu	     9876543220	 IT	     2002-08-22	       2022
GO
CREATE OR ALTER PROCEDURE PR_INSERT_STUDENT
AS 
BEGIN
INSERT INTO STUDENT VALUES
(10,'Harsh Parmar','harsh@univ.edu',9876543219,'CSE','2005-09-18',2023),
(11,'Om Patel','om@univ.edu',9876543220,'IT','2002-08-22',2022)
END


--2.	INSERT Procedures: Create stored procedures to insert records into COURSE tables 
--(SP_INSERT_COURSE)
--CourseID	CourseName	      Credits	Dept	Semester
--CS330	  Computer Networks	    4	     CSE	5
--EC120	  Electronic Circuits	3	     ECE	2
GO
CREATE OR ALTER PROCEDURE PR_INSERT_COURSE
AS
BEGIN
INSERT INTO COURSE VALUES('CS330','Computer Networks',4,'CSE',5),
('EC120','Electronic Circuits',3,'ECE',2)
END

--3.	UPDATE Procedures: Create stored procedure SP_UPDATE_STUDENT to update Email and Phone in STUDENT table. (Update using studentID)
GO
CREATE OR ALTER PROCEDURE PR_UPDATE_STUDENT
@EMAIL VARCHAR(40),
@PHONE VARCHAR(10),
@STUID INT
AS 
BEGIN
UPDATE STUDENT SET StuEmail=@EMAIL,StuPhone=@PHONE
WHERE StudentID=@STUID
END
EXEC PR_UPDATE_STUDENT 'DHRUVI@GMAIL.COM','6435736458',3


--4.	DELETE Procedures: Create stored procedure SP_DELETE_STUDENT to delete records from STUDENT where Student Name is Om Patel.
GO
CREATE OR ALTER PROCEDURE PR_DELETE_STUDENT
AS
BEGIN
DELETE FROM STUDENT
WHERE StuName='OM PATEL'
END


--5.	SELECT BY PRIMARY KEY: Create stored procedures to select records by primary key (SP_SELECT_STUDENT_BY_ID) from Student table.
GO
CREATE OR ALTER PROCEDURE PR_SELECT_STUDENT_BY_ID
@ID INT
AS
BEGIN
SELECT * FROM STUDENT
WHERE StudentID=@ID
END
EXEC PR_SELECT_STUDENT_BY_ID 1


--6.	Create a stored procedure that shows details of the first 5 students ordered by EnrollmentYear.
GO
CREATE OR ALTER PROCEDURE PR_STDENT_DETAILOF5
AS
BEGIN
SELECT TOP 5 *FROM STUDENT
ORDER BY StuEnrollmentYear
END
EXEC PR_STDENT_DETAILOF5

--Part – B  
--7.	Create a stored procedure which displays faculty designation-wise count.
GO
CREATE OR ALTER PROCEDURE PR_designation_wisecount
AS
BEGIN
SELECT FacultyDesignation,COUNT(FacultyDesignation) FROM FACULTY
GROUP BY FacultyDesignation
END
EXEC PR_designation_wisecount

--8.	Create a stored procedure that takes department name as input and returns all students in that department.
GO
CREATE OR ALTER PROCEDURE PR_STUDENTINDEPT
@DEPT VARCHAR(50)
AS
BEGIN
SELECT *FROM STUDENT
WHERE StuDepartment=@DEPT
END
EXEC PR_STUDENTINDEPT 'CSE'


--Part – C 
--9.	Create a stored procedure which displays department-wise maximum, minimum, and average credits of courses.
GO
CREATE OR ALTER PROCEDURE PR_MINMAXAVG
AS
BEGIN
SELECT CourseDepartment,MAX(CourseCredits),MIN(CourseCredits),AVG(CourseCredits) 
FROM COURSE
GROUP BY CourseDepartment
END
EXEC PR_MINMAXAVG

--10.	Create a stored procedure that accepts StudentID as parameter and returns all courses the student is enrolled in with their grades.
GO
CREATE OR ALTER PROCEDURE PR_STD_COURSE
@STUID INT 
AS
BEGIN
SELECT S.StuName,CourseID,Grade
FROM ENROLLMENT E
JOIN STUDENT S
ON S.StudentID=E.StudentID
WHERE S.StudentID=@STUID
END
EXEC PR_STD_COURSE 2
