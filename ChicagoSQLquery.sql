--select * from [dbo].[ChicagoCensusData]


--Exercise1,Question1: 
--Write and execute a SQL query to list the school names, community names 
--and average attendance for communities with a hardship index of 98. 

select NAME_OF_SCHOOL, COMMUNITY_AREA_NAME,AVERAGE_STUDENT_ATTENDANCE 
from ChicagoPublicSchools 
Where COMMUNITY_AREA_NUMBER=
		(select COMMUNITY_AREA_NUMBER from ChicagoCensusData
			where HARDSHIP_INDEX=98)

--Exercise 1, Question 2: 
--Write and execute a SQL query to list all crimes that took place at a school. 
--Include case number, crime type and community name.

select cr.CASE_NUMBER, cr.PRIMARY_TYPE, p.COMMUNITY_AREA_NAME 
from ChicagoCrimeData cr inner join ChicagoPublicSchools p 
on cr.COMMUNITY_AREA_NUMBER=p.COMMUNITY_AREA_NUMBER
where lower(cr.LOCATION_DESCRIPTION) Like '%school%'

--Exercise 2, Question 1: 
--Write and execute a SQL statement that returns just the school name and leaders’ icon from the view. 

create view school_view (School_Name, Safety_Rating, Family_Rating, Environment_Rating, 
Instruction_Rating, Leaders_Rating, Teachers_Rating) 
	AS
	select NAME_OF_SCHOOL,Safety_Icon, Family_Involvement_Icon,
			Environment_Icon,Instruction_Icon,Leaders_Icon,Teachers_Icon 
			from ChicagoPublicSchools

select * from school_view
select school_name, leaders_rating from school_view

--drop view school_view

--Exercise 3, Question 1: 
--Write the structure of a query to create or replace a stored procedure called UPDATE_LEADERS_SCORE that 
--takes a in_School_ID parameter as an integer and a in_Leader_Score parameter as an integer. 
--Don't forget to use the #SET TERMINATOR statement to use the @ for the CREATE statement terminator.

select * from ChicagoPublicSchools
drop procedure UPDATE_LEADERS_SCORE

--#SET TERMINATOR @
create procedure UPDATE_LEADERS_SCORE(@in_School_ID INTEGER, @in_Leader_Score INTEGER)
AS
	BEGIN
	select COMMUNITY_AREA_NAME  from ChicagoPublicSchools
		where School_ID=@in_School_ID AND Leaders_Score=@in_Leader_Score
	END
--@

Exec UPDATE_LEADERS_SCORE 610212, 43

--Exercise 3, Question 2: 
--Inside your stored procedure, write a SQL statement to update the Leaders_Score field 
--in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID to the value 
--in the in_Leader_Score parameter. 

ALTER procedure UPDATE_LEADERS_SCORE(@in_School_ID INTEGER, @in_Leader_Score INTEGER)
AS
	BEGIN
		UPDATE ChicagoPublicSchools 
			SET Leaders_Score=@in_Leader_Score
			where School_ID=@in_School_ID
	END
--@

--Exercise 3, Question 3: 
--Inside your stored procedure, write a SQL IF statement to update the Leaders_Icon field 
--in the CHICAGO_PUBLIC_SCHOOLS table for the school identified by in_School_ID using the 
--following information. 
ALTER procedure UPDATE_LEADERS_SCORE(@in_School_ID INTEGER, @in_Leader_Score INTEGER) AS
BEGIN TRANSACTION
	IF @in_Leader_Score >80 AND @in_Leader_Score < 100 
		BEGIN
			UPDATE ChicagoPublicSchools 
			SET Leaders_Icon='Very strong'
		END
	ELSE IF @in_Leader_Score >60 AND @in_Leader_Score < 80 
		BEGIN
			UPDATE ChicagoPublicSchools 
			SET Leaders_Icon='Strong'
		END
	ELSE IF @in_Leader_Score >40 AND @in_Leader_Score < 60 
		BEGIN
			UPDATE ChicagoPublicSchools 
			SET Leaders_Icon='Average'
		END
	ELSE IF @in_Leader_Score >20 AND @in_Leader_Score < 40
		BEGIN
			UPDATE ChicagoPublicSchools 
			SET Leaders_Icon='Weak'
		END
	ELSE IF @in_Leader_Score >0 AND @in_Leader_Score < 20
		BEGIN
			UPDATE ChicagoPublicSchools 
			SET Leaders_Icon='Very weak'
		END
	ELSE 
		ROLLBACK
COMMIT TRANSACTION
--@

EXEC UPDATE_LEADERS_SCORE 610019, 50

select School_ID, Leaders_Score, Leaders_Icon from ChicagoPublicSchools where School_ID=610019 AND Leaders_Score='50'

EXEC UPDATE_LEADERS_SCORE 609709, 101

select School_ID, Leaders_Score, Leaders_Icon from ChicagoPublicSchools where School_ID=609709 AND Leaders_Score='101'