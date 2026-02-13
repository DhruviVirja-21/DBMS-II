--Trigger (After trigger) 
-- Table : Log(LogMessage varchar(100), logDate Datetime) 
CREATE TABLE LOG(
	LogMessage varchar(100),
	logDate Datetime
);

--Part – A 
--1. Create trigger for printing appropriate message after student registration. 
GO
CREATE OR ALTER TRIGGER TR_STUREGISTRATION
ON STUDENT
AFTER INSERT
AS BEGIN
	PRINT'STUDENT IS REGISTRATED.'
END;

INSERT INTO STUDENT VALUES
(11,'PRIYAGUPTA','priya@univ.edu ','8876543211','IT ','2002-07-22 ','2020' )

DROP TRIGGER TR_STUREGISTRATION


--2. Create trigger for printing appropriate message after faculty deletion.
INSERT INTO FACULTY VALUES(108,'PRO.SHARMA','SHARMA@GMAIL.COM','IT','Professor','2008-03-25 ' )
GO 
CREATE OR ALTER TRIGGER TR_FACULTYDELETE
ON FACULTY
AFTER DELETE
AS BEGIN
	PRINT'FACULTY IS SUCCESFULLY DELETED.'
END

DELETE FROM FACULTY
WHERE FacultyName='PRO.SHARMA'

DROP TRIGGER TR_FACULTYDELETE

--3. Create trigger for monitoring all events on course table. (print only appropriate message) 
GO
create or alter trigger tr_after_course_monitor
on Course
for insert,update,delete
as
begin
	if exists(select * from inserted) AND exists(select * from deleted)
		begin
			print 'Update performed on Course Table'
		end
	else if exists(select * from inserted)
		begin
			print 'Insert performed on Course Table'
		end
	else if exists(select * from deleted)
		begin
			print 'Delete performed on Course Table'
		end
end

select * from Course

insert into Course values('CS405','Computer Peripherals',3,'CS',2)

update course set coursecredits=4 where CourseID='CS405'

delete from Course where CourseID='CS405'

drop trigger tr_after_course_monitor

--4. Create trigger for logging data on new student registration in Log table.

GO
CREATE OR ALTER TRIGGER TR_registration
ON STUDENT
FOR INSERT
AS 
BEGIN
	DECLARE @ID INT,@NAME VARCHAR(100),@EMAIL VARCHAR(100),@PHONE VARCHAR(15),@DPT VARCHAR(50),@DOB DATE,@YR INT;
	SELECT @ID = StudentID, @NAME = StuName, @EMAIL = StuEmail, @PHONE = StuPhone, @DPT = StuDepartment, @DOB = StuDateOfBirth, @YR = StuEnrollmentYear from inserted
	INSERT INTO LOG VALUES('Student with id = '+CAST(@ID as varchar)+' name = '+@NAME+' department = '+@DPT+' added succesfully',GETDATE())
	PRINT('Student Registered Succesfully');
END

INSERT INTO STUDENT VALUES (12,'YKYK','YK@MEMAIL.COM','9876583210','YKS','2006-01-13',2026);
SELECT *FROM LOG
DROP TRIGGER TR_registration

--5. Create trigger for auto-uppercasing faculty names. 
GO
CREATE OR ALTER TRIGGER TR_UPPER
ON FACULTY 
AFTER INSERT
AS
BEGIN
	DECLARE @FID INT;
	DECLARE @FNAME VARCHAR(100)
	SELECT @FNAME=FacultyName,@FID=FacultyID
	FROM INSERTED

	UPDATE FACULTY
	SET FacultyName=UPPER(@FNAME)
	WHERE FacultyID=@FID
END

INSERT INTO FACULTY VALUES(108 ,'Prof. Gupta' ,'gupta@univ.edu','IT', 'Associate Prof', '2012-08-20')
SELECT * FROM FACULTY

DROP TRIGGER TR_UPPER


--6. Create trigger for calculating faculty experience (Note: Add required column in faculty table) 
ALTER TABLE FACULTY ADD experience INT;
GO
CREATE OR ALTER TRIGGER TR_CALC_EXP
ON FACULTY
AFTER INSERT
AS
BEGIN
    DECLARE @FID INT;
    DECLARE @FacultyJoiningDate DATE;

    SELECT @FacultyJoiningDate = FacultyJoiningDate, 
           @FID = FacultyID
    FROM INSERTED;

    UPDATE FACULTY
    SET experience = DATEDIFF(YEAR, @FacultyJoiningDate, GETDATE())
    WHERE FacultyID = @FID;
END


INSERT INTO FACULTY VALUES(109 ,'Prof. ABC' ,'gupta@univ.edu','IT', 'Associate Prof', '2012-08-20',NULL)
SELECT * FROM FACULTY

DROP TRIGGER TR_CALC_EXP

--Part – B 

--7. Create trigger for auto-stamping enrollment dates. 

GO
CREATE OR ALTER TRIGGER TR_ENROLLMENT_DATE
ON ENROLLMENT
AFTER INSERT
AS
BEGIN
	UPDATE E
	SET EnrollmentDate = GETDATE()
	FROM ENROLLMENT E
	JOIN INSERTED I ON E.EnrollmentID = I.EnrollmentID
	WHERE E.EnrollmentDate IS NULL

	PRINT 'Enrollment Date Auto-Stamped'
END

INSERT INTO ENROLLMENT(StudentID,CourseID,EnrollmentDate,Grade,EnrollmentStatus)
VALUES(3,'CS301',NULL,NULL,'Active')

SELECT * FROM ENROLLMENT

DROP TRIGGER TR_ENROLLMENT_DATE



--8. Create trigger for logging data After course assignment - log course and faculty detail. 

GO
CREATE OR ALTER TRIGGER TR_LOG_COURSE_ASSIGNMENT
ON COURSE_ASSIGNMENT
AFTER INSERT
AS
BEGIN
	DECLARE @CID VARCHAR(10),@FID INT,@SEM INT,@YR INT,@ROOM VARCHAR(20)

	SELECT @CID=CourseID,@FID=FacultyID,@SEM=Semester,@YR=Year,@ROOM=ClassRoom
	FROM INSERTED

	INSERT INTO LOG
	VALUES('Course '+@CID+' assigned to FacultyID '+CAST(@FID AS VARCHAR)+' for Semester '+CAST(@SEM AS VARCHAR)+' Year '+CAST(@YR AS VARCHAR)+' Room '+@ROOM,GETDATE())

	PRINT 'Course Assignment Logged Successfully'
END

INSERT INTO COURSE_ASSIGNMENT VALUES('CS101',101,1,2025,'A-101')

SELECT * FROM LOG

DROP TRIGGER TR_LOG_COURSE_ASSIGNMENT



--Part - C 

--9. Create trigger for updating student phone and print the old and new phone number. 

GO
CREATE OR ALTER TRIGGER TR_UPDATE_PHONE
ON STUDENT
AFTER UPDATE
AS
BEGIN
	IF UPDATE(StuPhone)
	BEGIN
		DECLARE @OldPhone VARCHAR(15),@NewPhone VARCHAR(15),@Name VARCHAR(100)

		SELECT @OldPhone=D.StuPhone,@NewPhone=I.StuPhone,@Name=I.StuName
		FROM INSERTED I
		JOIN DELETED D ON I.StudentID=D.StudentID

		PRINT 'Student: '+@Name
		PRINT 'Old Phone: '+@OldPhone
		PRINT 'New Phone: '+@NewPhone
	END
END

UPDATE STUDENT SET StuPhone='9999999999' WHERE StudentID=1

DROP TRIGGER TR_UPDATE_PHONE



--10. Create trigger for updating course credit log old and new credits in log table. 

GO
CREATE OR ALTER TRIGGER TR_COURSE_CREDIT_LOG
ON COURSE
AFTER UPDATE
AS
BEGIN
	IF UPDATE(CourseCredits)
	BEGIN
		DECLARE @CID VARCHAR(10),@OldCredit INT,@NewCredit INT

		SELECT @CID=I.CourseID,
			   @OldCredit=D.CourseCredits,
			   @NewCredit=I.CourseCredits
		FROM INSERTED I
		JOIN DELETED D ON I.CourseID=D.CourseID

		INSERT INTO LOG
		VALUES('Course '+@CID+' Credit Changed From '+CAST(@OldCredit AS VARCHAR)+' To '+CAST(@NewCredit AS VARCHAR),GETDATE())

		PRINT 'Course Credit Change Logged'
	END
END

UPDATE COURSE SET CourseCredits=5 WHERE CourseID='CS101'

SELECT * FROM LOG

DROP TRIGGER TR_COURSE_CREDIT_LOG



-------------------# Lab-6: AFTER Trigger – Extra Questions--------------------

--### For Query 3 : Monitoring Specific Events on COURSE Table
--Create an AFTER trigger on the COURSE table to monitor all operations (INSERT, UPDATE, DELETE).
--**Task:**
--Instead of printing a common message, print operation-specific messages:
--- INSERT → *Course record inserted*
--- UPDATE → *Course record updated*
--- DELETE → *Course record deleted*

--**Hint:**
--Use the *inserted* and *deleted* tables to detect which operation occurred.
---------------------------------------------------------------------

--### For Query 4 : Logging Data on New Student Registration
--**1) Example Output in LOG Table**
--*(Hint: Use variables OR directly select values from inserted table.)*
--**Expected Log Format:**
--Student with StudentID - 105, Name - Rahul, Department - IT added successfully!


--**2) If rows are inserted one-by-one, how many times will the trigger run?**
--**Example: inserting rows individually**
--INSERT INTO STUDENT VALUES(23,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);
--INSERT INTO STUDENT VALUES(24,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);
--INSERT INTO STUDENT VALUES(25,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);


--**3) If multiple students are inserted in a single INSERT statement, how many times does the trigger run?**

--**Example: inserting multiple students at once**
--INSERT INTO STUDENT VALUES(29,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
--(30,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024),
--(31,'Jay Patel','jay@univ.edu','9879999084','CSE','2005-09-18',2024);

--**Questions:**
--- How many times does the trigger execute?
--- How many log entries are inserted into the LOG table?

-------------------------------------------------------------------

--------------------## Conceptual Questions------------------
--1. Can triggers return values?
--2. Does a trigger run per row or per statement?
--3. What data is stored in the inserted and deleted tables?
--4. Can multiple AFTER triggers be created on the same table for the same operation?
--5. Can a trigger be created on a view? If yes, which type of trigger can be created on a view: AFTER trigger, INSTEAD OF trigger, or both?
