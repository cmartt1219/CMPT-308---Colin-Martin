/*
Colin Martin 
Lab 10: Stored Procedures

Here is my SQL code for the 2 questions correlating to Lab 10. I included some sample select statements
to check whether or not they work, and it seems that they do! 

Although this is my last lab, I definitely don't imagine that I will be done with SQL anytime soon, and I 
am ready to take everything that I learned in this class into the real world!
*/

/*
Question 1:
function PreReqsFor(courseNum)	-	Returns	the	immediate	prerequisites	for	the	
passed-in	course	number.
*/
CREATE OR REPLACE FUNCTION PreReqsFor(courseNum INT)
RETURNS TABLE (
	preReqNum INT,
	preReqName TEXT,
	preReqCredits INT
)
AS
$$
BEGIN
	RETURN QUERY
	SELECT c.num, c.name, c.credits
	FROM Courses c INNER JOIN Prerequisites p ON c.num = p.preReqNum
	WHERE p.courseNum = PreReqsFor.courseNum;
END;
$$
LANGUAGE plpgsql;

SELECT *
FROM PreReqsFor(499);

/*
Question 2:
function IsPreReqFor(courseNum)	-	Returns	the	courses	for	which	the	passed-in	course	
number	is	an	immediate	pre-requisite.
*/

CREATE OR REPLACE FUNCTION IsPreReqFor(courseNum INT)
RETURNS TABLE (
	courseNumber INT,
	courseName TEXT,
	courseCredits INT
)
AS
$$
BEGIN
	RETURN QUERY
	SELECT c.num, c.name, c.credits
	FROM Courses c INNER JOIN Prerequisites p ON c.num = p.courseNum
	WHERE p.preReqNum = IsPreReqFor.courseNum;
END;
$$
LANGUAGE plpgsql;

SELECT *
FROM IsPreReqFor(308);




