--Part – A 
--1.	Retrieve all unique departments from the STUDENT table.

	select distinct stuDepartment 
	from STUDENT

--2.	Insert a new student record into the STUDENT table.
--(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)

	INSERT INTO STUDENT VALUES
	(9, 'Neha Singh', 'neha.singh@univ.edu', '9876543218', 'IT', '2003-09-20', 2021)

--3.	Change the Email of student 'Raj Patel' to 'raj.p@univ.edu'. (STUDENT table)

	UPDATE STUDENT
	SET STUEMAIL = 'RAJ.P@UNIV.EDU'
	WHERE STUNAME = 'RAJ PATEL';

--4.	Add a new column 'CGPA' with datatype DECIMAL(3,2) to the STUDENT table.

	ALTER TABLE STUDENT
	ADD CGPA DECIMAL(3,2);

--5.	Retrieve all courses whose CourseName starts with 'Data'. (COURSE table)

	SELECT * FROM COURSE
	WHERE COURSENAME LIKE 'DATA%';

--6.	Retrieve all students whose Name contains 'Shah'. (STUDENT table)

	SELECT * FROM STUDENT
	WHERE STUNAME LIKE '%SHAH%';

--7.	Display all Faculty Names in UPPERCASE. (FACULTY table)

	SELECT UPPER(FACULTYNAME) FROM FACULTY;

--8.	Find all faculty who joined after 2015. (FACULTY table)

	SELECT * FROM FACULTY
	WHERE FACULTYJOININGDATE > '2014-12-31';

--9.	Find the SQUARE ROOT of Credits for the course 'Database Management Systems'. (COURSE table)

	SELECT SQRT(COURSECREDITS) 
	FROM COURSE
	WHERE COURSENAME = 'Database Management Systems';

--10.	Find the Current Date using SQL Server in-built function.

	SELECT GETDATE();

--11.	Find the top 3 students who enrolled earliest (by EnrollmentYear). (STUDENT table)

	SELECT TOP 3  STUNAME
	FROM STUDENT
	ORDER BY STUENROLLMENTYEAR;

--12.	Find all enrollments that were made in the year 2022. (ENROLLMENT table)

	SELECT * FROM ENROLLMENT
	WHERE YEAR(ENROLLMENTDATE) = 2022;

--13.	Find the number of courses offered by each department. (COURSE table)

	SELECT COUNT(COURSENAME),COURSEDEPARTMENT
	FROM COURSE
	GROUP BY COURSEDEPARTMENT;

--14.	Retrieve the CourseID which has more than 2 enrollments. (ENROLLMENT table)

	SELECT COURSEID
	FROM ENROLLMENT 
	GROUP BY COURSEID
	HAVING COUNT(COURSEID)>1;

--15.	Retrieve all the student name with their enrollment status. (STUDENT & ENROLLMENT table)

	SELECT S.STUNAME,E.ENROLLMENTSTATUS
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.STUDENTID = E.STUDENTID;

--16.	Select all student names with their enrolled course names. (STUDENT, COURSE, ENROLLMENT table)

	SELECT S.STUNAME,C.COURSENAME
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.STUDENTID = E.STUDENTID
	JOIN COURSE C
	ON E.COURSEID = C.COURSEID;

--17.	Create a view called 'ActiveEnrollments' showing only active enrollments with student name and  course name. (STUDENT, COURSE, ENROLLMENT,  table)
    
	CREATE VIEW ACTIVENROLLMENTS 
	AS
	SELECT S.STUNAME,C.COURSENAME
	FROM STUDENT S
	JOIN ENROLLMENT E
	ON S.STUDENTID = E.STUDENTID
	JOIN COURSE C
	ON E.COURSEID = C.COURSEID
	WHERE ENROLLMENTSTATUS='ACTIVE';

	SELECT * FROM ACTIVENROLLMENTS;

--18.	Retrieve the student’s name who is not enrol in any course using subquery. (STUDENT, ENROLLMENT TABLE)

	SELECT STUNAME,STUDENTID
	FROM STUDENT
	WHERE STUDENTID NOT IN(SELECT STUDENTID FROM ENROLLMENT);

	SELECT S.STUNAME,E.STUDENTID,S.STUDENTID
	FROM STUDENT S
	LEFT JOIN ENROLLMENT E
	ON S.STUDENTID = E.STUDENTID
	WHERE E.STUDENTID IS NULL;

--19.	Display course name having second highest credit. (COURSE table)

	SELECT TOP 1 COURSENAME
	FROM COURSE
	WHERE CourseCredits < (SELECT MAX(COURSECREDITS)FROM COURSE)
	ORDER BY CourseCredits DESC

--Part – B 
--20.	Retrieve all courses along with the total number of students enrolled. (COURSE, ENROLLMENT table)

	SELECT C.COURSENAME,COUNT(E.STUDENTID)
	FROM COURSE C
	JOIN ENROLLMENT E
	ON E.COURSEID = C.COURSEID
	GROUP BY C.COURSENAME;

--21.	Retrieve the total number of enrollments for each status, showing only statuses that have more than 2 enrollments. (ENROLLMENT table)

	SELECT COUNT(STUDENTID) AS TOTAL,ENROLLMENTSTATUS
	FROM ENROLLMENT
	GROUP BY ENROLLMENTSTATUS
	HAVING COUNT(STUDENTID) > 2;

--22.	Retrieve all courses taught by 'Dr. Sheth' and order them by Credits. (FACULTY, COURSE, COURSE_ASSIGNMENT table)
SELECT COURSENAME ,CourseCredits
FROM COURSE C JOIN COURSE_ASSIGNMENT CA
ON C.CourseID=CA.CourseID
JOIN FACULTY F
ON F.FacultyID=CA.FacultyID
WHERE FacultyName='Dr. Sheth'
ORDER BY CourseCredits


--Part – C 
--23.	List all students who are enrolled in more than 3 courses. (STUDENT, ENROLLMENT table)
SELECT StuName
FROM STUDENT S JOIN ENROLLMENT E
ON S.StudentID=E.StudentID
GROUP BY S.StuName
HAVING COUNT(CourseID)>3

--24.	Find students who have enrolled in both 'CS101' and 'CS201' Using Sub Query. (STUDENT, ENROLLMENT table)
SELECT STUNAME
FROM STUDENT
WHERE StudentID IN (SELECT StudentID FROM ENROLLMENT WHERE COURSEID IN ('CS101','CS201'))

--25.	Retrieve department-wise count of faculty members along with their average years of experience (calculate experience from JoiningDate). (Faculty table)
SELECT FacultyDepartment,COUNT(FacultyID) AS facultymembers,AVG(DATEDIFF(YEAR, FacultyJoiningDate, GETDATE())) AS AvgExperienceYears
FROM FACULTY
GROUP BY FacultyDepartment