--Part – A 
--1.	Create a stored procedure that accepts a date and returns all faculty members who joined on that date.

CREATE OR ALTER PROC PR_Fac
@JDATE DATE
AS 
BEGIN
	SELECT FacultyName
	FROM FACULTY
	WHERE FacultyJoiningDate=@JDATE
END;

EXEC PR_Fac '2010-07-15'

--2.	Create a stored procedure for ENROLLMENT table where user enters either StudentID  or CourseID and 
--returns EnrollmentID, EnrollmentDate, Grade, and Status.

go
CREATE OR ALTER PROC PR_Info
@StuID INT = Null,
@CourseID VARCHAR(10) = NULL
AS
BEGIN
	SELECT *
	FROM ENROLLMENT
	WHERE StudentID=@StuID OR CourseID=@CourseID
END;

EXEC PR_Info @StuID=1

--3.	Create a stored procedure that accepts two integers (min and max credits) and returns all courses 
--whose credits fall between these values.

CREATE OR ALTER PROC PR_between
@min INT,
@max INT
AS
BEGIN
	SELECT CourseName
	FROM COURSE
	WHERE CourseCredits BETWEEN @min AND @max
END;

EXEC PR_between 3,4

--4.	Create a stored procedure that accepts Course Name and returns the list of students enrolled in that course.

CREATE OR ALTER PROC PR_list
@CourseName VARCHAR(20)
AS 
BEGIN
	SELECT StuName
	FROM ENROLLMENT E
	JOIN STUDENT S
	ON E.StudentID=S.StudentID
	WHERE E.CourseID=(SELECT CourseID
				      FROM COURSE
					  WHERE CourseName=@CourseName)
END;

EXEC PR_list 'Web Technologies'

		
--5.	Create a stored procedure that accepts Faculty Name and returns all course assignments.

CREATE OR ALTER PROC PR_fac_course
@FacName VARCHAR(50)
AS 
BEGIN
	SELECT CourseName
	FROM COURSE C
	JOIN COURSE_ASSIGNMENT CA
	ON C.CourseID=CA.CourseID
	WHERE CA.FacultyID=(SELECT FacultyID
	FROM FACULTY
	WHERE FacultyName=@FacName)
END;

EXEC PR_fac_course 'Dr. Sheth'

--6.	Create a stored procedure that accepts Semester number and Year, and returns all course assignments with 
--faculty and classroom details.

CREATE OR ALTER PROC PR_Detail
@SEM INT,
@Year INT
AS 
BEGIN
	SELECT CA.ClassRoom,CA.Semester,CA.Year,F.FacultyName
	FROM COURSE_ASSIGNMENT CA
	JOIN FACULTY F
	ON CA.FacultyID=F.FacultyID
	JOIN COURSE C
	ON C.CourseID=CA.CourseID
	WHERE CA.Semester=@SEM AND CA.Year=@Year
END;

EXEC PR_Detail 1,2024

--Part – B 
--7.	Create a stored procedure that accepts the first letter of Status ('A', 'C', 'D') and returns enrollment details.

CREATE OR ALTER PROC PR_Endetails
@first VARCHAR(5)
AS
BEGIN	
	SELECT *
	FROM ENROLLMENT
	WHERE EnrollmentStatus LIKE @first+'%'
END;

EXEC PR_Endetails 'A'

--8.	Create a stored procedure that accepts either Student Name OR Department Name and returns student
--data accordingly.

CREATE OR ALTER PROC PR_stu_Details
@NAME VARCHAR(20)
AS
BEGIN 
	SELECT *
	FROM STUDENT
	WHERE StuName=@NAME OR StuDepartment=@NAME
END

EXEC PR_stu_Details 'Raj Patel'

--9.	Create a stored procedure that accepts CourseID and returns all students enrolled grouped 
--by enrollment status with counts.

CREATE OR ALTER PROC PR_EN_COUNT
@CourseID VARCHAR(10)
AS
BEGIN
	SELECT COUNT(StudentID),EnrollmentStatus
	FROM ENROLLMENT 
	GROUP BY EnrollmentStatus
END;

EXEC PR_EN_COUNT 'CS101'

--Part – C 
--10.	Create a stored procedure that accepts a year as input and returns all courses assigned to faculty 
--in that year with classroom details.


--11.	Create a stored procedure that accepts From Date and To Date and returns all enrollments within that range with student and course details.
--12.	Create a stored procedure that accepts FacultyID and calculates their total teaching load (sum of credits of all courses assigned).
