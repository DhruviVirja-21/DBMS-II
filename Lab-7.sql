--Table : Log(LogMessage varchar(100), logDate Datetime) 
CREATE TABLE LOG(
	LogMessage varchar(100),
	logDate Datetime
);

--Part – A 
--1. Create trigger for blocking student deletion. 
GO
CREATE OR ALTER TRIGGER TR_BLOCK_STUDENT
ON STUDENT
INSTEAD OF DELETE
AS 
BEGIN
	PRINT 'STUDENT  DELETION IS NOT ALLOWED.'
END;

DELETE FROM STUDENT WHERE STUDENTID=1;

DROP TRIGGER TR_BLOCK_STUDENT


--2. Create trigger for making course read-only. 
GO
CREATE OR ALTER  TRIGGER TR_READONLY
ON COURSE
INSTEAD OF INSERT,UPDATE,DELETE
AS
BEGIN
	PRINT 'INSERT,UPDATE,DELETE IS NOT ALLOW ONLY FOR READ'
	INSERT INTO LOG VALUES ('DELETE,INSERT,UPDATE NOT ALLOWED ONLY FOR READ',GETDATE())
END;

INSERT INTO COURSE VALUES('CS501','Programming Fundamentals',4,'CSE',1)
UPDATE COURSE SET CourseName='PF' WHERE CourseID='CS501'
DELETE FROM COURSE  WHERE CourseID='CS501'

DROP TRIGGER TR_READONLY
SELECT * FROM LOG

--3. Create trigger for preventing faculty removal.
GO
CREATE OR ALTER TRIGGER TR_PREVENT_FACULTY
ON FACULTY
INSTEAD OF DELETE
AS 
BEGIN
	PRINT 'DELETION FACULTY IS NOT ALLOWED.'
END;

DELETE FROM FACULTY WHERE FacultyID=101

DROP TRIGGER TR_PREVENT_FACULTY

--4. Create instead of trigger to log all operations on COURSE (INSERT/UPDATE/DELETE) into Log table. 
--(Example: INSERT/UPDATE/DELETE operations are blocked for you in course table) 
GO
CREATE OR ALTER TRIGGER TR_COURSE_MONITOR
ON COURSE
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO LOG 
        VALUES ('UPDATE PERFORMED ON COURSE TABLE', GETDATE())
    END
    ELSE IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        INSERT INTO LOG 
        VALUES ('INSERT PERFORMED ON COURSE TABLE', GETDATE())
    END
    ELSE IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        INSERT INTO LOG 
        VALUES ('DELETE PERFORMED ON COURSE TABLE', GETDATE())
    END
END

SELECT * FROM COURSE;
SELECT * FROM LOG;

INSERT INTO COURSE VALUES ('CS405', 'COMPUTER PERIPHERALS', 3, 'CS', 2);

UPDATE COURSE SET COURSECredits = 4 WHERE COURSEID = 'CS405';

DELETE FROM COURSE WHERE COURSEID = 'CS405';

DROP TRIGGER TR_COURSE_MONITOR;


--5. Create trigger to Block student to update their enrollment year and print message ‘students are not allowed to update their enrollment year’ 
GO
CREATE OR ALTER TRIGGER TR_BLOCK_ENROLL_YEAR_UPDATE
ON STUDENT
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(STUENROLLMENTYEAR)
    BEGIN
        PRINT 'STUDENTS ARE NOT ALLOWED TO UPDATE STUENROLLMENTYEAR'
        RETURN
    END
END

UPDATE STUDENT SET StuEnrollmentYear=2022 WHERE StudentID=1

DROP TRIGGER TR_BLOCK_ENROLL_YEAR_UPDATE


--6. Create trigger for student age validation (Min 18).
GO
CREATE TRIGGER check_student_age
ON student
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @StuDateOfBirth DATE
	SELECT @StuDateOfBirth=StuDateOfBirth FROM inserted
    IF DATEDIFF(YEAR,@StuDateOfBirth,GETDATE()) < 18 
        PRINT 'Student age must be at least 18 years';
END 
 
INSERT INTO STUDENT VALUES(13, 'DHRUVI Patel', 'DHRUVI@univ.edu', '9876543210', 'CSE', '2022-05-15', 2021)

DROP TRIGGER check_student_age
SELECT * FROM STUDENT

--Part – B 
--7. Create trigger for unique faculty’s email check.
GO
CREATE OR ALTER TRIGGER TR_UNIQUEEMAIL
ON FACULTY
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (
        SELECT 1
        FROM Faculty
        WHERE  EXISTS (SELECT FacultyEmail FROM inserted)
    )
    BEGIN
        PRINT 'Email must be unique';
    END
    ELSE
    BEGIN
        INSERT INTO Faculty (FacultyID, FacultyName, FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate)
        SELECT FacultyID, FacultyName, FacultyEmail,FacultyDepartment,FacultyDesignation,FacultyJoiningDate
        FROM inserted;
    END
END

INSERT INTO Faculty VALUES(110, 'Dr. Amit Sharma', 'Sheth@univ.edu', 'Computer Science', 'Professor', '2015-06-15');

SELECT *FROM FACULTY
DROP TRIGGER TR_UNIQUEEMAIL

--8. Create trigger for preventing duplicate enrollment. 
GO
CREATE OR ALTER TRIGGER TR_PREVENT_DUPLICATE_ENROLLMENT
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
    -- Check if same StudentID + CourseID already exists
    IF EXISTS (
        SELECT 1
        FROM ENROLLMENT
        WHERE StudentID IN (SELECT StudentID FROM inserted)
        AND CourseID IN (SELECT CourseID FROM inserted)
    )
    BEGIN
        PRINT 'DUPLICATE ENROLLMENT NOT ALLOWED';
        RETURN;
    END

    -- If not duplicate, insert record
    INSERT INTO ENROLLMENT 
    (StudentID, CourseID, EnrollmentDate, Grade, EnrollmentStatus)
    SELECT StudentID, CourseID, EnrollmentDate, Grade, EnrollmentStatus
    FROM inserted;
END

INSERT INTO ENROLLMENT VALUES (14,1, 'CS201', '2026-02-01', 4, 'Active');

SELECT *FROM ENROLLMENT

DROP TRIGGER TR_PRIVANTING_DUBLICATE_ENROLLMENT

--Part - C 
--9. Create trigger to Allow enrolment in month from Jan to August, otherwise print message enrolment closed.
GO
CREATE OR ALTER TRIGGER TR_CHECK_ENROLLMENT_MONTH
ON ENROLLMENT
INSTEAD OF INSERT
AS
BEGIN
    -- Check current month
    IF MONTH(GETDATE()) NOT BETWEEN 1 AND 8
    BEGIN
        PRINT 'ENROLLMENT CLOSED';
        RETURN;
    END

    -- If month is between Jan (1) and Aug (8), allow insert
    INSERT INTO ENROLLMENT
    (StudentID, CourseID, EnrollmentDate, Grade, EnrollmentStatus)
    SELECT StudentID, CourseID, EnrollmentDate, Grade, EnrollmentStatus
    FROM inserted;
END

INSERT INTO ENROLLMENT VALUES (14, 'CS205', '2026-4-01', NULL, 'Active');

DROP TRIGGER TR_CHECK_ENROLLMENT_MONTH

--10. Create trigger to Allow only grade change in enrollment (block other updates) 
GO
CREATE OR ALTER TRIGGER TR_ALLOW_ONLY_GRADE_UPDATE
ON ENROLLMENT
INSTEAD OF UPDATE
AS
BEGIN
    -- If any column other than Grade is updated
    IF UPDATE(StudentID) 
       OR UPDATE(CourseID) 
       OR UPDATE(EnrollmentDate) 
       OR UPDATE(EnrollmentStatus)
    BEGIN
        PRINT 'ONLY GRADE CAN BE UPDATED';
        RETURN;
    END

    -- Allow only Grade update
    UPDATE E
    SET E.Grade = I.Grade
    FROM ENROLLMENT E
    INNER JOIN inserted I
        ON E.EnrollmentID = I.EnrollmentID;
END

UPDATE ENROLLMENT SET Grade = 'A'WHERE EnrollmentID = 1;
UPDATE ENROLLMENT SET EnrollmentStatus = 'Completed'WHERE EnrollmentID = 1;

DROP TRIGGER TR_ALLOW_ONLY_GRADE_UPDATE






----------#Lab- 7 :  Extra Questions------------------


--### For Query 4 – Detect and Log Operations on COURSE Table

--Create an INSTEAD OF trigger on the COURSE table that detects which operation is attempted and logs it in the LOG table.

--Task:
--- If a user attempts to INSERT, UPDATE, or DELETE records in the
--COURSE table:
--• The operation must be blocked.
--• The attempted operation must be recorded in the LOG table.

--Hint:
--Use the inserted and deleted tables to identify which operation is performed.

--Expected Output in LOG Table:
--- INSERT attempted on COURSE
--- UPDATE attempted on COURSE
--- DELETE attempted on COURSE

--No actual change should occur in the COURSE table.

---------------------------------------

--### For Query 5 – Block Enrollment Year Update Only.

--Students must not be allowed to update their EnrollmentYear.
--However, updates to other columns should still be permitted.

--Task:
--- If EnrollmentYear is updated, the operation must be blocked.
--- Updates to other columns such as department, email, or phone
--should work normally.

--Example Scenarios:
--Allowed:
--Update student name,department,email,phone,dob.
--Blocked:
--Update EnrollmentYear.

--Expected Output:
--Message displayed:
--Students are not allowed to update their enrollment year.

--EnrollmentYear remains unchanged, while other columns update normally.

---------------------------------------

--### For Query 6 – Student Age Validation During Insert

--When inserting a student record, the system must validate age using
--DateOfBirth.

--Task:
--- Calculate student age using DateOfBirth.
--- If age is less than 18, insertion must be blocked.
--- If age is 18 or above, insertion should succeed.

--Example Scenarios:
--Allowed:
--Insert student whose age is 18 or more.

--Blocked:
--Insert student whose age is below 18.

--Expected Output:
--If age < 18:
--Student must be at least 18 years old.
--Record is not inserted.

--If age ≥ 18:
--Record is inserted successfully.

---------------------------------------------

--### Conceptual Questions:

--1. What is the difference between an AFTER trigger and an INSTEAD OF trigger?
--2. Can triggers return values?
--3. Does a trigger run per row or per statement?
--4. What data is stored in the inserted and deleted tables?
--5. Can multiple AFTER triggers be created on the same table for the same operation?
--6. Can multiple INSTEAD OF triggers be created on a single table for the same operation?
--7. In an INSTEAD OF trigger, are values present in the inserted and deleted tables while inserting and deleting records?
--8. Can a trigger be created on a view? If yes, which type of trigger can be created on a view: AFTER trigger,INSTEAD OF trigger,or both?