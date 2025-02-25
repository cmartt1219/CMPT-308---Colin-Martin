/*
Colin Martin 
Lab 4: SQL Queries - The Subqueries Sequel
Due: During Week 4/5

Note that all of my queries seem to correctly match what it should be based on the CAP screenshot. I am mentioning
that here so that I don't have to keep writing it underneath each question.

Also note that at the end of the shown AI outputs I am providing a grade for how well it performed.
It is out of 10.
*/

-- 1. Get all the People data for people who are customers
Select *
From People
Where pid in (
	Select pid
	From Customers
);
/*
AI Output:
-- 1. Get all the People data for people who are customers
SELECT *
FROM People
WHERE pid IN (SELECT pid FROM Customers);

This gives us the desired output and is practically the same query as mine, however having 
'Select' and 'From' on the same line in the subquery feels like it is improper pracitce. 9.5/10
*/

-- 2. Get	all	the	People	data	for	people	who	are	agents.
Select *
From People
Where pid in (
	Select pid
	From Agents
);
/*
AI Output:
-- 2. Get all the People data for people who are agents
SELECT *
FROM People
WHERE pid IN (SELECT pid FROM Agents);

Same description from above applies here. 9.5/10 
*/

-- 3. Get	all	of	People	data	for	people	who	are	both	customers	and	agents.
Select *
From People
Where pid in (
	Select pid
	From Customers
)
  and pid in (
  	Select pid
	From Agents
);
-- We can also ask for the intersection of tables
Select *
From People
Where pid in (
	Select pid
	From Customers
	  Intersect
	Select pid
	From Agents
);
/*
AI Output:
-- 3. Get all of People data for people who are both customers and agents
SELECT *
FROM People
WHERE pid IN (
    SELECT pid FROM Customers
    INTERSECT
    SELECT pid FROM Agents
);

Same description from above questions still applies here. 9.5/10
*/

-- 4. Get	all	of	People	data	for	people	who	are	neither	customers	nor	agents.
Select *
From People
Where pid not in (
	Select pid
	From Customers
	  Union
	Select Pid
	From Agents
);
/*
AI Output:
-- 4. Get all of People data for people who are neither customers nor agents
SELECT *
FROM People
WHERE pid NOT IN (SELECT pid FROM Customers)
AND pid NOT IN (SELECT pid FROM Agents);

This one does differ from mine a bit, since I used union but the AI method still works.
Still has the indentation issue, now including the 'and' statement with a lack of indentation. 9.4/10
*/


-- 5. Get	the	ID	of	customers	who	ordered	either	product	p01 or p03	(or	both).	List	the	IDs	
-- in	order	from	lowest	to	highest.	Include	each	ID	only	once.
Select distinct pid
From Customers
Where pid in (
	Select custId
	From Orders
	Where prodId in ('p01', 'p03')
)
Order by pid ASC;
/*
AI Output:
-- 5. Get the ID of customers who ordered either product p01 or p03 (or both)
SELECT DISTINCT custId
FROM Orders
WHERE prodId IN ('p01', 'p03')
ORDER BY custId;

Now, while I was doing this question, I was still in a subquery headspace and did not think
about doing it this way. The AI method still works and does not include the subquery, so I will 
give it the deserved credit, aside from it not including ASC in the order by statement. If I recall
correctly, you told us not to do this, thus following this logic I am giving it another 9.5/10.
*/

-- 6. Get the ID of	customers who ordered both products p01 and p03. List the IDs in order	
-- from	highest	to lowest. Include each	ID only	once.
Select distinct pid
From Customers
Where pid in (
	Select custId
	From Orders
	Where prodId in ('p01')
	  Intersect
	Select custId
	From Orders
	Where prodId in ('p03')
)
Order by pid DESC;

/*
AI Output:
-- 6. Get the ID of customers who ordered both products p01 and p03
SELECT custId
FROM Orders
WHERE prodId = 'p01'
INTERSECT
SELECT custId
FROM Orders
WHERE prodId = 'p03'
ORDER BY custId DESC;

Same sort of deal as in the above question, the AI did not use a subquery and I did because I
was still in the subquery headspace. I'll give a 10/10 because this is still correct. However, I
am a tad suprised that the AI did not use subqueries for these questions given that the title
of the lab includes the word subquery, and I gave the model the file of this lab. Just something
I thought I'd point out.
*/

-- 7. Get the first	and	last names of agents who sold products	p05	or p07 in order	by last	
-- name	from A to Z.
Select firstName, lastName
From People
Where pid in (
	Select agentId
	From Orders
	Where prodId in ('p05', 'p07')
)
Order by lastName ASC;

/*
AI Output:
-- 7. Get the first and last names of agents who sold products p05 or p07
SELECT firstName, lastName
FROM People
WHERE pid IN (
    SELECT agentId
    FROM Orders
    WHERE prodId IN ('p05', 'p07')
)
ORDER BY lastName;

So close. Literally had the exact same query as mine until the end as it did not include 
ASC after lastName. 9.5/10
*/

-- 8. Get the home city	and	birthday of	agents booking an order	for	the	customer whose	
-- pid is 007, sorted by home city from Z to A.
Select homeCity, DOB
From People
Where pid in (
	Select agentId
	From Orders
	Where custId = 007
)
Order by homeCity ASC;
/*
AI Output:
-- 8. Get the home city and birthday of agents booking an order for the customer whose pid is 007
SELECT homeCity, DOB
FROM People
WHERE pid IN (
    SELECT agentId
    FROM Orders
    WHERE custId = (
        SELECT pid
        FROM Customers
        WHERE pid = 007  -- Assuming 007 is replaced by the actual ID of the customer
    )
)
ORDER BY homeCity DESC;

The AI added an extra subquery, but that's still fine, the output is still (mostly) the same as mine and 
it is still a proper method to go about it. Something interesting about this specific query is that
I originally wrote DESC after homeCity at the end, but it outputted in A to Z order with 'in Georgia'
before 'Pinner'. This is why I have ASC, because that placed Pinner first. After trying to look up
the reason as to why, I believe it is because 'in' is all lower case and 'Pinner' has a capital P,
overall meaning that postgres must prioritize words starting in capital letters over ones that don't.
Because of this, the AI gets an 8.5/10 since it did not compensate for this.
*/

-- 9. Get the unique ids of	products ordered through any agent	who	takes at least one	
-- order from a	customer in	Saginaw, sorted	by id from highest to lowest. (This is not the	
-- same	as asking for ids of products ordered by customers	in Saginaw.)
Select distinct prodId
From Orders
Where agentId in (
	Select agentId
 	From Orders                 
  	Where custId in ( 
		Select pid
	  	From People 
	 	Where homeCity = 'Saginaw'
	)	
) 
Order by prodId DESC;
/*
AI Output:
-- 9. Get the unique ids of products ordered through any agent who takes at least one order from a customer in Saginaw
SELECT DISTINCT prodId
FROM Orders
WHERE agentId IN (
    SELECT pid
    FROM People
    WHERE homeCity = 'Saginaw'
)
ORDER BY prodId DESC;

This is the first query the AI gave me that is just plain incorrect. It did not include custId at all,
which is a crucial step in creating this specific query as you MUST account for the fact that the question
is asking, "...ordered through any agent who takes at least one order from a customer..." The AI is paying the
price in that its query provides no output. It didn't give us an error, just no values. This is unfortunately
going to have to be a 0/10.
*/

-- 10. Get the last	name and home city for all customers who place	orders through agents in	
-- Regina or Pinner	in order by	last name from A to	Z.
Select lastName, homeCity
From People
Where pid in ( 
	Select custId
	From Orders
	Where agentId in (
		Select pid
		From People
		Where homeCity in ('Regina', 'Pinner')
	)
)
Order by lastName ASC;
/*
AI Output:
-- 10. Get the last name and home city for all customers who place orders through agents in Regina or Pinner
SELECT lastName, homeCity
FROM People
WHERE pid IN (
    SELECT custId
    FROM Orders
    WHERE agentId IN (
        SELECT pid
        FROM People
        WHERE homeCity IN ('Regina', 'Pinner')
    )
)
ORDER BY lastName;

This again has the issue where it was correct the whole way through and matched my exact query
up until the end, where there is no ASC. 9.5/10
*/

/*
Overall, the AI did a decent job, not as great as the last lab, but it still gave the desired output for 
every question except number 9. The biggest take away here are the problems it has with formatting and 
indentation, signifying that if it is making this issue now, then it will continue to do so moving 
forward; at least when it comes to subqueries. 
*/


	