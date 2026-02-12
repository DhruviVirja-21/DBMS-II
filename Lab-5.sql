--USE Bsc_honers_cs_475

---============================================
--                  Cursor 
--==============================================

----------------- Part – A ------------------------
--1. Create a cursor Course_Cursor to fetch all rows from COURSE table and display them. 
DECLARE 
	@CID VARCHAR(10),
	@CName VARCHAR(100),
	@CCredits INT,
	@CDepartment VARCHAR(50),
	@CSemester INT

DECLARE Course_Cursor CURSOR 
FOR 
	SELECT COURSEID,CourseName,CourseCredits,CourseDepartment,CourseSemester  FROM COURSE

OPEN Course_Cursor

FETCH NEXT FROM Course_Cursor INTO @CID,@CName,@CCredits,@CDepartment,@CSemester

WHILE @@FETCH_STATUS=0
	BEGIN
		PRINT 'COURSEID:' + @CID 
		+ ',CourseName:' + @CName
		+ ',CourseCredits:' + CAST(@CCredits AS VARCHAR)
		+ ',CourseDepartment:' + @CDepartment
		+ ',CourseSemester:' + CAST(@CSemester AS VARCHAR)

		FETCH NEXT FROM Course_Cursor 
		INTO @CID,@CName,@CCredits,@CDepartment,@CSemester
	END

CLOSE Course_Cursor

DEALLOCATE Course_Cursor


--2. Create a cursor Student_Cursor_Fetch to fetch records in form of StudentID_StudentName (Example: 1_Raj Patel). 
GO
DECLARE @SID INT, @Sname VARCHAR(100)
DECLARE Student_Cursor_Fetch CURSOR
FOR 
SELECT StudentID, StuName FROM STUDENT
OPEN Student_Cursor_Fetch
FETCH NEXT FROM Student_Cursor_Fetch INTO @SID, @Sname
WHILE @@FETCH_STATUS=0
	BEGIN
	PRINT  CAST(@SID AS VARCHAR) + '_' + @SName
	FETCH NEXT FROM Student_Cursor_Fetch 
	INTO @SID, @Sname
	END
CLOSE Student_Cursor_Fetch
DEALLOCATE Student_Cursor_Fetch


--3. Create a cursor to find and display all courses with Credits greater than 3. 
GO
DECLARE 
	@CName VARCHAR(100),
	@CCredits INT
	
DECLARE Course_Cursor CURSOR 
FOR 
	SELECT CourseName,CourseCredits  FROM COURSE WHERE CourseCredits>3

OPEN Course_Cursor

FETCH NEXT FROM Course_Cursor INTO @CName,@CCredits

WHILE @@FETCH_STATUS=0
	BEGIN
		PRINT 
		  @CName  + '_'+CAST(@CCredits AS VARCHAR)
		
		FETCH NEXT FROM Course_Cursor 
		INTO @CName,@CCredits
	END

CLOSE Course_Cursor

DEALLOCATE Course_Cursor

--4. Create a cursor to display all students who enrolled in year 2021 or later. 
GO
DECLARE 
	@SName VARCHAR(100),
	@StuEnrollmentYear INT
	
DECLARE enrolled_Cursor CURSOR 
FOR 
	SELECT STUNAME,StuEnrollmentYear  FROM STUDENT WHERE StuEnrollmentYear>=2021

OPEN enrolled_Cursor

FETCH NEXT FROM enrolled_Cursor INTO @SName,@StuEnrollmentYear

WHILE @@FETCH_STATUS=0
	BEGIN
		PRINT 
		  @SName  + '_'+CAST(@StuEnrollmentYear AS VARCHAR)
		
		FETCH NEXT FROM enrolled_Cursor 
		INTO @SName,@StuEnrollmentYear
	END

CLOSE enrolled_Cursor

DEALLOCATE enrolled_Cursor

--5. Create a cursor Course_CursorUpdate that retrieves all courses and increases Credits by 1 for courses with Credits less than 4. 
GO
DECLARE @CourseName VARCHAR(100),@CourseCredits INT
DECLARE Course_CursorUpdate CURSOR
FOR SELECT CourseName,CourseCredits FROM COURSE WHERE CourseCredits<4

OPEN Course_CursorUpdate

FETCH NEXT FROM Course_CursorUpdate
INTO @CourseName,@CourseCredits

WHILE @@FETCH_STATUS=0
	BEGIN 
		UPDATE COURSE
		SET CourseCredits=@CourseCredits+1
		FETCH NEXT FROM Course_CursorUpdate
		INTO @CourseName,@CourseCredits
	END
CLOSE Course_CursorUpdate
DEALLOCATE Course_CursorUpdate


--6. Create a Cursor to fetch Student Name with Course Name 
--(Example: Raj Patel is enrolled in Database Management Systems)

GO
DECLARE @StuName VARCHAR(100),@CourseName VARCHAR(100)

DECLARE STU_COURSE_CURSOR CURSOR
FOR
SELECT S.StuName,C.CourseName
FROM STUDENT S
JOIN ENROLLMENT E ON S.StudentID=E.StudentID
JOIN COURSE C ON E.CourseID=C.CourseID

OPEN STU_COURSE_CURSOR

FETCH NEXT FROM STU_COURSE_CURSOR INTO @StuName,@CourseName

WHILE @@FETCH_STATUS=0
BEGIN
	PRINT @StuName + ' is enrolled in ' + @CourseName

	FETCH NEXT FROM STU_COURSE_CURSOR 
	INTO @StuName,@CourseName
END

CLOSE STU_COURSE_CURSOR
DEALLOCATE STU_COURSE_CURSOR



--7. Create a cursor to insert data into new table if student belong to ‘CSE’ department. 
--(create new table CSEStudent with relevant columns)

GO
CREATE TABLE CSEStudent
(
	StudentID INT,
	StuName VARCHAR(100),
	StuDepartment VARCHAR(50)
)
DECLARE @SID INT,@SName VARCHAR(100),@SDept VARCHAR(50)
DECLARE CSE_CURSOR CURSOR
FOR
SELECT StudentID,StuName,StuDepartment 
FROM STUDENT
WHERE StuDepartment='CSE'
OPEN CSE_CURSOR
FETCH NEXT FROM CSE_CURSOR INTO @SID,@SName,@SDept
WHILE @@FETCH_STATUS=0
BEGIN
	INSERT INTO CSEStudent VALUES(@SID,@SName,@SDept)
	FETCH NEXT FROM CSE_CURSOR 
	INTO @SID,@SName,@SDept
END

CLOSE CSE_CURSOR
DEALLOCATE CSE_CURSOR



--------------------------------Part – B --------------------------

--8. Create a cursor to update all NULL grades to 'F' for enrollments with Status 'Completed' 

GO
DECLARE @EnrollID INT

DECLARE GRADE_CURSOR CURSOR
FOR
SELECT EnrollmentID
FROM ENROLLMENT
WHERE Grade IS NULL AND EnrollmentStatus='Completed'

OPEN GRADE_CURSOR

FETCH NEXT FROM GRADE_CURSOR INTO @EnrollID

WHILE @@FETCH_STATUS=0
BEGIN
	UPDATE ENROLLMENT
	SET Grade='F'
	WHERE EnrollmentID=@EnrollID

	FETCH NEXT FROM GRADE_CURSOR INTO @EnrollID
END

CLOSE GRADE_CURSOR
DEALLOCATE GRADE_CURSOR



--9. Cursor to show Faculty with Course they teach 
--(EX: Dr. Sheth teaches Data Structures)

GO
DECLARE @FacultyName VARCHAR(100),@CourseName VARCHAR(100)

DECLARE FAC_COURSE_CURSOR CURSOR
FOR
SELECT F.FacultyName,C.CourseName
FROM FACULTY F
JOIN COURSE_ASSIGNMENT CA ON F.FacultyID=CA.FacultyID
JOIN COURSE C ON CA.CourseID=C.CourseID

OPEN FAC_COURSE_CURSOR

FETCH NEXT FROM FAC_COURSE_CURSOR INTO @FacultyName,@CourseName

WHILE @@FETCH_STATUS=0
BEGIN
	PRINT @FacultyName + ' teaches ' + @CourseName

	FETCH NEXT FROM FAC_COURSE_CURSOR 
	INTO @FacultyName,@CourseName
END

CLOSE FAC_COURSE_CURSOR
DEALLOCATE FAC_COURSE_CURSOR



-------------------------------Part – C ---------------------------------

--10. Cursor to calculate total credits per student 
--(Example: Raj Patel has total credits = 15)

GO
DECLARE @SID INT,@SName VARCHAR(100),@TotalCredits INT

DECLARE TOTAL_CURSOR CURSOR
FOR
SELECT S.StudentID,S.StuName
FROM STUDENT S

OPEN TOTAL_CURSOR

FETCH NEXT FROM TOTAL_CURSOR INTO @SID,@SName

WHILE @@FETCH_STATUS=0
BEGIN
	SELECT @TotalCredits=ISNULL(SUM(C.CourseCredits),0)
	FROM ENROLLMENT E
	JOIN COURSE C ON E.CourseID=C.CourseID
	WHERE E.StudentID=@SID

	PRINT @SName + ' has total credits = ' + CAST(@TotalCredits AS VARCHAR)

	FETCH NEXT FROM TOTAL_CURSOR 
	INTO @SID,@SName
END

CLOSE TOTAL_CURSOR
DEALLOCATE TOTAL_CURSOR
