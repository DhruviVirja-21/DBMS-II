USE Bsc_honers_cs_475
-----------------------------------UDF--------------------------------- 
---------------------------------------- Part – A ------------------------------------
--1. Write a scalar function to print "Welcome to DBMS Lab".
CREATE OR ALTER FUNCTION FN_MASG()
RETURNS VARCHAR(50)
AS
BEGIN	
	RETURN 'WELCOME TO DBMS-II'
END
SELECT DBO.FN_MASG()

--2. Write a scalar function to calculate simple interest. 
CREATE OR ALTER FUNCTION FN_SIMPLEINTREST(@P INT,@R INT,@N INT)
RETURNS DECIMAL(6,2)
AS
BEGIN
DECLARE @S DECIMAL(6,2)
SET @S=(@P*@R*@N)/100
RETURN @S
END
SELECT DBO.FN_SIMPLEINTREST(1000,1,2)

--3. Function to Get Difference in Days Between Two Given Dates 
CREATE OR ALTER FUNCTION FN_DATE(@D1 DATE,@D2 DATE)
RETURNS INT
AS
BEGIN
RETURN (SELECT DATEDIFF(DAY,@D1,@D2))
END
SELECT DBO.FN_DATE('2025-07-12','2025-07-14')


--4. Write a scalar function which returns the sum of Credits for two given CourseIDs. 
CREATE OR ALTER FUNCTION FN_SUMOFCREDIT(@DID1 VARCHAR(10),@DID2 VARCHAR(10))
RETURNS INT 
AS
BEGIN
       RETURN(SELECT SUM(CourseCredits)
	   FROM COURSE
	   WHERE CourseID=@DID1 OR CourseID=@DID2
	   )
END

SELECT DBO.FN_SUMOFCREDIT('CS301','CS201')


--5. Write a function to check whether the given number is ODD or EVEN. 
CREATE OR ALTER FUNCTION FN_ODDEVEN(@N INT)
RETURNS VARCHAR(10)
AS
BEGIN
IF(@N%2=0)
	RETURN 'EVEN'
RETURN 'ODD'
END
SELECT DBO.FN_ODDEVEN(11)

--6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FN_1TON(@N INT)
RETURNS VARCHAR(200)
AS
BEGIN
       DECLARE @I INT,@PRINT VARCHAR(200)=''
	   SET @I=1
	   WHILE(@I<=@N)
	   BEGIN
			SET @PRINT=@PRINT+' '+CAST(@I AS VARCHAR)
			SET @I=@I+1
	   END
	   RETURN @PRINT
END
SELECT DBO.FN_1TON(10)


--7. Write a scalar function to calculate factorial of total credits for a given CourseID.
CREATE OR ALTER FUNCTION FN_FACTORIAL(@ID VARCHAR(20))
RETURNS INT
AS
BEGIN
DECLARE @C INT,@I INT=1
(SELECT @C = CourseCredits
FROM COURSE
WHERE CourseID=@ID
)
	WHILE(@I<=@C)
	BEGIN
		 SET @C=@C*@I
		 SET @I+=1
	END
	RETURN @C
END
SELECT DBO.FN_FACTORIAL('CS201')

--8. Write a scalar function to check whether a given EnrollmentYear is in the past, current or future (Case statement) 
CREATE OR ALTER FUNCTION FN_ENROLLMENTYEARSTATUS(@Year INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @CurrentYear INT = YEAR(GETDATE())

	RETURN (
		SELECT CASE
			WHEN @Year < @CurrentYear THEN 'PAST'
			WHEN @Year = @CurrentYear THEN 'CURRENT'
			ELSE 'FUTURE'
		END
	)
END
SELECT DBO.FN_ENROLLMENTYEARSTATUS(2021)


--9. Write a table-valued function that returns details of students whose names start with a given letter. 
CREATE OR ALTER FUNCTION FN_STUDENTSBYLETTER(@Letter CHAR(1))
RETURNS TABLE
AS
RETURN
(
	SELECT *
	FROM STUDENT
	WHERE StuName LIKE @Letter + '%'
)
SELECT * FROM DBO.FN_STUDENTSBYLETTER('R')


--10. Write a table-valued function that returns unique department names from the STUDENT table. 
CREATE OR ALTER FUNCTION FN_UNIQUEDEPT()
RETURNS TABLE
AS
RETURN
(
	SELECT DISTINCT StuDepartment
	FROM STUDENT
)
SELECT * FROM DBO.FN_UNIQUEDEPT()


--------------------------Part – B 

--11. Write a scalar function that calculates age in years given a DateOfBirth. 
CREATE OR ALTER FUNCTION FN_CALCULATEAGE(@DOB DATE)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(YEAR,@DOB,GETDATE())
END
SELECT DBO.FN_CALCULATEAGE('2003-05-15')


--12. Write a scalar function to check whether given number is palindrome or not. 
CREATE OR ALTER FUNCTION FN_PALINDROME(@N INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @Original INT=@N,@Reverse INT=0,@Rem INT

	WHILE(@N>0)
	BEGIN
		SET @Rem=@N%10
		SET @Reverse=@Reverse*10+@Rem
		SET @N=@N/10
	END

	IF(@Original=@Reverse)
		RETURN 'PALINDROME'
	RETURN 'NOT PALINDROME'
END
SELECT DBO.FN_PALINDROME(121)


--13. Write a scalar function to calculate the sum of Credits for all courses in the 'CSE' department. 
CREATE OR ALTER FUNCTION FN_CSE_TOTALCREDITS()
RETURNS INT
AS
BEGIN
	RETURN(
		SELECT SUM(CourseCredits)
		FROM COURSE
		WHERE CourseDepartment='CSE'
	)
END
SELECT DBO.FN_CSE_TOTALCREDITS()


--14. Write a table-valued function that returns all courses taught by faculty with a specific designation. 
CREATE OR ALTER FUNCTION FN_COURSESBYDESIGNATION(@Designation VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
	SELECT C.CourseID,C.CourseName,F.FacultyName
	FROM COURSE_ASSIGNMENT CA
	JOIN COURSE C ON CA.CourseID=C.CourseID
	JOIN FACULTY F ON CA.FacultyID=F.FacultyID
	WHERE F.FacultyDesignation=@Designation
)
SELECT * FROM DBO.FN_COURSESBYDESIGNATION('Professor')


-----------------------------Part – C 

--15. Write a scalar function that accepts StudentID and returns their total enrolled credits (sum of credits from all active enrollments). 
CREATE OR ALTER FUNCTION FN_TOTALACTIVECREDITS(@StudentID INT)
RETURNS INT
AS
BEGIN
	RETURN(
		SELECT SUM(C.CourseCredits)
		FROM ENROLLMENT E
		JOIN COURSE C ON E.CourseID=C.CourseID
		WHERE E.StudentID=@StudentID
		AND E.EnrollmentStatus='Active'
	)
END
SELECT DBO.FN_TOTALACTIVECREDITS(1)


--16. Write a scalar function that accepts two dates (joining date range) and returns the count of faculty who joined in that period.
CREATE OR ALTER FUNCTION FN_FACULTYCOUNTBYDATE(@FromDate DATE,@ToDate DATE)
RETURNS INT
AS
BEGIN
	RETURN(
		SELECT COUNT(*)
		FROM FACULTY
		WHERE FacultyJoiningDate BETWEEN @FromDate AND @ToDate
	)
END
SELECT DBO.FN_FACULTYCOUNTBYDATE('2010-01-01','2015-12-31')

