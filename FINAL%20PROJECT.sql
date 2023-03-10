--SELECT * FROM CHICAGO_CENSUS_DATA;
--SELECT * FROM CHICAGO_PUBLIC_SCHOOLS;

-- #USING JOINS 
--Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.

SELECT P.NAME_OF_SCHOOL, P.COMMUNITY_AREA_NAME, P.AVERAGE_STUDENT_ATTENDANCE 
FROM CHICAGO_PUBLIC_SCHOOLS P 
LEFT OUTER JOIN CHICAGO_CENSUS_DATA C ON P.COMMUNITY_AREA_NUMBER= C.COMMUNITY_AREA_NUMBER
WHERE C.HARDSHIP_INDEX= 98;

--Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.
SELECT CCD.CASE_NUMBER, CCD.PRIMARY_TYPE, CD.COMMUNITY_AREA_NAME 
FROM CHICAGO_CRIME_DATA CCD 
LEFT OUTER JOIN CHICAGO_CENSUS_DATA CD ON CCD.COMMUNITY_AREA_NUMBER= CD.COMMUNITY_AREA_NUMBER
WHERE CCD.LOCATION_DESCRIPTION LIKE '%SCHOOL%';

--Creating a View 
CREATE VIEW SCHOOL_RECORD (SCHOOL_NAME, SAFETY_RATING,FAMILY_RATING,ENVIRONMENT_RATING,INSTRUCTION_RATING,LEADERS_RATING,TEACHERS_RATING)
AS SELECT NAME_OF_SCHOOL, SAFETY_ICON, FAMILY_INVOLVEMENT_ICON,ENVIRONMENT_ICON, INSTRUCTION_ICON, LEADERS_ICON, TEACHERS_ICON 
FROM CHICAGO_PUBLIC_SCHOOLS; 

SELECT * FROM SCHOOL_RECORD;
SELECT SCHOOL_NAME, LEADERS_RATING FROM SCHOOL_RECORD;

--Creating a Stored Procedure 
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
IN SCHOOL_ID INTEGER, IN LEADERS_SCORE INTEGER)
LANGUAGE SQL 
READS SQL DATA                      
DYNAMIC RESULT SETS 1              
BEGIN 
 DECLARE C1 CURSOR               -- CURSOR C1 will handle the result-set by retrieving records row by row from the table
    WITH RETURN FOR                 -- This routine will return retrieved records as a result-set to the caller query
    
    SELECT SCHOOL_ID, LEADERS_SCORE FROM CHICAGO_PUBLIC_SCHOOLS;          -- Query to retrieve all the records from the table
    
    OPEN C1;                        -- Keeping the CURSOR C1 open so that result-set can be returned to the caller query

END 
@

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
IN IN_SCHOOL_ID INTEGER, IN IN_LEADERS_SCORE INTEGER)
LANGUAGE SQL
MODIFIES SQL DATA

BEGIN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS 
	SET LEADERS_SCORE= IN_LEADERS_SCORE
	WHERE SCHOOL_ID= IN_SCHOOL_ID;
END 
@

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
IN IN_SCHOOL_ID INTEGER, IN IN_LEADERS_SCORE INTEGER)
LANGUAGE SQL 
MODIFIES SQL DATA 

BEGIN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS 
	SET LEADERS_SCORE= IN_LEADERS_SCORE
	WHERE SCHOOL_ID= IN_SCHOOL_ID;
	
	IF IN_LEADERS_SCORE > 0 AND IN_LEADERS_SCORE > 20 THEN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET LEADERS_ICON = 'Very_weak'
	WHERE SCHOOL_ID= IN_SCHOOL_ID;
	
	ELSEIF IN_LEADERS_SCORE<40 THEN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET LEADERS_ICON = 'Weak'
	WHERE SCHOOL_ID= IN_SCHOOL_ID;
	
	ELSEIF IN_LEADERS_SCORE < 60 THEN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET LEADERS_ICON = 'Average'
	WHERE SCHOOL_ID= IN_SCHOOL_ID; 
	
	ELSEIF IN_LEADERS_SCORE < 80 THEN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET LEADERS_ICON = 'Strong'
	WHERE SCHOOL_ID= IN_SCHOOL_ID;
	
	ELSEIF IN_LEADERS_SCORE< 100 THEN 
	UPDATE CHICAGO_PUBLIC_SCHOOLS
	SET LEADERS_ICON = 'Very_strong'
	WHERE SCHOOL_ID= IN_SCHOOL_ID;
	
	--ELSE ROLLBACK WORK;
	END IF;
	--COMMIT WORK;
END 
@

CALL UPDATE_LEADERS_SCORE(609720, 50)